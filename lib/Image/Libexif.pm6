use v6;
unit class Image::Libexif:ver<0.0.1>;

use Image::Libexif::Raw;
use Image::Libexif::Constants;
use NativeCall;
use NativeHelpers::Blob;

class X::Libexif is Exception
{
  has Int $.errno;
  has Str $.error;

  method message { "Error {$!errno}: $!error"; }
}

has ExifData $!exif;

submethod BUILD(Str :$file?, Buf :$data?)
{
  with $file {
    if $file.IO.e {
      $!exif = exif_data_new_from_file $file;
    } else {
      fail X::Libexif.new: errno => 1, error => "File $file not found";
    }
  } orwith $data {
    $!exif = exif_data_new_from_data nativecast(Pointer[uint8], $data), $data.bytes;
  } else {
    $!exif = exif_data_new;
  }
}

method info
{
  my %info;
  %info<ordercode> = exif_data_get_byte_order $!exif;
  %info<orderstr> = exif_byte_order_get_name %info<ordercode>;
  %info<datacount> = exif_data_get_data_type $!exif;
  %info<tagcount> = $!exif.ifd0.count + $!exif.ifd1.count + $!exif.ifd2.count + $!exif.ifd3.count + $!exif.ifd4.count;
  # TODO are there more info to share?
  %info;
}

method close
{
  with $!exif {
    exif_data_free $!exif;
  }
}

method lookup(uint32 $tag --> Str)
{
  my ExifEntry $entry = exif_content_get_entry($!exif.ifd0, $tag) ||
  exif_content_get_entry($!exif.ifd1, $tag) ||
  exif_content_get_entry($!exif.ifd2, $tag) ||
  exif_content_get_entry($!exif.ifd3, $tag) ||
  exif_content_get_entry($!exif.ifd4, $tag);
  my Buf $buf .= allocate: $entry.components, 0;
  exif_entry_get_value($entry, $buf, 9);
}

multi method tags(Int $group where 0 <= * < 5)
{
  # raw-allinfo2.p6
  # raw-taginfo.p6 for tag descriptions
  # 0 - image_info
  # 1 - camera_info
  # 2 - other_info
  # 3 - point_shoot_info (GPS)
  # 4 - unknown_info
  my %tags;
  my Buf $buf .= allocate: 100, 0;

  sub callback (ExifEntry $entry, Pointer[void] $dummy) {
    my $val = exif_entry_get_value($entry, $buf, 100);
    %tags{$entry.tag.fmt('0x%04x')} = $val.trim;
    }

  my Pointer[void] $dummy .= new;
  my ExifContent $content = $!exif."ifd$group"();
  exif_content_foreach_entry($content, &callback, $dummy);
  %tags;
}

method thumbnail
{
  # raw-thumbnail.p6
}

=begin pod

=head1 NAME

Image::Libexif - An OO interface to libexif

=head1 SYNOPSIS
=begin code
use v6;

use Image::Libexif;

sub MAIN($file! where { .IO.f // die "file $file not found" })
{
  my Image::Libexif $e .= new: :$file;
}
=end code

=head1 DESCRIPTION

For more details on libexif see L<https://github.com/libexif>.

=head1 Prerequisites

This module requires the libexif library to be installed. Please follow the
instructions below based on your platform:

=head2 Debian Linux

=begin code
sudo apt-get install libexif12
=end code

The module looks for a library called libexif.so.

=head1 Installation

To install it using zef (a module management tool):

=begin code
$ zef install Image::Libexif
=end code

=head1 Testing

To run the tests:

=begin code
$ prove -e "perl6 -Ilib"
=end code

=head1 Author

Fernando Santagata

=head1 License

The Artistic License 2.0

=end pod

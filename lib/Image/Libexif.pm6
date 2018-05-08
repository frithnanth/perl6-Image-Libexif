use v6;
unit class Image::Libexif:ver<0.0.1>;

use NativeCall;
use Image::Libexif::Raw;
use Image::Libexif::Constants;

sub exif_content_get_entry_all(ExifData $exif, uint32 $tag --> ExifEntry) is export
{
  exif_content_get_entry($exif.ifd0, $tag) ||
  exif_content_get_entry($exif.ifd1, $tag) ||
  exif_content_get_entry($exif.ifd2, $tag) ||
  exif_content_get_entry($exif.ifd3, $tag) ||
  exif_content_get_entry($exif.ifd4, $tag);
}

=begin pod

=head1 NAME

Image::Libexif - An OO interface to libexif

=head1 SYNOPSIS
=begin code

use v6;

use Image::Libexif;


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

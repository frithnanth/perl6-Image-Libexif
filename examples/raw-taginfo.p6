#!/usr/bin/env perl6

use lib 'lib';
use Image::Libexif::Raw;
use Image::Libexif::Constants;

my $file = 't/sample01.jpg';

sub callback (ExifEntry $entry, UserData $data) {
  -> ExifEntry $entry, Str $data {
    say "$data: ",
        $entry.tag.fmt('0x%04x '),
        ExifTag.^enum_from_value($entry.tag).fmt('%-39s ');
    my ($desc, $prev);
    for ExifIfd.enums.values.sort -> $id {
      my $out = exif_tag_get_description_in_ifd($entry.tag, $id);
      if $out.defined {
        if $prev.defined && $out eq $prev {
          last;
        } else {
          $desc ~= "$out\n";
          $prev = $out;
        }
      }
    }
    say "$desc";
  }($entry, $file);
}

my ExifData $exif = exif_data_new();
$exif = exif_data_new_from_file($file);
my UserData $user-data .= new;
for 0..4 {
  my ExifContent $content = $exif."ifd$_"();
  exif_content_foreach_entry($content, &callback, $user-data);
}

#!/usr/bin/env perl6

use lib 'lib';
use Image::Libexif::Raw;
use Image::Libexif::Constants;

my ExifData $exif = exif_data_new();
$exif = exif_data_new_from_file('t/sample01.jpg');
for 0..4 {
  my ExifContent $content = $exif."ifd$_"();
  exif_content_dump($content, 0);
}

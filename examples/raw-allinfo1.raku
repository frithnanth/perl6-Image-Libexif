#!/usr/bin/env raku

use lib 'lib';
use Image::Libexif::Raw;
use Image::Libexif::Constants;

sub MAIN($file! where { .IO.f // die "file $file not found" })
{
  my ExifData $exif = exif_data_new();
  $exif = exif_data_new_from_file($file);
  for ^5 {
    my ExifContent $content = $exif.ifd[$_];
    exif_content_dump($content, 0);
  }
}

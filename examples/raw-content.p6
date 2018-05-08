#!/usr/bin/env perl6

use lib 'lib';
use Image::Libexif::Raw;
use Image::Libexif::Constants;
use NativeCall;

my $file = 't/sample01.jpg';
my ExifData $exif = exif_data_new();
$exif = exif_data_new_from_file($file);
my Pointer[void] $dummy .= new;
exif_data_foreach_content($exif,
  sub (ExifContent $content, Pointer[void] $dummy) {
    -> ExifContent $content {
      exif_content_dump($content, 0);
    }($content);
  },
  $dummy);

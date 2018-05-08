#!/usr/bin/env perl6

use lib 'lib';
use Image::Libexif;
use Image::Libexif::Raw;
use Image::Libexif::Constants;

my ExifData $exif = exif_data_new();
$exif = exif_data_new_from_file('t/sample01.jpg');
my ExifEntry $entry = exif_content_get_entry_all($exif, EXIF_TAG_MAKE);
my Buf $buf .= allocate: $entry.components, 0;
say exif_entry_get_value($entry, $buf, 9);

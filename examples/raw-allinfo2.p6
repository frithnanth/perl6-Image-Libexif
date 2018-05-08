#!/usr/bin/env perl6

use lib 'lib';
use Image::Libexif::Raw;
use Image::Libexif::Constants;
use NativeCall;

my $file = 't/sample01.jpg';

sub callback (ExifEntry $entry, Pointer[void] $dummy) {
  -> ExifEntry $entry, Str $data {
    my Buf $buf .= allocate: 100, 0;
    say "$data: ",
        $entry.tag.fmt('0x%04x '),
        ExifTag.^enum_from_value($entry.tag).fmt('%-39s '),
        exif_entry_get_value($entry, $buf, 100);
  }($entry, $file);
}

my ExifData $exif = exif_data_new();
$exif = exif_data_new_from_file($file);
my Pointer[void] $dummy .= new;
for 0..4 {
  my ExifContent $content = $exif."ifd$_"();
  exif_content_foreach_entry($content, &callback, $dummy);
}

my $mnote = exif_data_get_mnote_data($exif);
my $notes = exif_mnote_data_count($mnote);
my $val = Buf.new(1..1024);
for 1..$notes -> $note {
  say "$file: ",
    exif_mnote_data_get_description($mnote, $note) // ' ', ' ',
    exif_mnote_data_get_name($mnote, $note) // ' ', ' ',
    exif_mnote_data_get_title($mnote, $note) // ' ', ' ',
    exif_mnote_data_get_value($mnote, $note, $val, 1024);
}

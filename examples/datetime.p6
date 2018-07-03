#!/usr/bin/env perl6

use Concurrent::File::Find;
use lib 'lib';
use Image::Libexif;
use Image::Libexif::Constants;

#| This program displays the EXIF date and time for every file in a directory tree
sub MAIN($dir where {.IO.d // die "$dir not found"})
{
  my @f := find $dir, :extension('jpg'), :exclude-dir('thumbnails') :file, :!directory;
  @f.race.map: {
      .say;
      my Image::Libexif $e .= new: :file($_);
      with $e {
        try .lookup(EXIF_TAG_DATE_TIME_ORIGINAL).say;
        .close;
      }
    }
}

#!/usr/bin/env perl6

use lib 'lib';
use Image::Libexif;

#| This program extracts an EXIF thumbnail from an image and saves it into a new file (in the same directory as the original).
sub MAIN($file! where { .IO.f // die "file '$file' not found" })
{
  my Image::Libexif $e .= new;
  my $data = $e.thumbnail: $file;
  my $thumb-name = $file;
  $thumb-name ~~ s/\.jpg/_thumb.jpg/;
  spurt $thumb-name, $data, :bin;
}

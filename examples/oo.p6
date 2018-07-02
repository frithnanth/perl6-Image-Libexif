#!/usr/bin/env perl6

use lib 'lib';
use Image::Libexif;

sub MAIN($file! where { .IO.f // die "file $file not found" })
{
  my Image::Libexif $e .= new: :$file;
  # TODO
}

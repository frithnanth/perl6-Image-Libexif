#!/usr/bin/env perl6

use lib 'lib';
use Image::Libexif;
use Image::Libexif::Constants;

sub MAIN($file! where { .IO.f // die "file $file not found" })
{
  my Image::Libexif $e .= new: :$file;
  my @tags := $e.alltags: :tagdesc;
  say @tags».keys.flat.elems ~ ' tags found';
  my constant @groupdesc = 'Image info', 'Camera info', 'Shoot info', 'GPS info', 'Interoperability info';
  for ^EXIF_IFD_COUNT -> $group {
    say "Group $group: @groupdesc[$group]";
    for %(@tags[$group]).kv -> $k, @v {
      say "$k: @v[1] => @v[0]";
    }
  }
}

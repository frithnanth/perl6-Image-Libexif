[![Actions Status](https://github.com/frithnanth/perl6-Image-Libexif/workflows/test/badge.svg)](https://github.com/frithnanth/perl6-Image-Libexif/actions)

NAME
====

Image::Libexif - High-level bindings to libexif

SYNOPSIS
========

```raku
use v6;

use Image::Libexif :tagnames;
use Image::Libexif::Constants;

sub MAIN($file! where { .IO.f // die "file $file not found" })
{
  my Image::Libexif $e .= new: :$file;
  my @tags := $e.alltags: :tagdesc;
  say @tags».keys.flat.elems ~ ' tags found';
  for ^EXIF_IFD_COUNT -> $group {
    say "Group $group: " ~ «'Image info' 'Camera info' 'Shoot info' 'GPS info' 'Interoperability info'»[$group];
    for %(@tags[$group]).kv -> $k, @v {
      say "%tagnames{$k.Int}: @v[1] => @v[0]";
    }
  }
}
```

```raku
use v6;

use Concurrent::File::Find;
use Image::Libexif;
use Image::Libexif::Constants;

#| This program displays the EXIF date and time for every file in a directory tree
sub MAIN($dir where {.IO.d // die "$dir not found"})
{
  my @files := find $dir, :extension('jpg'), :exclude-dir('thumbnails') :file, :!directory;
  @files.race.map: -> $file {
      my Image::Libexif $e .= new: :file($file);
      try say "$file " ~ $e.lookup(EXIF_TAG_DATE_TIME_ORIGINAL); # don't die if no EXIF is present
      $e.close;
    }
}
```

DESCRIPTION
===========

Image::Libexif provides an OO interface to libexif.

use Image::Libexif;
-------------------

use Image::Libexif :tagnames;
-----------------------------

If asked to import the additional symbol **tagnames**, Image::Libexif will make available the Hash %tagnames, which has tag numbers as keys and a short description as values.

new(Str :$file?, Buf :$data?)
-----------------------------

Creates an Image::Libexif object.

If the optional argument **$file** is provided, then it will be opened and read; if not provided during the initialization, the program may call the **open** method later. If the optional argument **data** is provided, then the object will be initialized from the provided data; if not provided during the initialization, the program may call the **load** method later.

open(Str $file!)
----------------

Opens a file and reads it into an initialiazed object (when no file or data has been provided during initialization).

load(Buf $data!)
----------------

Reads the data into an initialiazed object (when no file or data has been provided during initialization).

close
-----

Closes the internal libexif object, frees the memory and cleans up.

info(--> Hash)
--------------

Gathers some info:

  * ordercode - the byte order as a code

  * orderstr - the byte order as a string

  * datatype - the data type

  * tagcount - the number of tags

lookup(Int $tag!, Int $group! --> Str)
--------------------------------------

lookup(Int $tag! --> Str)
-------------------------

Looks up a tag in a specific group or in all groups. A tag may be present in more than one group. Group names are available as constants:

  * IMAGE_INFO

  * CAMERA_INFO

  * SHOOT_INFO

  * GPS_INFO

  * INTEROPERABILITY_INFO

tags(Int $group! where 0 <= * < 5, :$tagdesc? --> Hash)
-------------------------------------------------------

Delivers all the tags in a specific group into a hash; the keys are the tag numbers. If the tag description is requested, the hash values are presented as an array [value, tag description].

alltags(:$tagdesc? --> Array)
-----------------------------

Delivers an array of hashes, one for each group. If the tag description is requested, the hash values are presented as an array [value, tag description].

notes(--> Array)
----------------

Reads the Maker Note data as an array of strings. Each string is a concatenation of the note description, name, title, and value.

method thumbnail($file where { .IO.f // fail X::Libexif.new: errno => 1, error => "File $_ not found" } --> Blob)
-----------------------------------------------------------------------------------------------------------------

sub thumbnail($file where { .IO.f // fail X::Libexif.new: errno => 1, error => "File $_ not found" } --> Blob) is export(:thumbnail)
------------------------------------------------------------------------------------------------------------------------------------

Returns the thumbnail found in the original file, if any, as a Blob. This functionality is available as a method and a sub, since the library doesn't really need a fully initialized exif object. To use the sub import it explicitly: **use Image::Libexif :thumbnail;**.

Errors
------

There one case when an error may be returned: trying to open a non-existent file. This can happen while initializing an object with .new() and calling the .open() method. In both cases the method will return a Failure object, which can be trapped and the exception can be analyzed and acted upon.

Prerequisites
=============

This module requires the libexif library to be installed. Please follow the instructions below based on your platform:

Debian Linux
------------

    sudo apt-get install libexif12

The module looks for a library called libexif.so.

Installation
============

To install it using zef (a module management tool):

    $ zef install Image::Libexif

Testing
=======

To run the tests:

    $ prove -e "raku -Ilib"

Author
======

Fernando Santagata

Contributions
=============

Many thanks to Lizmat.

License
=======

The Artistic License 2.0


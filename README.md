## Image::Libexif

Image::Libexif - An interface to libexif.

## Build Status

| Operating System  |   Build Status  | CI Provider |
| ----------------- | --------------- | ----------- |
| Linux             | [![Build Status](https://travis-ci.org/frithnanth/perl6-Image-Libexif.svg?branch=master)](https://travis-ci.org/frithnanth/perl6-Image-Libexif)  | Travis CI |

## Example

Raw interface:

```Perl6
use v6;

use Image::Libexif::Raw;
use Image::Libexif::Constants;
use NativeHelpers::Blob;

#| This program extracts an EXIF thumbnail from an image and saves it into a new file (in the same directory as the original).
sub MAIN($file! where { .IO.f // die "file '$file' not found" })
{
  my $l = exif_loader_new() // die ’Can't create an exif loader‘;
  # Load the EXIF data from the image file
  exif_loader_write_file($l, $file);
  # Get the EXIF data
  my $ed = exif_loader_get_data($l) // die ’Can't get the exif data‘;
  # The loader is no longer needed--free it
  exif_loader_unref($l);
  $l = Nil;
  if $ed.data && $ed.size {
    my $thumb-name = $file;
    $thumb-name ~~ s/\.jpg/_thumb.jpg/;
    my $data = blob-from-pointer($ed.data, :elems($ed.size), :type(Blob));
    spurt $thumb-name, $data, :bin;
  } else {
    say "No EXIF thumbnail in file $file";
  }
  # Free the EXIF data
  exif_data_unref($ed);
}
```

For more examples see the `example` directory.

## Description

Image::Libexif provides an interface to libexif and allows you to access the EXIF records of an image.

## Documentation

#### new()

## Prerequisites
This module requires the libexif library to be installed. Please follow the instructions below based on your platform:

### Debian Linux

```
sudo apt-get install libexif12
```

The module looks for a library called libexif.so.

## Installation

To install it using zef (a module management tool):

```
$ zef update
$ zef install Image::Libexif
```

## Testing

To run the tests:

```
$ prove -e "perl6 -Ilib"
```

## Note

Archive::Libexif relies on a C library which might not be present in one's
installation, so it's not a substitute for a pure Perl6 module.

## Author

Fernando Santagata

## Copyright and license

The Artistic License 2.0

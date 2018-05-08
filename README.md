## Image::Libexif

Image::Libexif - An interface to libexif.

## Build Status

| Operating System  |   Build Status  | CI Provider |
| ----------------- | --------------- | ----------- |
| Linux             | [![Build Status](https://travis-ci.org/frithnanth/perl6-Image-Libexif.svg?branch=master)](https://travis-ci.org/frithnanth/perl6-Image-Libexif)  | Travis CI |

## Example

```Perl6
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

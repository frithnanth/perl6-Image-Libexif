## Image::Libexif

Image::Libexif - .

## Build Status

| Operating System  |   Build Status  | CI Provider |
| ----------------- | --------------- | ----------- |
| Linux             | [![Build Status](https://travis-ci.org/frithnanth/perl6-Image-Libexif.svg?branch=master)](https://travis-ci.org/frithnanth/perl6-Image-Libexif)  | Travis CI |

## Example

```Perl6
```

For more examples see the `example` directory.

## Description


## Documentation

#### new()


### Errors

When the underlying library returns an error condition, the methods will return a Failure object, which can
be trapped and the exception can be analyzed and acted upon.

The exception object has two fields: $errno and $error, and return a message stating the error number and
the associated message as delivered by libarchive.

## Prerequisites
This module requires the libexif library to be installed. Please follow the instructions below based on your platform:

### Debian Linux

```
sudo apt-get install libexif12
```

The module looks for a library called libexif.so, or whatever it finds in
the environment variable `PERL6_LIBEXIF_LIB` (provided that the library one
chooses uses the same API).

## Installation

To install it using zef (a module management tool):

```
$ zef update
$ zef install Archive::Libarchive
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

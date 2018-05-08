use v6;
unit class Image::Libexif:ver<0.0.1>;

use NativeCall;
use Image::Libexif::Raw;
use Image::Libexif::Constants;

sub exif_content_get_entry_all(ExifData $exif, uint32 $tag --> ExifEntry) is export
{
  exif_content_get_entry($exif.ifd0, $tag) ||
  exif_content_get_entry($exif.ifd1, $tag) ||
  exif_content_get_entry($exif.ifd2, $tag) ||
  exif_content_get_entry($exif.ifd3, $tag) ||
  exif_content_get_entry($exif.ifd4, $tag);
}

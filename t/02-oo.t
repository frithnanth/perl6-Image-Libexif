#!/usr/bin/env perl6

use Test;
use lib 'lib';
use Image::Libexif;
use Image::Libexif::Constants;

my Image::Libexif $e2;

subtest {
  my Image::Libexif $e1 .= new;
  isa-ok $e1, Image::Libexif, 'simple initialization';
  $e2 .= new: :file('t/sample01.jpg');
  isa-ok $e2, Image::Libexif, 'initialization from file';
  throws-like
    { Image::Libexif.new: :file('nonexistent') }, # No assignment: it would throw
    X::Libexif,
    message => /'File nonexistent not found'/,
    'Open non-existent file fails';
  my $buffer = slurp 't/sample01.jpg', :bin;
  my Image::Libexif $e3 .= new: :data($buffer);
  isa-ok $e3, Image::Libexif, 'initialization from raw data';
  lives-ok { $e3.close }, 'close and free';
  lives-ok {my @promises;
            for ^5 {@promises.push: start {my $ee = Image::Libexif.new: :file('t/sample01.jpg'); sleep .1; $ee.close}}
            await @promises},
          'concurrency';
}, 'initialization';

my %info = $e2.info;
is-deeply %info, {:datacount(4), :ordercode(1), :orderstr("Intel"), :tagcount(54)}, 'info';

subtest {
  is $e2.lookup(EXIF_TAG_MAKE), 'FUJIFILM', 'tag lookup';
  $e2.tags(0);
}, 'tags';

done-testing;

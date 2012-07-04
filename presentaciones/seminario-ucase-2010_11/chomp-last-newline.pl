#!/usr/bin/perl

use strict;
use warnings;

my $a = join "", <>;
unless(chomp($a)) {
    $a =~ s/\n([^\n]*)$/$1/;
}
print $a;

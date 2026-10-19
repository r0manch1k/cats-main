#!perl

use strict;
use warnings;

use List::Util qw(sum);

open my $fin, '<input.txt';
open my $fout, '>output.txt';

undef $/;
$_ = <$fin>;
my @n = split;
print $fout sum(@n);

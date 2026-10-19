#!perl

use strict;
use warnings;

sub ex {
    my ($ec, $s, $ln) = @_;
    print $s;
    defined $ln and print " in pos $ln";
    exit $ec;
}

@ARGV == 3 or die;
open my $fin, '<', $ARGV[0] or ex(3, "Error opening input: $!");
open my $fout, '<', $ARGV[1] or ex(2, "Error opening output: $!");
open my $fans, '<', $ARGV[2] or ex(3, "Error opening answer: $!");

my $i = 0;
while (1) {
    ++$i;
    my $o = <$fout>;
    my $a = <$fans>;
    ex(0, 'ok') if !defined $a && !defined $o;
    ex(2, 'Extra lines', $i) if !defined $a;
    ex(2, 'Too few lines', $i) if !defined $o;
    chomp $o; chomp $a;
    ex(1, "lines differ", $i) if $o ne $a;
}

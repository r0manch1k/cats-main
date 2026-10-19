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

sub get_int {
    my ($file, undef, $ec, $ln) = @_;
    while (!$_[1] || !@{$_[1]}) {
        $_ = <$file>;
        $_ // return;
        $_[1] = [ split ];
    }
    my $s = shift @{$_[1]};
    $s =~ /^[+-]?[0-9]+$/ or ex($ec, "'$s' is not an integer", $ln);
    0 + $s;
}

my ($bin, $bout, $bans);

my $i = 0;
while (1) {
    ++$i;
    my $o = get_int($fout, $bout, 3, $i);
    my $a = get_int($fans, $bans, 2, $i);
    ex(0, 'ok') if !defined $a && !defined $o;
    ex(2, 'Extra numbers', $i) if !defined $a;
    ex(2, 'Too few numbers', $i) if !defined $o;
    ex(1, "$o instead of $a", $i) if $o != $a;
}

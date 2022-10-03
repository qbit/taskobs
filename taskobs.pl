#!/usr/bin/env perl

use strict;
use warnings;
use POSIX qw(strftime);

use v5.32;

use JSON qw( from_json );

my $outputFile = shift || '/home/qbit/Brain/TaskWarrior.md';
my $tasks      = from_json(`task export`);
my $date       = strftime "%Y-%m-%d", localtime;
my @output;

push @output, "*Updated: [[Daily/$date]]*";
push @output, "";
push @output, "ID | Description | Urg";
push @output, "-- | ----------- | ---";
foreach my $t (@$tasks) {
    if ( $t->{status} ne 'completed' ) {
        push @output, "$t->{id} | $t->{description} | $t->{urgency} ";
    }
}

open( FH, '>', $outputFile ) or die $!;
print FH join "\n", @output;
close FH;

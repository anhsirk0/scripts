#!/usr/bin/env perl

use strict;
use warnings;

use Time::HiRes qw(sleep);

local $| = 1;

sub progress_bar {
    my ( $total, $current ) = @_;
    my $bar_length = 50;
    my $progress   = int( $bar_length * $current / $total );
    my $bar        = '=' x $progress . ' ' x ( $bar_length - $progress );
    print "\r[$bar] " . sprintf( "%.2f%%", ( $current / $total ) * 100 );
}

my $total_steps = 10;

for my $i ( 0 .. $total_steps ) {
    progress_bar( $total_steps, $i );
    sleep(0.1);
}

print "\nDone!\n";

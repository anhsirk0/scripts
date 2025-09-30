#!/usr/bin/env perl

use strict;
use warnings;

sub get_duration {
    my ($name) = shift;
    return `ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 '$name'`;
}

my @files = ();

for (@ARGV) {
    next unless -f;
    push(@files, { path => $_, duration => get_duration($_)});
}

# Sort videos by duration
@files = sort { $a->{duration} <=> $b->{duration} } @files;

foreach my $video (@files) {
    printf "%.2f: %s seconds\n", $video->{duration}, $video->{path};
}

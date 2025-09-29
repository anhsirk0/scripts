#!/usr/bin/env perl

use POSIX qw(strftime);

my $date_time = strftime "%Y-%m-%d %H:%M:%S", localtime;
my ($minute) = $date_time =~ /.*:(\d+):.*$/;
print "$date_time ";

chomp(my $input = <STDIN>);

unless ($minute =~ m/$input/) {
    print "You entered: $input\n";
    exit
}

my $browser = 'chromium';
my $base_dir = $ENV{HOME} . "/.config";
my $orig = $base_dir . "/chromium";
my $sec = $base_dir . "/chrox";
my $bak = $base_dir . "/chromium_bak";

sub load {
    if (-d $sec) {
        if (-d $orig) {
            system "mv $orig $bak";
            print "Loaded::WithBackup\n";
        }
        system "mv $sec $orig";
        print "Loaded::Main\n";
    }
}

sub unload {
        system "mv $orig $sec";
        if (-d $bak) {
            system "mv $bak $orig";
            print "Unloaded::WithBackup\n";
        }
        print "Unloaded::Main\n";
}

load();
system($browser);
unload();

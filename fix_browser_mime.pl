#!/usr/bin/env perl

use strict;
use warnings;

my @browsers        = ( "firefox", "waterfox", "brave", "chromium", "chrome" );
my $dir             = "/usr/share/applications";
my @types_to_remove = (
    "application/json",        "application/pdf",
    "application/rdf+xml",     "application/rss+xml",
    "application/x-xpinstall", "application/xhtml+xml",
    "application/xml",         "audio/flac",
    "audio/ogg",               "audio/webm",
    "image/avif",              "image/gif",
    "image/jpeg",              "image/png",
    "image/svg+xml",           "image/webp",
    "video/ogg",               "video/webm",

    # "text/html",               "text/xml",
    # "x-scheme-handler/chrome", "x-scheme-handler/http",
    # "x-scheme-handler/https",  "x-scheme-handler/mailto"
);

sub read_file {
    my $file_path = shift;
    my $content;
    my $mime_types;
    open( FH, "<", $file_path ) or die "Could not open file '$file_path'";
    while (<FH>) {
        $content .= $_;
        if ( $_ =~ m/^MimeType=/ ) {
            my ($types) = m/^MimeType=(.*)$/;
            $mime_types = $types;
        }
    }
    close(FH);
    return ( $content, $mime_types );
}

sub write_file {
    my ( $file_path, $content ) = @_;
    open( FH, '>', $file_path )
      or die
"Could not open file '$file_path' (you have to run this script as root) $!";
    print FH $content;
    close(FH);
}

sub main {
    foreach my $browser (@browsers) {
        my $file_path = "$dir/$browser.desktop";
        if ( -f $file_path ) {
            print "Updating '$file_path'\n";
            my ( $content, $mime_types ) = read_file($file_path);
            my $new_mime_types = "";
            foreach my $mt ( split ";", $mime_types ) {
                unless ( grep { $_ eq $mt } @types_to_remove ) {
                    $new_mime_types .= $mt . ";";
                }
            }
            $content =~ s/MimeType=.*\n/MimeType=$new_mime_types\n/;

            write_file( $file_path, $content );
            print "Updated '$file_path'\n";
        }
    }
}

main();

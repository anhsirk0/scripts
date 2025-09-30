#!/usr/bin/env perl

use strict;
use Cwd qw( getcwd );
use File::Find;
use Getopt::Long;
use Term::ANSIColor;
use warnings;

# for cli args
my $HELP;
my $LIST;
my $KIND;
my $NAME;

my @KINDS = ( "helper", "component", "component-with-props" );

# colors
my %COLOR = (
    "GREEN"   => "bright_green",
    "YELLOW"  => "yellow",
    "MAGENTA" => "bright_magenta",
    "RED"     => "red",
    "CYAN"    => "bright_cyan",
    );

sub error {
    my $msg = shift;
    die colored("[rex] $msg", $COLOR{RED}) . "\n";
}

sub info {
    my $msg = shift;
    print colored("[rex] $msg", $COLOR{GREEN}) . "\n";
}

sub read_input {
    my $prompt = shift;
    print colored($prompt . ": ", $COLOR{CYAN});
    chomp(my $answer = <STDIN>);
    return $answer;
}

sub add_helper {
    $NAME = read_input "Name" unless $NAME;
    error "File name cannot contain spaces" if $NAME =~ m/\s/;

    my $file_name = $NAME . ".ts";
    error "File '$file_name' already exists" if -f $file_name;

    my $content;
    open(FH, '>', $file_name) or error "Could not create file '$file_name'";
    $content = qq{function $NAME() {
  return "$NAME";
};

export default $NAME;
};
    print FH $content;
    close FH;
    info "Created '$NAME' helper";

    # update `index.ts`
    open(FH, '>>', "index.ts") or error "Could not create file 'index.ts'";
    $content = qq{export { default as $NAME } from "./$NAME";\n};
    print FH $content;
    close FH;
    info "Updated 'index.ts'";
}

sub add_component {
    $NAME = read_input "Name" unless $NAME;
    error "File name cannot contain spaces" if $NAME =~ m/\s/;

    my $file_name = $NAME . ".tsx";
    error "File '$file_name' already exists" if -f $file_name;

    my $content;
    open(FH, '>', $file_name) or error "Could not create file '$file_name'";
    $content = qq{import { Center, Text } from "@/components";

const $NAME = () => {
  return (
    <Center>
      <Text>$NAME</Text>
    </Center>
  );
};

export default $NAME;
};
    print FH $content;
    close FH;
    info "Created '$NAME' component";
}

sub add_component_with_props {
    $NAME = read_input "Name" unless $NAME;
    error "File name cannot contain spaces" if $NAME =~ m/\s/;

    my $file_name = $NAME . ".tsx";
    error "File '$file_name' already exists" if -f $file_name;

    my $content;
    my @props = ();
    my $read_props = 1;

    while ($read_props) {
        my $prop = read_input "Prop [name: type] [leave blank if done]";
        $read_props = 0 unless $prop;
        push @props, $prop if $prop;
    }

    my $type_props = join ";\n  ", @props;
    my $args_props = join ", ", map { (split ":", $_)[0] } @props;
    
    open(FH, '>', $file_name) or error "Could not create file '$file_name'";
    $content = qq{import { FC } from "react";

// local imports
import { Center, Text } from "@/components";

type Props = {
  $type_props;
}

const $NAME: FC<Props> = ({ $args_props }) => {
  return (
    <Center>
      <Text>$NAME</Text>
    </Center>
  );
};

export default $NAME;
};
    print FH $content;
    close FH;
    info "Created '$NAME' component";
}

sub format_option {
    my ($short, $long, $desc) = @_;
    my $text = "\t" . colored("-" . $short, $COLOR{GREEN});
    my $tabs = "\t";
    $text .= ", " . colored("--" . $long . " ", $COLOR{GREEN});
    $text .= $tabs . $desc;
    return $text . "\n";
}

sub print_help_and_exit {
    my $kinds = join("|", @KINDS);
    printf(
        "%s\n\n%s\n\n" . # About, Usage
        "%s \n%s%s\n" . # Options list
        "%s\n%s\n%s\n", # Args
        colored("rex", $COLOR{GREEN}) . "\nInit code files for react projects.",
        colored("USAGE:", $COLOR{YELLOW}) . "\n\trex <KIND> <NAME> [OPTIONS]",
        colored("OPTIONS:", $COLOR{YELLOW}),
        format_option("l", "list", "List available <KIND>"),
        format_option("h", "help", "Print help information"),
        colored("ARGS:", $COLOR{YELLOW}),
        colored("\t<KIND>", $COLOR{GREEN}) . "\t\t$kinds",
        colored("\t<NAME>", $COLOR{GREEN}) . "\t\tname of the <$kinds>",
        );
    exit;
}

sub print_list_and_exit {
    print join("\n", @KINDS) . "\n";
    exit;
}

sub parse_args {
    GetOptions (
        "help|h" => \$HELP,
        "list|l" => \$LIST,
        ) or error "Error in command line arguments";
    print_list_and_exit if $LIST;
    print_help_and_exit if $HELP || !@ARGV;
    ($KIND, $NAME) = @ARGV;
}

sub main {
    parse_args;
    if ($KIND eq "helper") {
        add_helper;
    } elsif ($KIND eq "component") {
        add_component;
    } elsif ($KIND eq "component-with-props") {
        add_component_with_props;
    } else {
        print_help_and_exit;
    }
}

main()

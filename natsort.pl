
my @arr = ("f2.txt", "f12.txt" , "f10.txt", "f.txt");

sub natsort {
    my ($digits_a) = $a =~ /(\d+)/;
    my ($digits_b) = $b =~ /(\d+)/;
    unless ($digits_a) { $digits_a = -1 }
    unless ($digits_b) { $digits_b = -1 }

    if ($digits_a * $digits_b < 0 || $digits_a + $digits_b < 0) {
	$a <=> $b
    }
    $digits_a <=> $digits_b
}

# @arr = sort natsort @arr;

foreach my $f (sort natsort @arr) {
    print $f . "\n";
}

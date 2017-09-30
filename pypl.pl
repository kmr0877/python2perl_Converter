#!/usr/bin/perl -w
$num_args = $#ARGV + 1;
if ($num_args > 1) {
    print "\nToo many arguments.";
    exit;
}
elsif($num_args < 1){
	print "\nToo few arguments.";
}
$python_script = $ARGV[0];
sub in {
	foreach $element (@_[1..$#_]){
		if($_[0] eq $element){
			return '';
		}
	}
	return 1;
}

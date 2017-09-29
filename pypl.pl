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

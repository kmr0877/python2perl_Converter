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

open(my $fh, '<:encoding(UTF-8)', $python_script)
  or die "Could not open file '$python_script' $!";
sub in {
    foreach $element (@_[1..$#_]){
        if($_[0] eq $element){
            return '';
        }
    }
    return 1;
}


sub get_variables{
    $i = 0;
    foreach $row (@lines){
        if($row =~ m/([\t]*\w[\w0-9_]*)[ ]*=/){
            if(in $1,@vars){
                $vars[$i] = $1;
                $i ++;
            }
        }
    }
}

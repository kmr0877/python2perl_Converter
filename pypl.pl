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

sub end_lines{
    foreach $row (@lines){
        if(!($row =~ m/:\n/) and !($row eq "\n") and !($row eq "") and !($row =~ m/^#/)){
            $row =~ s/([\w\W]*)\n/$1;\n/;
        }
    }
}
sub translate_code{
	foreach $row (@lines){
		if(!(substr($row,0,1) eq "#")){
			foreach $var (@vars){
				while($row =~ m/([^\w\$]+[ ]*)($var)([ ]*[^\w\$]+)(?=(?:[^"]*"[^"]*")*[^"]*$)/){
					$row =~ s/([^\w\$]+[ ]*)($var)([ ]*[^\w\$]+)(?=(?:[^"]*"[^"]*")*[^"]*$)/$1\$$2$3/g;
				}
				$row =~ s/^($var)([ ]*=)/\$$1$2/g;
			}
			if($row =~ m/break/ and !($row =~ m/\"[\w\W]*break[\w\W]*\"/)){
				$row =~ s/break/last/;
			}
			if($row =~ m/^import[ ]*[\w]*/ or $row =~ m/from[ ]*[\w]*[ ]*import/){
				$row = "";
			}
			if(($row =~ m/print\(/ or $row =~ m/sys.stdout.write/)){
				$row =~ s/sys.stdout.write\(([\w\W]*)\)/print $1/;
				$row =~ m/print[ ]*\(([\w\W]*)\)/;
				$tmp = $1;
				if ( $tmp eq ""){
				$row =~ s/print[ ]*\(([\w\W]*)\)/print "\\n"/;

				}
				else{
				$row =~ s/print[ ]*\(([\w\W]*)\)/print $tmp,"\\n"/;
			}
				
			}	
			if($row =~ m/sys.stdin.readline/){
				$row =~ s/=[\w\W]*\(sys.stdin.readline\(([\w\W]*)\)\)/= <STDIN>/;
			}
		}
	}
}
sub fix_if{
    foreach $i (0 .. $#lines){
        if($lines[$i] =~ m/([ ]*)elif[ ]*[\w\W]*:/){
            $tab = $1;
            $bracket = 0;
            $lines[$i] =~ s/([ ]*)elif[ ]*([\w\W]*):/$1elsif\($2\)\{/;
            foreach $j (($i+1) .. $#lines){
                $lines[$j] =~ m/([ ]*)\w/;
                if(length($tab) >= length($1)){
                    $lines[$j] = "}".$lines[$j];
                    $bracket = 1;
                    last;
                }
            }
            if($bracket == 0){
                    $lines[$#lines] = $lines[$#lines]."}";
            }
        }
	if($lines[$i] =~ m/([ ]*)if[ ]*[\w\W]*:/){
            $tab = $1;
            $bracket = 0;
            $lines[$i] =~ s/([ ]*)if[ ]*([\w\W]*):/$1if\($2\)\{/;
            foreach $j (($i+1) .. $#lines){
                $lines[$j] =~ m/([ ]*)\w/;
                if(length($tab) >= length($1)){
                    $lines[$j] = "}".$lines[$j];
                    $bracket = 1;
                    last;
                }
            }
            if($bracket == 0){
                    $lines[$#lines] = $lines[$#lines]."}";
            }
        }
	if($lines[$i] =~ m/([ ]*)else[ ]*[\w\W]*:/){
		$tab = $1;
		$bracket = 0;
		$lines[$i] =~ s/([ ]*)else[ ]*([\w\W]*):/$1else\{/;
		foreach $j (($i+1) .. $#lines){
			$lines[$j] =~ m/([ ]*)\w/;
			if(length($tab) >= length($1)){
				$lines[$j] = "}".$lines[$j];
				$bracket = 1;
				last;
			}
		}
		if($bracket == 0){
			$lines[$#lines] = $lines[$#lines]."}";
		}
	}

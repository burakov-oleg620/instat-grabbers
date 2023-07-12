package read_inifile;
use strict;
use warnings;

sub new {
	my $class = shift;
	my $file = shift;
	my $self = {};
	open (my $fh, $file) or die;
	while (<$fh>) {
		my $pattern1 = '\'(.+?)\'' ; my $temp1 = ();
		while ($_ =~ /$pattern1/g) {
			push (@$temp1, $1); 
			if (scalar (@$temp1) == 2) {
				my $pattern2 = '\|\|'; 
				if ($temp1 -> [1] =~ /$pattern2/) {
					my $temp2 = (); @$temp2 = split ($pattern2, $temp1 -> [1]);
					$self -> {$temp1->[0]} = $temp2; 
				} else {
					$self -> {$temp1->[0]} = $temp1 -> [1]; 
				}
			}
		}
	}
	close ($fh); 
	return bless $self;
}

sub get {
	my $self = shift;
	my $str = shift;
	if (exists $self -> {$str}) {
		return $self -> {$str};
	} else {return undef};
}

1;
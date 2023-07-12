package get_max;
use strict;
use warnings;

sub new {
	my $class = shift;
	my $self = {}; 
	my $max = 0;
	$self->{max} = $max;
	return bless $self;
}

sub do {
	my $self = shift;
	my $str = shift;
	my $max = $self->{max}; 
	if ($str > $max) {
		$max = $str;
		$self->{max} = $max;
	}
	return $max;
}

sub get {
	my $self = shift;
	my $max = $self->{max}; 
	return $max;
}


1; 
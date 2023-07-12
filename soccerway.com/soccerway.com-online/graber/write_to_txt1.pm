package write_to_txt1;
use strict;
use warnings;

sub new {
	my $class = shift;
	my $self = {}; 
	$self -> {p} = (); 	
	return bless $self;
}

sub put {
	my $self = shift;
	my $str = shift;
	my $temp = $self -> {p}; 
	push (@$temp, $str); 
	$self -> {p} = $temp; 
	return $str; 
}

sub get {
	my $self = shift;
	my $p = $self -> {p}; 
	my $str = undef;
	$str = join ("\t", @$p);
	return $str;
}

1;


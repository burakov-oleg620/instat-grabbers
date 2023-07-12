package work_for_content; 
use strict;
use warnings;

sub new {
	my $class = shift;
	my $str = shift;
	my $self = {}; 
	$self->{str} = $str; 
	return bless $self;
}

sub get_pattern {
	my $self = shift;
	my $pattern = shift; 
	my $str = $self -> {str}; 
	my $array = ();
	while ($str =~ /$pattern/g) {push (@$array, $1);}
	return $array;
}

sub get_type {
	my $self = shift;
	my $pattern = shift; 
	my $str = $self -> {str}; 
	if ($str =~ /$pattern/i) {
		return 'ok'
	} else {
		return 'nok';
	}
}

sub get_split_pattern {
	my $self = shift;
	my $pattern = shift; 
	my $str = $self -> {str}; 
	my @str = (); my $array = ();
	if ($str =~ /$pattern/i) {
		@str = split ($pattern, $str);
		foreach (@str) {
			push (@$array, $_)
		}
		return $array; 
	} else {
		push (@$array, 'nok');
		return $array;
	}
}


1; 

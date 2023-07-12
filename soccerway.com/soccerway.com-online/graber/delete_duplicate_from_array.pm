package delete_duplicate_from_array; 
use strict;
use warnings;

sub new {
	my $class = shift;
	my $array = ();
	@$array = @_;
	my $self = {};
	$self->{array} = $array; 
	return bless $self;
}

sub do {
	my $self = shift;
	my $array = $self -> {array}; 
	@$array = _delete_duplicate_from_array (@$array); 
	return @$array; 
}


sub _delete_duplicate_from_array {
	my @array = @_;
	my %h;
	@array = grep (!$h{"$_"}++, @array);
	return @array;
}

1;
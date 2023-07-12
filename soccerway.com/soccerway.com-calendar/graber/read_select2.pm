package read_select2;
use strict;
use warnings;
use clear_str; 

sub new {
	my $class = shift;
	my $file = shift;
	my $self = {};
	my $select = []; 
	
	open (my $fh, $file) or die;
	while (<$fh>) {
		my $clear_str = clear_str -> new ($_); 
		$_ =  $clear_str -> delete_4 ();
		$clear_str = undef;
		if ($_ ne '') {
			push (@$select, $_);
		}
	}
	close ($fh); 
	$self -> {select} = $select;
	return bless $self;
}

sub get {
	my $self = shift;
	my $select = $self -> {select}; 
	return @$select;
}

1;	
package txt_to_csv;
use strict;
use warnings;
use clear_str; 

sub new {
	my $class = shift;
	my $str = shift;
	my $self = {}; 
	$self -> {str} = $str; 	
	return bless $self;
}

sub do {
	my $self = shift;
	my $str = $self->{str};
	my $temp = [];
	@$temp = split ("\t", $str); 
	foreach (@$temp) {
		my $clear_str = clear_str -> new ($_); 
		$_ = $clear_str -> delete_4 ();
		$clear_str = undef;
		$_ = '"'.$_.'"'
	}
	$str = join (';', @$temp); 
	return $str; 
}

1;


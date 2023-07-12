package read_select1;
use strict;
use warnings;

sub new {
	my $class = shift;
	my $file = shift;
	my $self = {};
	my $url = (); my $select = ();  
	
	open (my $fh, $file) or die;
	while (<$fh>) {
		my $pattern = '\'(.+?)\'.+?\'(.+?)\'';
		while ($_ =~ /$pattern/g) {
			push (@$url, $1); 
			push (@$select, $2); 
		}
	}
	close ($fh); 
	$self -> {url} = $url;
	$self -> {select} = $select;
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
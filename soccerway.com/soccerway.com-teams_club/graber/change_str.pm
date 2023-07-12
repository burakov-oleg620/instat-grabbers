package change_str;
use strict;
use warnings;

sub new {
	my $class = shift;
	my $str = shift;
	my $self = {}; 
	$self->{str} = $str; 
	return bless $self;
}

sub do  {
	my $self = shift;
	my $str = $self -> {str}; 
	my $pattern1 = shift;
	my $pattern2 = shift;
	$str =~ s/$pattern1/$pattern2/g;
	return $str;
}
	
1; 
package url_to_file;
use strict;
use warnings;



sub new {
	my $class = shift;
	my $str = shift;
	my $self = {}; 
	$self->{str} = $str; 
	return bless $self;
}

sub do {
	my $self = shift;
	my $str = $self -> {str};
	$str =~ s/\s+/_/g;
	# $str =~ s/\.+/_/g;
	$str =~ s/\//_/g;
	$str =~ s/\?/_/g;
	$str =~ s/\:/_/g;
	$str =~ s/=+/_/g;
	$str =~ s/\"/_/g;
	$str =~ s/\'/_/g;
	$str =~ s/\(/_/g;
	$str =~ s/\)/_/g;
	$str =~ s/_+/_/g;
	return $str;
}

sub do2 {
	my $self = shift;
	my $str = $self -> {str};
	$str =~ s/\s+/ /g;
	# $str =~ s/\.+/_/g;
	$str =~ s/\//_/g;
	$str =~ s/\?/_/g;
	$str =~ s/\:/_/g;
	$str =~ s/=+/_/g;
	$str =~ s/\"/_/g;
	$str =~ s/\'/_/g;
	$str =~ s/\(/_/g;
	$str =~ s/\)/_/g;
	$str =~ s/_+/_/g;
	return $str;
}

1;
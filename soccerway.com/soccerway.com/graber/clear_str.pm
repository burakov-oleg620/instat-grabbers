package clear_str;
use strict;
use warnings;

sub new {
	my $class = shift;
	my $str = shift;
	my $self = {}; 
	$self->{str} = $str; 
	return bless $self;
}

sub delete_1 {
	my $self = shift;
	my $str = $self -> {str}; 
	my $pattern = undef;
	$pattern = '\n+'; 
	$str =~ s/$pattern//g; 
	$pattern = '\r+'; 
	$str =~ s/$pattern//g; 
	$self -> {str} = $str; 
	return $str; 
}

sub delete_2 {
	my $self = shift;
	my $str = $self -> {str}; 
	my $pattern = undef;
	$pattern = '&ndash;'; 
	$str =~ s/$pattern/-/g; 
	$pattern = '&quot;'; 
	$str =~ s/$pattern/ /g; 
	$pattern = '&nbsp;'; 
	$str =~ s/$pattern/ /g; 
	$pattern = '&mdash;'; 
	$str =~ s/$pattern/ /g; 
	$pattern = '&amp;'; 
	$str =~ s/$pattern/ /g; 
	$self -> {str} = $str; 
	return $str; 
}

sub delete_3 {
	my $self = shift;
	my $str = $self -> {str}; 
	my $pattern = undef;
	$pattern = '<.+?>'; 
	$str =~ s/$pattern//g; 
	$self -> {str} = $str; 
	return $str; 
}

sub delete_3_s {
	my $self = shift;
	my $str = $self -> {str}; 
	my $pattern = undef;
	$pattern = '<.+?>'; 
	$str =~ s/$pattern/ /g; 
	$self -> {str} = $str; 
	return $str; 
}

sub delete_4 {
	my $self = shift;
	my $str = $self -> {str}; 
	my $pattern = undef;
	
	$pattern = '\s+'; 
	$str =~ s/$pattern/ /g; 
	$pattern = '^\s+'; 
	$str =~ s/$pattern//g; 
	$pattern = '\s+$'; 
	$str =~ s/$pattern//g; 
	$pattern = '\n+'; 
	$str =~ s/$pattern//g; 	
	$pattern = '\r+'; 
	$str =~ s/$pattern//g; 		
	$self -> {str} = $str; 
	return $str; 
}

sub delete_6 {
	my $self = shift;
	my $str = $self -> {str}; 
	my $pattern = undef;
	
	$pattern = '\+'; 
	$str =~ s/$pattern/-/g; 
	$pattern = '/+'; 
	$str =~ s/$pattern/-/g; 

	$self -> {str} = $str; 
	return $str; 
}

sub delete_7 {
	my $self = shift;
	my $str = $self -> {str}; 
	my $pattern = undef;
	$pattern = '\n+'; 
	$str =~ s/$pattern/ /g; 
	$pattern = '\r+'; 
	$str =~ s/$pattern/ /g; 
	$pattern = '\s+'; 
	$str =~ s/$pattern/ /g; 	
	$self -> {str} = $str; 
	return $str; 
}


sub delete_8 {
	my $self = shift;
	my $str = $self -> {str}; 
	my $pattern = undef;
	$pattern = ''; 
	if ($str eq $pattern) {$str = '-';}
	$self -> {str} = $str; 
	return $str; 
}

sub delete_9 {
	my $self = shift;
	my $str = $self -> {str}; 
	my $pattern = undef;
	$pattern = '^\.+'; 
	$str =~ s/$pattern/ /g; 
	$pattern = '^\:+'; 
	$str =~ s/$pattern/ /g;
	$self -> {str} = $str; 	
	return $str; 
}

1; 
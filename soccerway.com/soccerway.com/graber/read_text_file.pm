package read_text_file;
use strict;
use warnings;

sub new {
	my $self = {};
	$self->{class} = shift;
	$self->{file} = shift;
	$self->{fh} = my $fh;  
	
	if (-f $self->{file}){
		open ($self->{fh}, '<', $self->{file});
		return bless $self;
	} else {
		die (print "Can't open file $self->{file}\n");
	}
}

sub get_str {
	my $self = shift;
	my $fh = $self->{fh};
	my $str = <$fh>;
#	chomp $str if ($str = '');
	return $str;
}

sub DESTROY {
	my $self = shift;
	close ($self->{fh});
}

return 1;

package write_text_file_mode_rewrite;
use strict; use warnings;

sub new {
	my $self = {};
	$self->{class} = shift;
	$self->{file} = shift;
	$self->{fh} = my $fh;  
	
	if (-f $self->{file}){
		open ($self->{fh}, ">" , $self->{file});
		return bless $self;
	} 
	else {
		open ($self->{fh}, ">" , $self->{file});
		return bless $self;
	}
}

sub put_str {
	my $self = shift;
	my $str = shift;
	my $fh = $self->{fh};
	print $fh "$str";
}

sub DESTROY {
	my $self = shift;
	close ($self->{fh});
}

return 1;

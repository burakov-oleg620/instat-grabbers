package dir_scan_no_recurce;
use strict;
use warnings;

sub new {
	my $class = shift;
	my $workdir = shift;
	if ($workdir) {
	my $self = {};
	$self->{workdir} = $workdir;
	$self->{dh} = my $dh;
	opendir ($self->{dh}, $workdir) or die (print "Can't found $workdir");
	return bless $self;
	}
}

sub get_file {
	my $self = shift;
	my $dh = $self->{dh};
	my $workdir = $self->{workdir};
		
	my $file = readdir ($dh); 
	
	if ($file) {
		$file = "$workdir/$file"; 
		$file =~ s/(\/\/)+/\//g;
	}
		while ($file and ($file =~ /\.+$/ or -d $file)) { 
			$file = readdir ($dh); 
	
			if ($file) {
				$file = "$workdir/$file"; 
				$file =~ s/(\/\/)+/\//g;
			}
	}
		
	if ($file and -f $file) {
	return $file;
	}
}

sub DESTROY {
	my $self = shift;
	my $dh = $self->{dh};
	closedir ($dh);
}

return 1;
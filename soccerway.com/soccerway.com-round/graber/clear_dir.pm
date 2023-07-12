package clear_dir; 
use strict; 
use warnings;
use File::Path;


sub new {
	my $class = shift;
	my $workdir = shift;
	my $self = {}; 
	$self->{workdir} = $workdir;
	return bless $self;
}

sub do {
	my $self = shift;
	my $workdir = $self-> {workdir};
	opendir (my $dh, $workdir) or die;
	while (my $file1 = readdir ($dh)) {
		if ($file1 ne '.' and $file1 ne '..') {
			
			$file1 = $workdir.'/'.$file1; 
			$file1 =~ s/\\/\//g;
			$file1 =~ s/\/+/\//g;
			if (-f $file1) {
				unlink $file1; 
			}
			
			if (-d $file1) {
				rmtree ($file1) or die;
			}			
		}
	}
}

1; 


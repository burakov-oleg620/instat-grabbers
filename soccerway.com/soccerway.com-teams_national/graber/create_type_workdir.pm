#Создает и возвращает рабочие каталоги для сохранения контента по признаку type

package create_type_workdir;
use strict;
use warnings;
use File::Path;
use Cwd;

sub new {
	my $class = shift;
	my $type = shift;
	
	my $self = {};
	$self -> {type} = $type;
	return bless $self; 
}

sub do {
	my $self = shift;
	my $type = $self -> {type};

	my $workdir = getcwd (). '/' .$type;
	if (!-d $workdir) {
		mkpath ($workdir);
	}
	return $workdir;
}

1;

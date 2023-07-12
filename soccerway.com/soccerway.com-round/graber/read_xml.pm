#читает настройки из XML файлов

package read_xml;
use strict;
use warnings; 
use work_for_content;
use clear_str;

sub new {
	my $class = shift;
	my $file = shift;
	
	my @file = ();
	open (FILE, $file) or die;
	@file = <FILE>;
	close (FILE);
	
	my $content = join ('', @file);
	$content =~ s/\n+/ /g;
	$content =~ s/\r+/ /g;
	
	my $array = [];
	
	my $pattern = '<option>(.+?)</option>';	
	my $work_for_content = work_for_content -> new ($content);
	my $work_for_content_result = $work_for_content -> get_pattern ($pattern); 
	if (defined $work_for_content_result -> [0]) {
		foreach (@$work_for_content_result) {		
			my $clear_str = clear_str -> new ($_); 
			$_ = $clear_str -> delete_4 ();
			$clear_str = undef;
			
			my $hash = {};
			my $pattern = '<(.+?)>(.+?)</.+?>';
			while ($_=~ /$pattern/g) {
				$hash  -> {$1} = $2;
			}
			push (@$array, $hash);
		}
	}

	my $self = {};
	$self -> {array} = $array;
	return bless $self;
}

sub get {
	my $self = shift;
	my $array = $self -> {array};
	return $array;
}





1;


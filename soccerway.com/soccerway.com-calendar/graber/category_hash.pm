package category_hash; 
use strict; 
use warnings;
use Spreadsheet::ParseExcel;

sub new {
	my $class = shift;
	my $file = shift;
	my $self = {}; 
	$self->{file} = $file;
	return bless $self;
}

sub do {
	my $self = shift;
	my $file = $self-> {file};
	
	my $count = 0;
	my %hash = ();
	
	my $parser   = Spreadsheet::ParseExcel->new ();
	my $workbook = $parser->parse ($file);
	
	for my $worksheet ( $workbook->worksheets() ) {
	 
		my ( $row_min, $row_max ) = $worksheet->row_range();
		my ( $col_min, $col_max ) = $worksheet->col_range();
	 
		for my $row ( 0 .. 10000 ) {
		
			my @array = ();
			for my $col ( 0 .. 4 ) {
				print $count++;				
				
				my $cell = $worksheet->get_cell( $row, $col );
				next unless $cell;
				
				push (@array, $cell->value ());
			}
			if (scalar (@array) == 4) {
				$hash {$count} =  join ("\t", @array);
			}
		}
	}
	
	return %hash;
}

1; 


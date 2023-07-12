package work_for_table; 
use strict;
use warnings;
use clear_str;

sub new {
	my $class = shift;
	my $str = shift;
	my $self = {}; 
	
	my $clear_str = clear_str -> new ($str);
	$str = $clear_str -> delete_4 ();
	$clear_str = undef;			
	
	$self->{content} = $str; 
	return bless $self;
}

sub do {
	my $self = shift;
	my $pattern = shift; 
	my $str = $self -> {content}; 
	
	my $content1 =  $self -> {content};
	$content1 =~ s/\'/"/g;
	$content1 =~ s/\"\"/" "/g;
	$content1 =~ s/>\s+</> </g;
	$content1 =~ s/\s+/ /g;
	
	{
		my $clear_str = clear_str -> new ($content1);
		$content1 = $clear_str -> delete_4 ();
		$clear_str = undef;						
		
		my $pattern1 = '<th';
		my $pattern2 = '<td';
		$content1 =~ s/$pattern1/$pattern2/g;
		
		$pattern1 = '</th>';
		$pattern2 = '</td>';
		$content1 =~ s/$pattern1/$pattern2/g;

	}
	
	my @table = ();
	my $tr_count = 0;
	my $pattern1 = '(<table.+?</table>)';
	my $work_for_content = work_for_content -> new ($content1); 
	my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
	if (defined $work_for_content_result -> [0]) {
		foreach (@$work_for_content_result) {		
			my $clear_str = clear_str -> new ($_);
			$_ = $clear_str -> delete_4 ();
			$clear_str = undef;		
			
			my $pattern1 = '(<tr.+?</tr>)';
			my $work_for_content = work_for_content -> new ($_); 
			my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
			if (defined $work_for_content_result -> [0]) {
				foreach (@$work_for_content_result) {		
					my $clear_str = clear_str -> new ($_);
					$_ = $clear_str -> delete_4 ();
					$clear_str = undef;		

					# print $_ ."\n";
			
					my $td_count = 0;	
					my $td = undef;
					
					my $pattern1 = '(<td.+?</td>)';
					my $work_for_content = work_for_content -> new ($_); 
					my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
					if (defined $work_for_content_result -> [0]) {
						foreach (@$work_for_content_result) {		
							my $clear_str = clear_str -> new ($_);
							$_ = $clear_str -> delete_4 ();
							$clear_str = undef;			
							$td = $_;
					
							my $rowspan = 1;
							my $colspan = 1;
							
							my $pattern1 = 'rowspan.+?"(.+?)"';
							my $work_for_content = work_for_content -> new ($_); 
							my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							if (defined $work_for_content_result -> [0]) {
								foreach (@$work_for_content_result) {		
									my $clear_str = clear_str -> new ($_);
									$_ = $clear_str -> delete_4 ();
									$clear_str = undef;			
									
									my $pattern1 = '(\d+)';
									my $work_for_content = work_for_content -> new ($_); 
									my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									if (defined $work_for_content_result -> [0]) {
										foreach (@$work_for_content_result) {		
											my $clear_str = clear_str -> new ($_);
											$_ = $clear_str -> delete_4 ();
											$clear_str = undef;											
											$rowspan = $_;
										}
									}
								}
							}
							
							# $pattern1 = 'colspan.+?"(.+?)"';
							# $work_for_content = work_for_content -> new ($_); 
							# $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
							# if (defined $work_for_content_result -> [0]) {
								# foreach (@$work_for_content_result) {		
									# my $clear_str = clear_str -> new ($_);
									# $_ = $clear_str -> delete_4 ();
									# $clear_str = undef;			
									
									# my $pattern1 = '(\d+)';
									# my $work_for_content = work_for_content -> new ($_); 
									# my $work_for_content_result = $work_for_content -> get_pattern ($pattern1); 
									# if (defined $work_for_content_result -> [0]) {
										# foreach (@$work_for_content_result) {		
											# my $clear_str = clear_str -> new ($_);
											# $_ = $clear_str -> delete_4 ();
											# $clear_str = undef;											
											# $colspan = $_;
										# }
									# }
								# }
							# }
							
							# print '$rowspan = '. $rowspan ."\n";
							# print '$colspan = '. $colspan ."\n";

							
							#объединение строк элемент всегда создается безошибочно.!
							#потому что он создается вниз. где еще ничего не определено.!

							# print '$tr_count = '. $tr_count ."\n";
							
							my $rowspan_count = $tr_count;
							foreach (1..$rowspan) {
								# if (not defined ($table [$rowspan_count] -> [$td_count])) {
									# $table [$rowspan_count] -> [$td_count]  = $td;
								# }
								while (defined ($table [$rowspan_count] -> [$td_count])) {
									$td_count++; 
								}
								$table [$rowspan_count] -> [$td_count]  = $td;
								$rowspan_count++;
							}


							
							#объединение столбцов
							#если объединены столбцы, То их меньше, и значит какой то элемент может 
							# быть уже определен, чтобы его не перетереть делаем следующее.
							# ищем следующий не определенный элемент.
							
							# if ($colspan > 1) {
								# my $colspan_count = $td_count;
								# foreach (1..$colspan) {
									
									# while  (defined $table [$tr_count] -> [$colspan_count]) {
										# $colspan_count++; 
									# } 
									# if (not defined $table [$tr_count] -> [$colspan_count]) {
										# $table [$tr_count] -> [$colspan_count]  = $td;
									# } 
									# $colspan_count++;
								# }
							# } else {
								# while  (defined $table [$tr_count] -> [$td_count]) {
									# $td_count++; 
								# } 
								# if (not defined $table [$tr_count] -> [$td_count]) {
									# $table [$tr_count] -> [$td_count]  = $td;
								# } 								
							# }
							
							



							# print '$td_count = '. $td_count."\n";
							$td_count++;
						}
					}
					
					# print  '$tr_count = '. $tr_count ."\n";
					$tr_count++;
				}
			}
		}
	}
	
	# foreach (@table) {
		# foreach (@$_) {
			# print $_ ."\n";
		# }
		# print "\n\n";
	# }
	
	return @table;
}


1; 

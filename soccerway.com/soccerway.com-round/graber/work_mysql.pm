package work_mysql;
use strict;
use warnings;
use DBI;


sub new {
	my $class = shift;
	my @array = @_;
	my ($dbdriver, $hostname, $port, $username, $password, $basename) = @array; 
	my $dbh = DBI -> connect ("dbi:$dbdriver:$basename:$hostname:$port", $username, $password) || die print "Невозможно подключиться к серверу MySQL";
	my $self = {};
	$self -> {connect} = $dbh;
	return bless $self; 
}


sub prepare_query {
	my $self = shift;
	my $query = shift;
	my $dbh = $self->{connect};
	my $sth = $dbh -> prepare ($query);
	$self->{sth} = $sth; 
}


sub execute_query {
	my $self = shift;
	my $query = shift;
	my @str = @_;
	my $sth = $self -> {sth}; 
	$sth -> execute (@str) || die "Невозможно выполнить SQL запрос: $DBI::errstr";
}


sub run_query {
	my $self = shift;
	my $query = shift;
	my $dbh = $self -> {connect};
	my $sth = $dbh -> prepare ($query);
	$self -> {sth} = $sth;
	$sth -> execute || die "Невозможно выполнить SQL запрос: $DBI::errstr";
	return $sth;
}

sub get_row {
	my $self = shift;
	my $sth = $self->{sth}; 
	my $row = ();	my @row = ();
	while (@$row = $sth->fetchrow) {
		push (@row, $row); 
		$row = ();
	}
	return @row; 	
}



sub get_row_hashref {
	my $self = shift;
	my $sth = $self->{sth}; 
	my @row = ();
	while (my $row = $sth->fetchrow_hashref) {
		push (@row, $row); 
		$row = ();
	}
	return @row; 	
}

sub get_last_id {
	my $self = shift;
	my $dbh = $self -> {connect};
	return $dbh->{'mysql_insertid'};
}

# sub DESTROY {
	# my $self = shift; 
	# if (defined $self->{connect}) {
		# $self->{connect}->disconnect;
	# }
# }

1;


package dir_scan_recurce;
use strict;
use warnings;
sub new {
    my $class = shift;
    my %args; $args{workdir} = shift;
    
    return "workdir undefined\n" unless (exists $args{workdir});
    my $dh;
    opendir ($dh, $args{workdir}) or die "Can't open $args{workdir}: $!";
    my $self = [ [$dh, $args{workdir}] ];
    return bless $self, $class;
}
sub get_file {
    my $self = shift;
    return unless (@$self);
    my $return_filename;
    DH: while ( my $dh_arr = pop(@$self) ) {
        while (my $filename = readdir($dh_arr->[0])) {
            next if ($filename eq '.' or $filename eq '..');
            my $full_name = $dh_arr->[1].'/'.$filename;
            $full_name =~ s/(\/\/)+/\//g;
			if (-d $full_name) {
                push(@$self, $dh_arr);
                my $dh;
                #opendir ($dh, $full_name) or die "Can't open $full_name: $!";
				last DH unless (opendir ($dh, $full_name));
                $dh_arr = [$dh, $full_name];
            }
            else {
                $return_filename = $full_name;
                push(@$self, $dh_arr);
                last DH;
            }
        }
        closedir($dh_arr->[0]) if (@$self);
    }
    return $return_filename; 
}

sub DESTROY {
    my $self = shift;
    my $dh_arr = pop(@$self);
    if ($dh_arr->[0]) {
        closedir($dh_arr->[0]);
    }
}
1;
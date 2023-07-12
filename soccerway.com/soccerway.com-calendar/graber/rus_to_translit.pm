package rus_to_translit;
use strict;
use warnings;

sub new {
	my $class = shift;
	my $str = shift;
	my $self = {}; 
	$self->{str} = $str; 
	return bless $self;
}

sub do {
	my $self = shift;
	my $str = $self -> {str};
	$str = _k82tr ($str);
	return $str;
}



sub _k82tr  
    { ($_)=@_;  
  
#  
# Fonetic correct translit  
#  
  
s/Ρυ/S\'h/; s/ρυ/s\'h/; s/ΡΥ/S\'H/;  
s/Ψ/Sh/g; s/ψ/sh/g;  
  
s/Ρφυ/Sc\'h/; s/ρφυ/sc\'h/; s/ΡΦΥ/SC\'H/;  
s/Ω/Sch/g; s/ω/sch/g;  
  
s/Φυ/C\'h/; s/φυ/c\'h/; s/ΦΥ/C\'H/;  
s/Χ/Ch/g; s/χ/ch/g;  
  
s/Ιΰ/J\'a/; s/ιΰ/j\'a/; s/Ιΐ/J\'A/;  
s/ί/Ja/g; s/ÿ/ja/g;  
  
s/Ιξ/J\'o/; s/ιξ/j\'o/; s/ΙΞ/J\'O/;  
s/¨/Jo/g; s/Έ/jo/g;  
  
s/Ισ/J\'u/; s/ισ/j\'u/; s/ΙΣ/J\'U/;  
s/ή/Ju/g; s/ώ/ju/g;  
  
s/έ/E\'/g; s/ύ/e\'/g;  
s/Ε/E/g; s/ε/e/g;  
  
s/Ηυ/Z\'h/g; s/ηυ/z\'h/g; s/ΗΥ/Z\'H/g;  
s/Ζ/Zh/g; s/ζ/zh/g;  
  
tr/  
ΰαβγδηθικλμνξοπρςστυφϊϋόΐΑΒΓΔΗΘΙΚΛΜΝΞΟΠΡÒΣΤΥΦΪΫά/  
abvgdzijklmnoprstufhc\"y\'ABVGDZIJKLMNOPRSTUFHC\"Y\'/;  
  
return $_;  
  
}  



1; 




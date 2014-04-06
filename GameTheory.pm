package GameTheory;

use strict;

warn "GameTheory.pm: SUB-VERSION-38";

my %other_player = (his => "her", her => "his");

sub new {
    my $foo = shift;

    my $class = ref($foo) || $foo;

    my $self = {
	payoffs => {},
    };

    return bless $self, $class;
}

sub payoffs {
    my $self = shift;

    if(@_){
	my $payoffs = shift;
	for(my $row_count=0; $row_count<@$payoffs; $row_count++){
	    for(my $col_count=0; $col_count<@{$payoffs->[$row_count]}; $col_count++){
		my ($his, $her) = @{$payoffs->[$row_count][$col_count]};
		$self->{payoffs}{his}[$row_count][$col_count] = $his;
		$self->{payoffs}{her}[$col_count][$row_count] = $her;
	    }
	}
	$self->{choices} = @$payoffs;
    }

    return $self->{payoffs};
}

sub strict_dominance {
    my $self = shift;

    foreach my $player (keys %{$self->{payoffs}}){
	my %best;
	my $other_player = $other_player{$player};
	foreach my $choice (0 .. $self->{choices}-1){
	    my @choices;
	    for(my $i=0; $i<$self->{choices}; $i++){
		push @choices, $self->{payoffs}{$other_player}[$i][$choice];
	    }
#	    warn "\u$player CHOICES @choices";
	    my $best_choice = _high_offset(\@choices);
	    $best{$best_choice}++;
	}
	if(keys %best == 1){
	    warn "\u$player dominant strategy is " . (keys %best)[0];
	}
	else {
	    warn "No dominant strategy for $player";
	}
    }
}

sub _high_offset {
    my $array = shift;

    my ($max, $max_offset);

    for(my $i=0; $i<@$array; $i++){
	if(not defined($max) or ($array->[$i] > $max) ){
	    $max = $array->[$i];
	    $max_offset = $i;
	}
    }
    return $max_offset;
}

1;

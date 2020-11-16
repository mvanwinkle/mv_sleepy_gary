#!/usr/bin/perl

package IAS::SleepyGary2;

use strict;
use warnings;

use Data::Dumper;

use Time::HiRes qw(
	time
	sleep
);

our $SLEEP_TIME = 0;
our $INITIAL_BACKOFF = 1;

our $CREEP_UP = 0.02;
our $CREEP_AWAY = 1.05;

our $MIN_SLEEP_TIME = 0;

sub new
{
	my $type = shift;
	my ($options) = @_;

	my $self = {};

	$self->{sleep_time} = $options->{sleep_time}
		// $SLEEP_TIME;
	$self->{initial_backoff} = $options->{initial_backoff}
		// $INITIAL_BACKOFF;

	$self->{creep_up} = $options->{creep_up}
		// $CREEP_UP;

	$self->{creep_away} = $options->{creep_away}
		// $CREEP_AWAY;

	$self->{min_sleep_time} = $options->{min_sleep_time}
		// $MIN_SLEEP_TIME;

	$self->{mode} = 'success';
	$self->{attempt_backoff} = 0;
	$self->{successive_successes} = 0;
	$self->{successive_failures} = 0;

	# print Dumper($self);
	# <STDIN>;
	return bless $self, $type;
}

sub wait
{
	my ($self) = @_;
	
	sleep($self->{sleep_time});
}

sub success
{
	my ($self) = @_;

	my $t = time();

	$self->{first_success} //= $t;
	$self->{last_success} = $t;

	if ($self->{mode} eq 'success')
	{
		$self->journal("Another success.\n");
		$self->{successive_successes}++;
	}


	if ($self->{mode} eq 'failure'
		&& ! $self->{made_initial_guess}
	)
	{
		$self->journal("First success after failure.\n");
		my $test_sleep = ( $self->{last_failure} - $self->{first_success} )
			/ ( $self->{successive_successes} ) ;

		$self->journal("Setting sleep time to $test_sleep\n");
		$self->{sleep_time} = $test_sleep;

		$self->{successive_successes} = 1;
		$self->{made_initial_guess} = 1;
		undef $self->{first_success};
	}
	$self->{creep_time} = $self->{sleep_time} * $self->{creep_up};
	$self->{sleep_time} = $self->{sleep_time} - $self->{creep_time};

	$self->{sleep_time} = $self->{min_sleep_time}
		if ($self->{sleep_time} < $self->{min_sleep_time});

	$self->journal("Current sleep time: ", $self->{sleep_time},$/);	
	# lastly, set our mode to success
	$self->{mode} = 'success';
}

sub naive_backoff
{
	my ($self) = @_;

	if (! $self->{sleep_time} )
	{
		$self->journal("Setting sleep for the first time.\n");
		$self->{sleep_time} = $self->{last_failure} - $self->{first_failure};
	}
	else
	{
		$self->journal("Creeping away.\n");
		$self->{sleep_time} = $self->{sleep_time} * $self->{creep_away};
	}

	$self->journal( "backing off.  Sleep time: ", $self->{sleep_time},$/);
}

sub journal
{
	my ($self) = shift;
	my $lt = scalar localtime;
	print $lt, " " , @_;
}
sub failure
{
	my ($self) = @_;

	my $t = time();
	$self->{first_failure} //= $t;
	$self->{last_failure} = $t;

	$self->naive_backoff();

	# lastly, set our mode to failure
	$self->{mode} = 'failure';
}
1;

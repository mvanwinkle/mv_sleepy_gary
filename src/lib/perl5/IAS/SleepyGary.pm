#!/usr/bin/perl

package IAS::SleepyGary;

use strict;
use warnings;

use Data::Dumper;

use Time::HiRes qw(
	time
	sleep
);

our $SLEEP_TIME = 0;
our $INITIAL_BACKOFF = 0;

sub new
{
	my $type = shift;
	my ($options) = @_;

	my $self = {};

	$self->{sleep_time} = $options->{sleep_time}
		// $SLEEP_TIME;
	$self->{initial_backoff} = $options->{initial_backoff}
		// $INITIAL_BACKOFF;

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
		$self->{successive_successes}++;
	}


	# lastly, set our mode to success
	if ($self->{mode} eq 'failure')
	{
		my $test_sleep = ( $self->{last_failure} - $self->{first_success} )
			/ ( $self->{successive_successes} - $self->{attempt_backoff}) ;

		$self->journal("Setting sleep time to $test_sleep\n");
		$self->{sleep_time} = $test_sleep;

		$self->{successive_successes} = 1;
		undef $self->{first_success};
	}
	
	$self->{mode} = 'success';
}

sub naive_backoff
{
	my ($self) = @_;

	if (! $self->{sleep_time} )
	{
		$self->{sleep_time} = $self->{last_failure} - $self->{first_failure};
		return;
	}

	$self->{sleep_time} = $self->{sleep_time} * 2;

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

	if ($self->{first_failure} != $self->{last_failure} )
	{
		$self->{attempt_backoff}++;
		$self->naive_backoff();
	}
	else
	{
		sleep $self->{initial_backoff};
	}

	# lastly, set our mode to failure
	$self->{mode} = 'failure';
}
1;

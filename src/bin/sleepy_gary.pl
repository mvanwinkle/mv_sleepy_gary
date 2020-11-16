#!/usr/bin/perl

use strict;
use warnings;

use lib '/opt/IAS/lib/perl5';

use FindBin qw($RealBin);
use lib "$RealBin/../lib/perl5";

use IAS::SleepyGary2;

# We can also do OO easily:

my $gary = IAS::SleepyGary2->new();

my $line;
while (defined ($line = <STDIN>))
{
	chomp($line);
	$gary->wait();
	print scalar localtime,$/;
	if ($line)
	{
		$gary->success();
	}
	else
	{
		$gary->failure();
	}
}

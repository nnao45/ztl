#!/usr/bin/perl

=head1 NAME
ts - timestamp input
=head1 SYNOPSIS
ts [-r] [format]
=head1 DESCRIPTION
ts adds a timestamp to the beginning of each line of input.
The optional format parameter controls how the timestamp is formatted,
as used by L<strftime(3)>. The default format is "%b %d %H:%M:%S". In
addition to the regular strftime conversion specifications, "%.S" and "%.s"
are like "%S" and "%s", but provide subsecond resolution
(ie, "30.00001" and "1301682593.00001").
If the -r switch is passed, it instead converts existing timestamps in
the input to relative times, such as "15m5s ago". Many common timestamp
formats are supported. Note that the Time::Duration and Date::Parse perl
modules are required for this mode to work. Currently, converting localized
dates is not supported.
If both -r and a format is passed, the existing timestamps are
converted to the specified format.
=head1 ENVIRONMENT
The standard TZ environment variable controls what time zone dates
are assumed to be in, if a timezone is not specified as part of the date.
=head1 AUTHOR
Copyright 2006 by Joey Hess <joey@kitenet.net>
Licensed under the GNU GPL.
=cut

use warnings;
use strict;
use POSIX q{strftime};

$|=1;

my $rel=0;
use Getopt::Long;
GetOptions("r" => \$rel) || die "usage: ts [-r] [format]\n";

if ($rel) {
	eval q{
		use Date::Parse;
		use Time::Duration;
	};
	die $@ if $@;
}

my $use_format=@ARGV;
my $format="%b %d %H:%M:%S";
$format=shift if @ARGV;

# For subsecond resolution, Time::HiRes is needed.
my $hires=0;
if ($format=~/\%\.[Ss]/) {
	require Time::HiRes;
	$hires=1;
}

while (<>) {
	if (! $rel) {
		if ($hires) {
			my $f=$format;
			my ($seconds, $microseconds) = Time::HiRes::gettimeofday();
			my $s=sprintf("%06i", $microseconds);
			$f=~s/\%\.([Ss])/%$1.$s/g;
			print strftime($f, localtime($seconds));
		}
		else {
			print strftime($format, localtime);
		}
		print " ".$_;
	}
	else {
		s{\b(
			\d\d[-\s\/]\w\w\w	# 21 dec 17:05
				(?:\/\d\d+)?	# 21 dec/93 17:05
				[\s:]\d\d:\d\d	#       (time part of above)
				(?::\d\d)?	#       (optional seconds)
				(?:\s+[+-]\d\d\d\d)? #  (optional timezone)
			|
			\w{3}\s+\d\d\s+\d\d:\d\d:\d\d # syslog form
			|
			\d\d\d[-:]\d\d[-:]\d\dT\d\d:\d\d:\d\d.\d+ # ISO-8601
			|
			(?:\w\w\w,?\s+)?	#       (optional Day)
			\d+\s+\w\w\w\s+\d\d+\s+\d\d:\d\d:\d\d
						# 16 Jun 94 07:29:35
				(?:\s+\w\w\w|\s[+-]\d\d\d\d)?
						#	(optional timezone)
			|
			\w\w\w\s+\w\w\w\s+\d\d\s+\d\d:\d\d
						# lastlog format
		  )\b
		}{
			$use_format
				? strftime($format, localtime(str2time($1)))
				: concise(ago(time - str2time($1), 2))
		}exg;

		print $_;
	}
}

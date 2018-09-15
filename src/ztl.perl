#!/usr/bin/perl

use Time::HiRes qw(time);
use POSIX qw(strftime);

s/\s+$//;
my $t = time;
my $date = strftime "%Y%m%d %H:%M:%S", localtime $t;
$date .= sprintf ".%03d", ($t-int($t))*1000;

print "[$date] " .$_

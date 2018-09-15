# Copyright 2018 by nnao45 <n4sekai5y@gmail.com> Licensed under the GNU GPL.

ZTL_WORKDIR=`dirname $0`

${ZTL_WORKDIR}/ts.perl '[%Y-%m-%d %H:%M:%.S]'
#${ZTL_WORKDIR}/ztl.perl 
#perl -M'POSIX' -nle 'use Time::HiRes qw(time); use POSIX qw(strftime); s/\s+$//; my $t = time; my $date = strftime "%Y%m%d %H:%M:%S", localtime $t; $date .= sprintf ".%03d", ($t-int($t))*1000; print "[$date] " .$_'

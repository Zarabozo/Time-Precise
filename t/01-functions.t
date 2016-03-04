use strict;
use warnings;
use Test::More tests => 22;

BEGIN {
	use_ok 'Time::Precise';
}

my $time = time;
my $ok = length($time) > length(int $time);
is $ok, 1, 'time has nanoseconds';

$time = '178983192.0067514';
my $gmtime = 'Wed Sep  3 13:33:12.0067514 1975';
is $gmtime, scalar gmtime $time, 'gmtime works with nanoseconds';

my $current_time = time;
sleep .5;
$current_time = time - $current_time;
$current_time = sprintf '%0.1f', $current_time;
$ok = ($current_time > 0.4 and $current_time < 0.6) ? 1 : 0;
is $ok, 1, 'sleep works with nanoseconds';

my @gmtime = gmtime $time;
is timegm(@gmtime), $time, 'timelocal works with nanoseconds';

is is_valid_date(2000, 2, 29), 1, 'is_valid_year leap year';
is is_valid_date(2001, 2, 29), 0, 'is_valid_year non leap year';
is is_valid_date(2002, 1, 31), 1, 'is_valid_year long month A';
is is_valid_date(2002, 1, 32), 0, 'is_valid_year long month B';
is is_valid_date(2003, 4, 30), 1, 'is_valid_year short month A';
is is_valid_date(2003, 4, 31), 0, 'is_valid_year short month B';

my $h = time_hashref($time);
is 'HASH', ref($h), 'time_hashref returns hashref';
is $h->{year}, 1975, 'time_hashref year';
is $h->{month}, '09', 'time_hashref month';
is $h->{day}, '03', 'time_hashref day';
is $h->{hour}, '08', 'time_hashref hour';
is $h->{minute}, '33', 'time_hashref minute';
is $h->{second}, '12.0067514', 'time_hashref second';

my $time_from = get_time_from (
	year 	=> 1975,
	month	=> 9,
	day		=> 3,
	hour	=> 8,
	minute	=> 33,
	second	=> 12.0067514,
);
is $time_from, $time, 'get_time_from';

my $future_time = scalar gmtime '1444222866.7336199';
my $past_time = scalar gmtime '0.7336199';
my $ac_time = scalar gmtime '-1444222866.7336199';
is $future_time, 'Wed Oct  7 13:01:06.7336199 2015', 'gmtime can go past year 2038';
is $past_time, 'Thu Jan  1 00:00:00.7336199 1970', 'gmtime past time as expected';
is $ac_time, 'Thu Mar 27 10:58:53.7336199 1924', 'gmtime can go way back (negative seconds)';

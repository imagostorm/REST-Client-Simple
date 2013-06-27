use strict;
# use warnings;

use Test::More;
use_ok('REST::Client::Simple');
use_ok('Time::HiRes');
use Time::HiRes qw/gettimeofday tv_interval/;
use REST::Client::Simple;
my ($now, $elapsed);
my $client = REST::Client::Simple->new(host => 'google.com');

$now = [gettimeofday];
my $result = $client->get( path => '');
$elapsed = tv_interval($now);
ok($result);
diag("First request : $elapsed\n");

my ($sum, $number) = (0, 10);
diag("please wait, average request time is counting...\n");
foreach(0..$number) {
	$now = [gettimeofday];
	$client->get;
	$elapsed = tv_interval($now);
	$sum += $elapsed;
	sleep(1);
}

my $avg_time = $sum/$number;
diag("Average elapsed time : $avg_time\n");
	



done_testing();


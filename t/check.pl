# !/bin/perl
use Data::Dumper;
use REST::Client::Simple;
my ($now, $elapsed);
use LWP::Debug '+';
my $client = REST::Client::Simple->new(host => 'google.com');
$client->get();
print Dumper $client;
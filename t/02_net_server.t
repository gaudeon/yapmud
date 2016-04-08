use v6;
use Test;
use lib 'lib';

use Net::Server;

my $server = Net::Server.new;

isa-ok $server, Net::Server;

done-testing();

use v6;
use Test;
use lib 'lib';

use Net::Server::Telnet;

my $net_server_telnet = Net::Server::Telnet.new;

does-ok $net_server_telnet, Net::Server, 'Net::Server::Telnet has role Net::Server';

done-testing();

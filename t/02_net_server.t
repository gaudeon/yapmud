use v6;
use Test;
use lib 'lib';

use Net::Server;
use Net::Server::Command;

sub MAIN () {
    init-testing();

    comms-testing();

    done-testing();
}

# -- END OF TESTS

# -- Test subs
sub init-testing () {
    my Net::Server $server .= new;

    isa-ok $server, Net::Server;

    does-ok $server, Net::Server::Command;

    cmp-ok $server.host, 'eq', 'localhost', 'Host default is set correctly';

    cmp-ok $server.port, '==', 23, 'Port default is set correctly';

    $server .= new( host => '127.0.0.1', port => 2323 );

    cmp-ok $server.host, 'eq', '127.0.0.1', 'Host changed successfully';

    cmp-ok $server.port, '==', 2323, 'Port changed successfully';

    isa-ok $server.events, 'Supply', 'On connect event isa Supply';
}

sub comms-testing () {
    my Net::Server $server .= new;

    $server.events.tap(-> $event {
        cmp-ok($event.type, '~~', /[connect|message|disconnect]/, "{$event.type} event is a valid type of event");
    });

    my $server_prom = $server.listen();

    cmp-ok $server.generate_client_token(), '~~', /<[0..9 a..f]> ** 32..32/, 'Server generates proper client token';

    my $client_prom = IO::Socket::Async.connect('localhost', 23);

    $client_prom.then(-> $p {
        if $p.status {
            my $conn = $p.result;

            $conn.print("!shutdown");
        }

    });

    await $server_prom;
}

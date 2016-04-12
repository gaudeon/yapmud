use v6;
use Test;
use lib 'lib';

use Net::Server;

sub MAIN () {
    init-testing();
    
    comms-testing();
    
    done-testing();
}

# -- END OF TESTS

# -- Test subs
sub init-testing() {
    my Net::Server $server .= new;
    
    isa-ok $server, Net::Server;

    cmp-ok $server.host, 'eq', 'localhost', 'Host default is set correctly';
    
    cmp-ok $server.port, '==', 23, 'Port default is set correctly';
    
    $server .= new( host => '127.0.0.1', port => 2323 );
    
    cmp-ok $server.host, 'eq', '127.0.0.1', 'Host changed successfully';
    
    cmp-ok $server.port, '==', 2323, 'Port changed successfully';
    
    isa-ok $server.events, 'Supply', 'On connect event isa Supply';
}

sub comms-testing() {
    my $thread = server();
    
    my $client = client();
    
    $thread.finish;
    
    # TODO: build a quit mechanism for the server to make the thread end (otherwise blocks the test from completing)
}

# -- Misc subs

sub client () {
    return IO::Socket::INET.new(:host<localhost>, :port(23));
}

sub server () {
    return Thread.start(
        :app_lifetime,
        sub {
            my Net::Server $server .= new(:port(23));
            
            $server.events.tap(-> $event {
                cmp-ok($event.type, '~~', /[connect|disconnect]/, 'event type is valid');
                diag $event.gist;
            });
            
            $server.run();
        },
    );
}

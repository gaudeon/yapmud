use v6;
use Test;
use lib 'lib';

use Net::Server;

init-testing();

comms-testing();

done-testing();

# -- END OF TESTS

# -- Test subs
sub init-testing() {
    my Net::Server $server .= new;
    
    isa-ok $server, Net::Server;

    cmp-ok $server.host, 'eq', 'localhost', 'Host default is set correctly';
    
    cmp-ok $server.port, '==', 25, 'Port default is set correctly';
    
    $server .= new( host => '127.0.0.1', port => 2345 );
    
    cmp-ok $server.host, 'eq', '127.0.0.1', 'Host changed successfully';
    
    cmp-ok $server.port, 'eq', '2345', 'Port changed successfully';
    
    isa-ok $server.events, 'Supply', 'On connect event isa Supply';
}

sub comms-testing() {
   
    # Run the server asynchronously
    Promise.start({
         my Net::Server $server .= new(:port(25));
    
        $server.events.tap({
            my $event = .result;
            
            diag $event.dist;
        });
        
        $server.run();
    }).then({
        my $client = client();
    });
}

# -- Misc subs

sub client () {
    return IO::Socket::INET.new(:host<localhost>, :port(25));
}

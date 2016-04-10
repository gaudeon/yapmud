#!perl6

use v6;

class Net::Server::Event {
    has Str $.type;
    has $.data;
}

class Net::Server {
    has Str:D $.host = 'localhost';
    has Int:D $.port = 23;
   
    # Events 
    has Supplier $!event_supplier .= new;
    has Supply:D $.events = $!event_supplier.Supply;
    
    has IO::Socket::INET $!socket;
    
    method run () {
        $!socket = IO::Socket::INET.new(
            localhost => $!host,
            localport => $!port,
            :listen
        );
       
        loop {
            my $client = $!socket.accept;
            
            $!event_supplier.emit( Net::Server::Event.new(:type<connect>, :data($client)) );
            
            
            $!event_supplier.emit( Net::Server::Event.new(:type<disconnect>, :data($client)) );
                                  
            $client.close;
        }
    }
}

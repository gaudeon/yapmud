#!perl6

use v6;

class Net::Server::Event {
    has Str $.type;
    has $.data;
}

class X::Net::Server is Exception {
}

class X::Net::Server::FailedListen is X::Net::Server {
    has $.host;
    has $.port;

    method message {
        "Failed to listen on $!host:$!port";
    }
}

class Net::Server {
    has Str:D $.host = 'localhost';
    has Int:D $.port = 23;

    # Events
    has Supplier $!event_supplier .= new;
    has Supply:D $.events = $!event_supplier.Supply;

    has Supply $.socket is rw;

    method listen (Bool $block? = False) {
        my Promise $prom .= new;

        $.socket = IO::Socket::Async.listen($!host, $!port) or die X::Net::Server::FailedListen.new( :host($!host), :port($!port) );

        $.socket.tap(-> $conn {
            $!event_supplier.emit( Net::Server::Event.new(:type<connect>, :data($conn)) );

            react {
                whenever $conn.Supply -> $msg {
                    #if $msg.chars > 0 {
                        $!event_supplier.emit( Net::Server::Event.new(:type<message>, :data({ conn => $conn, message => $msg })) );
                    #}
                }
            }

            #$!event_supplier.emit( Net::Server::Event.new(:type<disconnect>, :data($conn)) );

            #$conn.close;
        }, quit => {
            $prom.keep(True);
        });

        await $prom if $block;
        return $prom;
    }
}

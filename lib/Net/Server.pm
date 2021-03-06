#!perl6

use v6;

use Net::Server::Command;

class Net::Server::Client {
    has IO::Socket::Async $.socket;
    has Str $.token;
}

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

class X::Net::Server::FailedTokenGeneration is X::Net::Server {
    method message {
        "Failed to generate a validation client token";
    }
}

class Net::Server does Net::Server::Command {
    has Str:D $.host = 'localhost';
    has Int:D $.port = 23;

    # Events
    has Supplier $!event_supplier .= new;
    has Supply:D $.events = $!event_supplier.Supply;

    has Supply $.socket is rw;
    has Promise $.running .= new;

    has Net::Server::Client %!clients;

    method !init () {
        return if $.socket;

        $.socket = IO::Socket::Async.listen($!host, $!port) or die X::Net::Server::FailedListen.new( :host($!host), :port($!port) );

        self.register_cmd('!echo', -> @args, $client {
            self.write( $client, @args.join(' ') );
        });

        self.register_cmd('!shutdown', -> @args, $client {
            for %!clients.kv -> $token, $client {
                $!event_supplier.emit( Net::Server::Event.new(:type<disconnect>, :data( $client )) );

                $client.socket.close;
            }

            $!running.keep(True);
        });
    }

    method listen (Bool $block? = False) {
        self!init();

        $.socket.tap(-> $conn {
            my $client = self!add-client($conn);

            $!event_supplier.emit( Net::Server::Event.new(:type<connect>, :data( $client ) ) );

            $client.socket.Supply.tap(-> $msg {
                $!event_supplier.emit( Net::Server::Event.new(:type<message>, :data({ client => $client, message => $msg })) );

                for $msg.split("\n") -> $line {
                    self.run_cmd($line, $client);
                }
            });
        }, quit => {
            $!running.keep(True);
        });

        await $!running if $block;
        return $!running;
    }

    method !add-client (IO::Socket::Async $conn) {
        my Net::Server::Client $client .= new( :socket($conn), :token(self.generate_client_token) );

        %!clients{ $client.token } = $client;

        return $client;
    }

    method clients () {
        return %!clients.values;
    }

    method client (Str $token) {
        return %!clients{ $token };
    }

    method write (Net::Server::Client $client, Str $message) {
        await $client.socket.print( $message );
    }

    method generate_client_token () {
        my @terms = (0..9,'a'..'f').flat;
        my Str $token;

        for 1 .. 100 {
            $token = (map { @terms[ @terms.elems.rand.truncate ] }, 0..31).join;

            last if !%!clients{$token};
        }

        die X::Net::Server::FailedTokenGeneration.new if ! $token;

        return $token;
    }
}

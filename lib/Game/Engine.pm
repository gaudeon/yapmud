#!perl6

use v6;

use Net::Server;

class Game::Engine {
    has Net::Server $!server;

    method !init () {
        $!server = Net::Server.new();
    }

    method run (Bool $block? = False) {
        self!init();

        return $!server.listen($block); # start the server
    }
}

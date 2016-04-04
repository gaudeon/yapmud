use v6;
use Test;
use lib 'lib';

use-ok 'Net::Server', 'Can use Net::Server ok';
use-ok 'Net::Server::Telnet', 'Can use Net::Server::Telnet ok';
use-ok 'Game', 'Can use Game ok';
use-ok 'Game::Engine', 'Can use Game::Engine ok';
use-ok 'Game::Engine::MUD', 'Can use Game::Engine::MUD ok';

done-testing();

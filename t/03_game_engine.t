use v6;
use Test;
use lib 'lib';

use Game::Engine::MUD;

my $game_engine_mud = Game::Engine::MUD.new;

does-ok $game_engine_mud, Game::Engine, 'Game::Engine::MUD has role Game::Engine';

done-testing();

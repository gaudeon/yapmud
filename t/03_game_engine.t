use v6;
use Test;
use lib 'lib';

use Game::Engine;

my $engine = Game::Engine.new;

isa-ok $engine, Game::Engine;

done-testing();

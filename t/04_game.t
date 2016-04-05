use v6;
use Test;
use lib 'lib';

use Game;

my $game = Game.new;

ok $game.start, "Game starts";

done-testing();

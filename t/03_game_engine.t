use v6;
use Test;
use lib 'lib';

use Game::Engine;

sub MAIN () {
    init-testing();

    engine-testing();

    done-testing();
}

sub init-testing() {
    my Game::Engine $engine .= new;

    isa-ok $engine, Game::Engine;
}

sub engine-testing() {
    my Game::Engine $engine .= new;

    $engine.run();
}

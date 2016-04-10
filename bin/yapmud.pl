#!/usr/bin/env perl6

use v6;

BEGIN {
    use lib $*SPEC.catdir(IO::Path.new($*PROGRAM.IO.absolute).dirname, $*SPEC.updir, 'lib');
}

use Game;

my Game $game .= new;

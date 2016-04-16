#!perl6

use v6;

use Test;

role Net::Server::Command {
    my %commands;

    method register_cmd (Str $cmd, Block $cb) {
        %commands{$cmd} = $cb;
    }

    method run_cmd (Str $msg) {
        my @words = $msg.split('\b');

        my $command = @words.shift;

        %commands{$command}.(@words) if %commands{$command};
    }
}

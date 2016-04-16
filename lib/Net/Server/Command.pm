#!perl6

use v6;

role Net::Server::Command {
    my %commands;

    method register_cmd (Str $cmd, Block $cb) {
        %commands{$cmd} = $cb;
    }

    method run_cmd (Str $msg, Any $data) {
        my @words = $msg.split(' ');

        my $command = @words.shift;

        %commands{$command}.(@words, $data) if %commands{$command};
    }
}

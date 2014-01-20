use strict;
use warnings;
use Test::More;

use Test::Mock::Cmd 'qr' => {
    'git ls-remote --get-url' => sub { return 'git@github.com:abc/xzy.git' },
    'git symbolic-ref --short HEAD' => sub { return 'master'; }
};

use Git::Open;

subtest _remote_url => sub {
    my $url =  Git::Open::_remote_url();
    is( $url, 'http://github.com/abc/xzy', 'Get remote url' );
};

subtest  _current_branch => sub {
    my $branch =  Git::Open::_current_branch();
    is( $branch, 'master', 'Get current branch' );
};

subtest url_compare_opts => sub {
    my $opts = {
        compare => {}
    };

    my $url = Git::Open::url($opts);
    is( $url, 'http://github.com/abc/xzy/compare', 'Correct compare url' );

};

subtest url_compare_opts_with_diff => sub {

    my $opts = {
        compare => { diff => 'master-develop'}
    };

    my $url = Git::Open::url($opts);
    is( $url, 'http://github.com/abc/xzy/compare/master...develop', 'Correct compare url with diff' );

};

done_testing();

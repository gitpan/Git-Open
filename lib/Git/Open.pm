use strict;
use warnings;
package Git::Open;

# ABSTRACT: a totally cool way to open repository page, sometime it's hard to remember.


sub _remote_url {
    my $git_url = `git ls-remote --get-url`;

    $git_url =~ s/\n//;
    $git_url =~ s/:/\//; # Change : to /
    $git_url =~ s/^git@/http:\/\//; # Change protocal to http
    $git_url =~ s/\.git$//; # Remove .git at the end
    return $git_url;
}

sub _current_branch {
    my $current_branch = `git symbolic-ref --short HEAD`;
    return $current_branch;
}

sub url {
    my ( $opts ) = @_;

    my $url = Git::Open::_remote_url();

    if( exists $opts->{compare} ) {
        $url = "$url/compare";

        my $diff = $opts->{compare}->{diff};

        if ( $diff ) {
            $diff =~ s/-/\.\.\./g; # Replace dash(-) to triple dot(...) as github uses
            $url = "$url/$diff";
        }
    }

    return $url;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Git::Open - a totally cool way to open repository page, sometime it's hard to remember.

=head1 VERSION

version 0.001

=head1 USAGE
    git open # it will open homepage of your repository
    git open --compare # it will open compare page
    git open --compare master-develop # Open compare page with branch diff

    Tip: -c is a shorthand for --compare

=head1 AUTHOR

Pattarawat Chormai <pat.chormai@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Pattarawat Chormai.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

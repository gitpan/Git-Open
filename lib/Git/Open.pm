use strict;
use warnings;
package Git::Open;
use Moose;
use Git::Open::Util;

use Moose::Util::TypeConstraints;

with 'MooseX::Getopt::Usage';

subtype 'MaybeStr'
    => as 'Str'
    => where { defined $_ };

MooseX::Getopt::OptionTypeMap->add_option_type_to_map(
    'MaybeStr' => ':s'
);

has compare => (
    is => 'ro',
    isa => 'MaybeStr',
    default => '',
    documentation => 'To open compare view, ex: --compare master-develop'
);

has 'branch' => (
    is => 'ro',
    isa => 'MaybeStr',
    documentation => 'To open branch view: --branch develop'
);

has generator => (
    is => 'ro',
    metaclass => 'NoGetopt',
    isa => 'Git::Open::Util',
    default => sub {
        return Git::Open::Util->new();
    },
    handles => {
        url => 'generate_url'
    }
);

# ABSTRACT: The totally cool way to open repository page, sometime it's hard to remember and open via browser manually.


sub run {
    my $self = shift;

    my $url = $self->url( $self->args );
    system("git web--browse $url");
}

# TODO: Find the way to args get it from Moose
sub args {
    my $self = shift;
    return {
        compare => $self->compare(),
        branch => $self->branch()
    };
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Git::Open - The totally cool way to open repository page, sometime it's hard to remember and open via browser manually.

=head1 VERSION

version 0.1.2

=head1 USAGE

    git open # it will open homepage of your repository

    git open --compare # it will open compare page

    git open --compare master-develop # Open compare page betwee master and develop

    git open --branch master # Open master branch's page

    git open --branch # Open current branch's page

=head1 AUTHOR

Pattarawat Chormai <pat.chormai@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Pattarawat Chormai.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

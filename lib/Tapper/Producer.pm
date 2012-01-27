package Tapper::Producer;

use warnings;
use strict;

use Moose;

=head1 NAME

Tapper::Producer - Tapper - Precondition producers (base class)

=cut

our $VERSION = '3.000001';


=head1 SYNOPSIS



=head1 Functions

=head2 produce

Get the requested producer, call it and return the new precondition(s)
returned by it.

@param testrunscheduling result object - testrun this precondition belongs to
@param hash ref                        - producer precondition

@return success - hash ref containing list of new preconditions and a
                  new topic (optional)

@throws die()

=cut

sub produce
{
        my ($self, $job, $precond_hash) = @_;

        my $producer_name = $precond_hash->{producer};

        eval "use Tapper::Producer::$producer_name"; ## no critic (ProhibitStringyEval)
        die "Can not load producer '$producer_name': $@" if $@;

        my $producer = "Tapper::Producer::$producer_name"->new();
        return $producer->produce($job, $precond_hash);
}

=head1 AUTHOR

AMD OSRC Tapper Team, C<< <tapper at amd64.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-tapper-base at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tapper-Base>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2011 AMD OSRC Tapper Team, all rights reserved.

This program is released under the following license: freebsd

=cut

1; # End of Tapper::Producer

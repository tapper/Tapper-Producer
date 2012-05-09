package Tapper::Producer;
# ABSTRACT: Tapper - Precondition producers (base class)

use warnings;
use strict;

use Moose;

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

1; # End of Tapper::Producer

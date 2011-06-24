package Tapper::Producer;

use warnings;
use strict;

use Moose;

=head1 NAME

Tapper::Producer - Base module for Tappers precondition producer modules!

=head1 VERSION

Version 0.01

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
@return error   - error string

=cut

sub produce
{
        my ($self, $job, $precond_hash) = @_;

        my $producer_name = $precond_hash->{producer};

        eval "use Tapper::Producer::$producer_name"; ## no critic (ProhibitStringyEval)
        return "Can not load producer '$producer_name': $@" if $@;

        my $producer = "Tapper::Producer::$producer_name"->new();
        return $producer->produce($job, $precond_hash);
}

=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-tapper-producer at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tapper-Producer>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Tapper::Producer


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Tapper-Producer>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Tapper-Producer>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Tapper-Producer>

=item * Search CPAN

L<http://search.cpan.org/dist/Tapper-Producer/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 OSRC SysInt Team.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Tapper::Producer

## no critic (RequireUseStrict)
package Tapper::Producer::DummyProducer;

        use Moose;

        sub produce {
                my ($self, $job, $precondition) = @_;

                die "Need a TestrunScheduling object in producer"
                 unless ref($job) eq 'Tapper::Schema::TestrunDB::Result::TestrunScheduling';
                my $type = $precondition->{options}{type} || 'no_option';
                return {
                        precondition_yaml => "---\nprecondition_type: $type\n---\nprecondition_type: second\n",
                        topic => 'new_topic',
                       };
        }

1;

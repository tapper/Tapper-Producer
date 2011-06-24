use MooseX::Declare;

## no critic (RequireUseStrict)
class Tapper::Producer::DummyProducer
{
        method produce(Any $job, HashRef $precondition)
        {
                my $type = $precondition->{options}{type} || 'no_option';
                return {
                        precondition_yaml => "---\nprecondition_type: $type\n---\nprecondition_type: second\n",
                        topic => 'new_topic',
                       };

        }
}

{
        # help the CPAN indexer
        package Tapper::Producer::DummyProducer;
}

1;

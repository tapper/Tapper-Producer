use MooseX::Declare;

## no critic (RequireUseStrict)
class Tapper::Producer::Temare 
{        
        use File::Temp 'tempfile';
        use YAML       'LoadFile';
        use Tapper::Config;

=head2 produce

Choose a new testrun from the test matrix, generate the required
external config files (e.g. svm file for xen, .sh files for KVM, ..).

@param Job object - the job we build a package for
@param hash ref   - producer precondition

@return success - hash ref containing list of new preconditions

@throws die()

=cut

        method produce(Any $job, HashRef $produce)
        {
                my ($fh, $file) = tempfile( UNLINK => 1 );

                use Data::Dumper;
                my $temare_path=Tapper::Config->subconfig->{paths}{temare_path};
                
                $ENV{PYTHONPATH}="$temare_path/src";
                my $subject = $produce->{subject};
                my $bitness = $produce->{bitness};
                my $host =  $job->host->name;
                $ENV{TAPPER_TEMARE} = $file;
                my $cmd="$temare_path/temare subjectprep $host $subject $bitness";
                my $yaml = qx($cmd);
                die $yaml if $?;
                
                my $config = LoadFile($file);
                close $fh;
                unlink $file if -e $file;
                my $topic = $config->{subject} || 'Misc';
                return {
                        topic => $topic,
                        precondition_yaml => $yaml
                       };
        }

}

{
        # help the CPAN indexer
        package Tapper::MCP::Scheduler::PreconditionProducer::Temare;
}

1;

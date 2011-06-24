use MooseX::Declare;

## no critic (RequireUseStrict)
class Tapper::Producer::Temare 
{        
        use File::Temp 'tempfile';
        use YAML       'LoadFile';
        use Tapper::Config;

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
                return {error => $yaml} if $?;
                
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

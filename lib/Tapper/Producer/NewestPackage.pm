## no critic (RequireUseStrict)
package Tapper::Producer::NewestPackage;
# ABSTRACT: produce preconditions via find latest changed file

        use Moose;
        use YAML;

        use 5.010;

        use Tapper::Config;
        use File::stat;

        sub younger { stat($a)->mtime() <=> stat($b)->mtime() }

        sub produce {
                my ($self, $job, $produce) = @_;

                my $source_dir    = $produce->{source_dir};
                my @files = sort younger <$source_dir/*>;
                return {
                        error => 'No files found in $source_dir',
                       } if not @files;
                my $use_file = pop @files;

                my $nfs = Tapper::Config->subconfig->{paths}{prc_nfs_mountdir};
                die "$use_file not available to Installer" unless $use_file=~/^$nfs/;

                my $retval = [{
                               precondition_type => 'package',
                               filename => $use_file,
                              },];
                return {
                        precondition_yaml => Dump(@$retval),
                       };
        }

1;

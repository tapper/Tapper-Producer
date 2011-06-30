use MooseX::Declare;

## no critic (RequireUseStrict)
class Tapper::Producer::SimnowKernel
{
        use YAML;

        use 5.010;

        use aliased 'Tapper::Config';
        use File::stat;

        sub younger { stat($a)->mtime() <=> stat($b)->mtime() }

        # try to get the kernel version by reading the files in the packet
        # this approach works since that way the kernel_version required by gen_initrd
        # even if other approaches would report different version strings
        method get_version(Str $kernelbuild)
        {
                my @files;
                if ($kernelbuild =~ m/gz$/) {
                        @files = qx(tar -tzf $kernelbuild);
                } elsif ($kernelbuild =~ m/bz2$/) {
                        @files = qx(tar -tjf $kernelbuild);
                } else {
                        return {error => 'Can not detect type of file $kernelbuild. Supported types are tar.gz and tar.bz2'};
                }
                chomp @files;
                foreach my $file (@files) {
                        if ($file =~m|boot/vmlinuz-(.+)$|) {
                                return {version => $1};
                        }
                }
        }

        method produce(Any $job, HashRef $produce) {

                my $pkg_dir     = Config->subconfig->{paths}{package_dir};
                my $arch        = 'simnow';
                my $kernel_path = $pkg_dir."/kernel";
                my $version     = '*';
                $version       .= "$produce->{version}*" if $produce->{version};

                my @kernelfiles = sort younger <$kernel_path/$arch/$version>;
                return {
                        error => 'No kernel files found',
                       } if not @kernelfiles;
                my $kernelbuild = pop @kernelfiles;
                my $retval  = $self->get_version($kernelbuild);
                if ($retval->{error}) {
                        return $retval;
                }
                my $kernel_version = $retval->{version};
                my ($kernel_major_version) = $kernel_version =~ m/(2\.\d{1,2}\.\d{1,2})/;
                ($kernelbuild)  = $kernelbuild =~ m|$pkg_dir/(kernel/$arch/.+)$|;


                $retval = [
                           {
                            precondition_type => 'package',
                            filename => $kernelbuild,
                            mountfile => '/tmp/images/openSUSE11.1.hdd',
                            mountpartition => 'p1',
                           },
                           {
                            precondition_type => 'exec',
                            filename =>  '/bin/gen_initrd_simnow.sh',
                            options => [ $kernel_version ],
                            mountfile => '/tmp/images/openSUSE11.1.hdd',
                            mountpartition => 'p1',
                           }
                          ];
                my $topic = $produce->{topic};
                if (not defined $topic) {
                        $topic  = "Simnow-kernel-";
                        $topic .= $produce->{version}."-" if $produce->{version};
                        $topic .= $kernel_major_version;
                }
                return {
                        
                        topic =>  $topic,
                        precondition_yaml => Dump(@$retval),
                       };
        }



}

1;
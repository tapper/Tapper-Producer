package Object::For::Test;

use Moose;
sub testrun_id { return 42 };

package Mock::Tapper::Test;
# object for mocking Net::SSH::Perl

use Moose;
sub login
{
        return;
}

sub cmd
{
return '
cleaning
config
building
copying
---
 - /path/to/file1
 - /here/be/file2
...
Will trigger 3 OSRC feature tests
Special tests: http://tapper/tapper/testruns/idlist/1,2,3
Normal tests: http://tapper/tapper/testruns/idlist/4,5,6
Add to list for Additional RANDCONF tests on build-server
'}

package main;

use Test::More;


use Tapper::Config;
use Test::MockModule;
use File::Temp qw(tempdir);

my $tempdir = tempdir( CLEANUP => 1 );
my $config = Tapper::Config->subconfig;
$config->{paths}{output_dir} = $tempdir;

# Net::SSH::Perl tries to login at new(). Thus we need to mock new to return
# an object that provides all functions we want to use.
my $mock_ssh = Test::MockModule->new('Net::SSH::Perl');
$mock_ssh->mock('new', sub {return Mock::Tapper::Test->new()});

use_ok('Tapper::Producer::Builder');
my $builder = Tapper::Producer::Builder->new(cfg => $config);
isa_ok($builder, 'Tapper::Producer::Builder');

my $job     = Object::For::Test->new();
my $precond = {type => "kernel", repository => "build_test", version=> "HEAD^1", buildserver => "server"};
my $retval  = $builder->produce($job, $precond);
is_deeply($retval, {
                    'precondition_yaml' =>
                    "---\nfilename: /path/to/file1\nprecondition_type: package\n".
                    "---\nfilename: /here/be/file2\nprecondition_type: package\n"},
          'Produced precondition looks as expected');
ok(-e "$tempdir/42/config/builder/kernel_server_build_test_HEAD^1.stdout", "STDOUT file $tempdir/42/config/kernel_server_build_test_HEAD^1.stdout file exists");
ok(-e "$tempdir/42/config/builder/kernel_server_build_test_HEAD^1.stderr", "STDERR file $tempdir/42/config/kernel_server_build_test_HEAD^1.stderr file exists");

done_testing();

use strict;
use warnings;

use inc::Module::Install;

name     'Tapper-Producer';
all_from 'lib/Tapper/Producer.pm';
author   'AMD OSRC Tapper Team <tapper@amd64.org>';
license  'freebsd';

build_requires 'Test::More';
build_requires 'Test::Perl::Critic';

author_requires 'Module::Install::WriteAll';

requires 'Net::SSH::Perl';
requires 'YAML';
requires 'Tapper::Config';
requires 'Tapper::Base';


auto_install;

repository 'git://github.com/amd/Tapper-Producer.git';
bugtracker 'http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tapper-Producer';

WriteAll;


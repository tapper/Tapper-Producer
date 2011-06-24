use inc::Module::Install;

name     'Tapper-Producer';
all_from 'lib/Tapper/Producer.pm';
author   q{OSRC SysInt Team <osrc-sysint@elbe.amd.com>};
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;


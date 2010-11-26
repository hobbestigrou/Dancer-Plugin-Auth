use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Dancer::Plugin::Auth',
    AUTHOR        => q{Natal Ngétal <hobbestig@cpan.org>},
    VERSION_FROM  => 'lib/Dancer/Plugin/Auth.pm',
    ABSTRACT_FROM => 'lib/Dancer/Plugin/Auth.pm',
    PREREQ_PM => {
        'Test::More'           => 0,
        'Dancer'               => 1.175,
        'Dancer::Plugin::DBIC' => 0,
        'Digest::SHA'          => 0,
    },
);

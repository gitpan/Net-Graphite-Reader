use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Net::Graphite::Reader',
    AUTHOR           => q{Ryan Olson <ryano@gimpysoft.com>},
    VERSION_FROM     => 'lib/Net/Graphite/Reader.pm',
    ABSTRACT_FROM    => 'lib/Net/Graphite/Reader.pm',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::Most'                => 0,
        'Test::MockObject::Extends' => 0,
    },
    PREREQ_PM => {
        'Moose'                => 1.0,
        'MooseX::Types::Moose' => 0.01,
        'MooseX::Types::URI'   => 0.03,
        'Furl'                 => 1.00,
        'MIME::Base64'         => 3.00,
        'JSON'                 => 2.50,
        'Try::Tiny'            => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Net-Graphite-Reader-*' },
);

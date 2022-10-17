use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'taskobs',
    VERSION_FROM      => 'taskobs.pl',
    EXE_FILES         => [qw(taskobs.pl)],
    LICENSE           => 'ISC',
    MIN_PERL_VERSION  => '5.006',
    META_MERGE => {
        'meta-spec' => { version => 2 },
        resources => {
            repository => {
                type => 'git',
                url  => 'https://github.com/qbit/taskobs.git',
                web  => 'https://github.com/qbit/taskobs',
            },
        },
    },
    PREREQ_PM         => {
	    'JSON' => '0',
    },
);

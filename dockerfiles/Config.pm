package CATS::Config;

use strict;
use warnings;

use Exporter qw(import);
our @EXPORT = qw(cats_dir);
our %EXPORT_TAGS = (all => [ @EXPORT ]);

# This is a template file, you should adjust parameters below
# and copy this file to the same folder, but with .template extenison removed.

use FindBin;
use File::Spec;

our $db = {
    name => 'db_name',
    driver => 'Pg',
    user => 'db_user',
    password => 'db_pass',
    host => 'postgres',
    role => '',
};

our $proxy = '<your-proxy-server>';

our $smtp = {
    server => '<your-smtp-server>',
    port => '<your-smtp-port>',
    login => '<your-smtp-login>',
    password => '<your-smtp-password>',
    email => '<your-smtp-email>',
};
our $health_report_email = '<your-health-report-email>';
our $absolute_url = '<your-absolute-url>';
our $relative_url = '';

our $ip_info = 'https://db-ip.com/%s';
our %ip_aliases = (
    localhost => qr/^127\.0\.0\.1$/,
);
our @ip_blocked_regexps = (
);

our $timeanddate_url = 'https://www.timeanddate.com/worldclock/fixedtime.html';
our %timeanddate_tz = (p1 => 261);
our $timezone_offset = 10.0;

# In hours.
our $judge_alive_interval = 1.0;

our $cats_dir;
sub cats_dir() {
    $cats_dir ||= $ENV{CATS_DIR} || $FindBin::Bin || '/usr/local/apache/CATS/cgi-bin/';
}

our $repos_dir = File::Spec->catdir(cats_dir(), 'repos');

our $spellcheck_dir = '/usr/share/hunspell';

our $DOWN = 0;

our $split = {
    default_cnt => 4,
    min_tests_per_job => 5,

    # Don't split solutions when jobs_queue size >
    queue_size_limit => 10,
};

1;

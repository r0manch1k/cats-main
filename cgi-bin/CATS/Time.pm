package CATS::Time;

use strict;
use warnings;

use Time::HiRes;

use CATS::Messages qw(res_str);
use CATS::Globals qw($contest $t $user);
use CATS::Utils qw(external_url_function);

sub since_contest_start_text {
    my ($dt) = @_;
    res_str($dt < 0 ? 578 : 579) . ': ' . format_diff(abs($dt));
}

sub prepare_server_time {
    $t->param(
        server_time => $contest->{server_time},
        elapsed_msg => since_contest_start_text($contest->{time_since_start} - $user->{diff_time}),
    );
}

my $half_minute = 0.5 / 24 / 60;

sub format_diff {
    my ($dt, %opts) = @_;
    $dt or return '';

    #warn "format_diff called with: " . (defined $dt ? $dt : 'undef');

    if (!ref($dt) && $dt =~ /^(\d+) days? ((\d+):(\d+):(\d+(?:\.\d+)?))$/) {
        my ($days, $hours, $minutes, $seconds) = ($1, $3, $4, $5);
        $dt = $days + ($hours * 3600 + $minutes * 60 + $seconds) / 86400;
    }
    elsif (!ref($dt) && $dt =~ /^(\d+):(\d+):(\d+(?:\.\d+)?)$/) {
        my ($hours, $minutes, $seconds) = ($1, $2, $3);
        $dt = ($hours * 3600 + $minutes * 60 + $seconds) / 86400;
    }
    if (!ref($dt) && $dt !~ /^-?\d+(?:\.\d+)?$/) {
        return '';
    }

    my $sign = $dt < 0 ? '-' : $opts{display_plus} ? '+' : '';
    $dt = abs($dt) + ($opts{seconds} ? 0 : $half_minute);
    my $days = int($dt);
    $dt = ($dt - $days) * 24;
    my $hours = int($dt);
    $dt = ($dt - $hours) * 60;
    my $minutes = int($dt);
    $dt = ($dt - $minutes) * 60;
    my $seconds = $opts{seconds} ? sprintf(':%04.1f', $dt) : '';
    $days && !$hours && !$minutes && !$seconds ? "$sign$days" . res_str(577) :
    !$days && !$hours ? $sign . sprintf('0:%02d%s', $minutes, $seconds) :
        sprintf($days ? '%s%d%s %02d:%02d%s' : '%s%4$d:%5$02d%6$s',
            $sign, $days, res_str(577), $hours, $minutes, $seconds);
}

sub format_diff_ext {
    my ($diff, $ext, %opts) = @_;
    format_diff($diff, %opts) . ($ext ? ' ... ' . format_diff($ext, %opts) : '');
}

sub timer_start {[ Time::HiRes::gettimeofday ]}
sub timer_since {Time::HiRes::tv_interval($_[0], [ Time::HiRes::gettimeofday ])}
sub timer_fmt {sprintf('%.3fs', $_[0] || 0)}

my ($start_time, $init_time);

sub mark_start {$start_time = timer_start}

sub mark_init {$init_time = timer_since($start_time)}

sub mark_finish {
    $t->param(
        request_process_time => timer_fmt(timer_since($start_time)),
        init_time            => timer_fmt($init_time),
    );
    prepare_server_time;
}

my $diff_units = { min => 1 / 24 / 60, hour => 1 / 24, day => 1, week => 7 };

sub set_diff_time {
    my ($obj, $p, $prefix) = @_;
    my $k = $diff_units->{$p->{$prefix . '_units'} // ''} or die 'Bad units';
    my $n = $prefix . '_time';
    my $val = $p->{$n} ? $p->{$n} * $k : undef;
    my $changed = ($val // 'undef') ne ($obj->{$n} // 'undef');
    $obj->{$n} = $val;
    $changed;
}

sub href_time_zone {
    my ($date_iso, $msg, $duration_hours) = @_;
    $CATS::Config::timeanddate_url or return;
    my %p = (msg => $msg, %CATS::Config::timeanddate_tz, iso => $date_iso);
    if ($duration_hours && $duration_hours < 24) {
        $p{ah} = int($duration_hours);
        $p{am} = int(($duration_hours - int($duration_hours)) * 60);
    }
    external_url_function $CATS::Config::timeanddate_url, %p;
}

our $diff_time_sql = '(COALESCE(CA.diff_time, 0) + COALESCE(CS.diff_time, 0))';
our $ext_time_sql = '(COALESCE(CA.ext_time, 0) + COALESCE(CS.ext_time, 0))';
our $contest_start_offset_sql = "(C.start_date + $diff_time_sql)";
our $contest_finish_offset_sql = "(C.finish_date + $diff_time_sql + $ext_time_sql)";
our $contest_site_finish_sql = "(C.finish_date + COALESCE(CS.diff_time, 0) + COALESCE(CS.ext_time, 0))";

1;

#!/usr/bin/perl -w
use strict;
use warnings;
use DateTime;
use DateTime::Format::DateParse;

my $Logs = '/var/log/httpd/access_log*';

my $now = DateTime->now(time_zone => 'local');
my $days_ago = DateTime->now(time_zone => 'local')->subtract(days => 21);
my @lines = `grep -h bugzilla-update.xml $Logs`;
my %seen_ips;
foreach my $line (@lines) {
    my ($ip, $time);
    # 192.18.43.225 - - [23/Mar/2010:05:59:07 -0700] "GET /bugzilla-update.xml HTTP/1.1" 200 1032 "-" "libwww-perl/5.805"
    if ($line =~ /^(\S+)[\s\-]+\[(.+?)\]/) {
        ($ip, $time) = ($1, $2);
        next if $line !~ /GET.+libwww-perl/;
    }
    else {
        warn "Unparseable line: $line\n";
        next;
    }

    my $dt = DateTime::Format::DateParse->parse_datetime($time);
    next if $dt lt $days_ago;
    $seen_ips{$ip} = 1;
}
print $now->ymd, ',', scalar(keys %seen_ips), "\n";

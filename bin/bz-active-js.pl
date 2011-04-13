#!/usr/bin/perl
use strict;
use warnings;
use lib qw(/root/lib);
use Text::CSV::Slurp;
use JSON;

use constant FILE => '/root/var/bz-active.csv';
use constant TARGET => '/var/www/html/active/active.png';

my $csv = Text::CSV::Slurp->load(file => FILE);
foreach my $item (@$csv) {
    $item->{Date} =~ s{(\d+)-(\d+)-(\d+)}{$2/$3/$1};
    $item->{Date} =~ s{(^|/)0}{$1}g;
}
my $json = JSON->new;
my $encoded = $json->encode($csv);
print "var active_installations = $encoded;";

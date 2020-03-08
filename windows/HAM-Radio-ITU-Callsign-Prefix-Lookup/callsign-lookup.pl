#!/usr/bin/perl

#use strict;
#use warnings;

#use Data::Dumper;

my $call = uc shift @ARGV;

my %db;

while (<>) {

    my ($prefix, $country) = split(/\t/, $_);

    #print "line: $_";

    chomp($country);

    if (index($prefix, '-') != -1) {
        my ($from, $to) = split('-', $prefix);
        #print "from: " . $from . " to: " . $to . "\n";
        
        $prefix = $from;
        while (1) {
            #print "prefix: " . $prefix . " country: " . $country . "\n";
            $db{$prefix} = $country;
            
            last if ($prefix eq $to);
            
            if (substr($prefix, -1, 1) eq 'Z') {
                substr($prefix, -1, 1) = 'A';
                substr($prefix, -2, 1) = chr(ord(substr($prefix, -2, 1))+1);
            } else {
                substr($prefix, -1, 1) = chr(ord(substr($prefix, -1, 1))+1);
            }
        }
        
    } else {
    
        #print "prefix: " . $prefix . " country: " . $country . "\n";
        $db{$prefix} = $country;
    }

}

#print Dumper(\%db);

my $hit = "";

foreach my $prefix (keys %db) {

    if ($prefix eq substr($call, 0, length($prefix))) {
        #print "Prefix: $prefix Country: $db{$prefix}\n";
        $hit = $prefix if (length($prefix) > length($hit));
    }

}

if ($hit) {
    print "Prefix: $hit Country: $db{$hit}\n";
} else {
    print "Not found.\n";
}

#!/usr/bin/perl

#use strict;
#use warnings;

#use Data::Dumper;

sub string_compare($$) {
  my $s1 = shift;
  my $s2 = shift;
  
  my $i = 0;
  
  while (1) {
    if ( substr($s1, $i, 1) && substr($s2, $i, 1) ) {
      if (substr($s1, $i, 1) eq substr($s2, $i, 1)) {
        $i++;
        next;
      }
    }
    last;
  }
  
  return $i;
  
}

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
            #print "Add prefix: " . $prefix . " country: " . $country . "\n";
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
    
        #print "Add prefix: " . $prefix . " country: " . $country . "\n";
        $db{$prefix} = $country;
    }

}

#print Dumper(\%db);

my $longest_match = 0;

foreach my $prefix (keys %db) {

    if (string_compare($prefix, $call) > $longest_match) {
      $longest_match = string_compare($prefix, $call);
      if ($longest_match == 3) {
      print;
      }
    }

}

if ($longest_match == 0) {
    print "Not found.\n";
    exit(1);
}

#print "longest match: $longest_match\n";

foreach my $prefix (keys %db) {

    if (string_compare($prefix, $call) == $longest_match) {
      print "Prefix: $prefix Country: $db{$prefix}\n";
    }

}
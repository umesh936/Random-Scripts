#!/usr/bin/perl -w

use strict;
require 5.6.0;
use LWP::Simple;
use LWP::UserAgent;

my $address = "xx.xx.xx.xx";
my $port = "8163";
my $username = "xxxxx";
my $pass = "xxxxxx";
my $browser = LWP::UserAgent->new;
my $req =  HTTP::Request->new( GET => "http://$address:$port/admin/xml/queues.jsp");
$req->authorization_basic( "$username", "$pass" );
my $page = $browser->request( $req );
my (%args, %queues);
my ( $tmp, $switch, $queueselect, $queuevalue);
my $key = my $value = my $i = my $k = 0;
my $num_args = "1";

# main();

$num_args = $#ARGV + 1;
if ($num_args != 1) {
    print "\nUsage: getCountForQueue.pl <Queue_Name>\n";
    exit -1;
}
 
$queueselect=$ARGV[0];
&getinfo;
$queuevalue=-1;
foreach my $str (keys %queues){
		if($queueselect eq $str){ 
                  $queuevalue = $queues{$queueselect}; 
			last; }
		else { 
			next; }
		}
print $queuevalue;
exit;

# Subroutines

	sub getinfo {
		my @lines = split ' ', $page->content();
		foreach my $line (@lines){
			if($line =~ /name/i || $line =~ /size/i){
				$line =~ s/^name="//g;
				$line =~ s/^size="//g;
				$line =~ s/"(>)?$//g;
				#print "line ".${line} ;				
				if($i == 1){
					#print "line ".${line} ;
					$queues{$tmp} = $line;
					$i = 0;
				}
				else{
					$tmp = $line;
					$i++;
				}
			}
		}
	}


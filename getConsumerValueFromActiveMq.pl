#!/usr/bin/perl -w

use strict;
require 5.6.0;
use lib qw( /usr/lib/nagios/plugins );
use utils qw(%ERRORS $TIMEOUT &print_revision &support &usage);
use Switch;
use LWP::Simple;
use LWP::UserAgent;

my $address = "54.xxx.xxx.xxx";
my $port = "8163";
my $username = "admin";
my $pass = "xxxxxx";
my $browser = LWP::UserAgent->new;
my $req =  HTTP::Request->new( GET => "http://$address:$port/admin/xml/queues.jsp");
$req->authorization_basic( "$username", "$pass" );
my $page = $browser->request( $req );
my (%args, %queues);
my %error=('ok'=>0,'critical'=>2,'unknown'=>3);
my ( $criticallevel, $tmp, $evalcount, $switch, $queueselect, $queuevalue);
my $key = my $value = my $i = my $k = 0;
my $exitcode = "unknown";

for(my $m = 0; $m <= $#ARGV; $m++){
	if($ARGV[$m] =~ /^\-/){
		if($ARGV[$m] eq "-c"||"-q"){ 

			$switch = $ARGV[$m]; 
			$args{$switch} = (); 
			if($switch eq "-q"){ $k = 1; }
 		} else { &help; }
	} else {
		if($switch eq "-q"){ 
			$args{$switch} = $ARGV[$m]; 
		} elsif($ARGV[$m] =~ /[0-9]{1,5}/){ 
			$args{$switch} = $ARGV[$m]; 
		} else { &help; }
	}
}

# main();

$criticallevel = $args{"-c"};
$queuevalue = "";
if($k == 1) { $queueselect = $args{"-q"}; }
&getinfo;

if($k == 1){
	foreach my $str (keys %queues){
		if($queueselect eq $str){ 
                  $queuevalue = $queues{$queueselect}; 
                  print $queuevalue;    last; }
		else { next; }
		}

	if($queuevalue eq ''){ $exitcode = "unknown"; exit $error{"$exitcode"};} 
	else { &checkstatus($queuevalue,$queueselect); }
} else {
	while(($key, $value) = each(%queues)){ &checkstatus($value,$key); }
}


# Subroutines

	sub getinfo {
		my @lines = split ' ', $page->content();
		foreach my $line (@lines){
			if($line =~ /name/i || $line =~ /consumerCount/i){
				$line =~ s/^name="//g;
				$line =~ s/^consumerCount="//g;
				$line =~ s/"(>)?$//g;
				if($i == 1){
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

sub checkstatus {	
	my $val=shift;
	my $key=shift;
	switch($val){
		case { $val > $criticallevel }					{ print "OK - $key holding: $val msgs "; $exitcode = "ok" }
		case { $val <= $criticallevel }					{ print "CRITICAL - $key holding: $val msgs "; $exitcode = "critical" }
		else 								{ &help; }
	}
}

sub help {
	print "Usage: activemq_watch -c <criticallevel> (-q <queue>)\n";
	$exitcode = "unknown";
	exit $error{"$exitcode"};
}

exit $error{"$exitcode"};


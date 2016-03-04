#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;
use lib 'lib';

plan tests => 1;

BEGIN {
    use_ok( 'Time::Precise' ) || print "Bail out!\n";
}

diag( "Testing Time::Precise $Time::Precise::VERSION, Perl $], $^X" );

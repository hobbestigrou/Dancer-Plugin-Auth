use strict;
use warnings;

use Test::More tests => 1;                      # last test to print


BEGIN {
    use_ok( 'Dancer::Plugin::Auth' ) || print "Bail out";
}

diag( "Testing Dancer::Plugin::Auth $Dancer::Plugin::Auth::VERSION, Perl $], $^X" );

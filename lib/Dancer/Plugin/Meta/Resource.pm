package Dancer::Plugin::Meta::Resource;

use strict;
use warnings;

use Dancer qw( :script );


sub META { die 'Must implement Resource::META';}


#sub before {}

sub process { die 'Must implement Resource::process';}

#sub after {}


1;


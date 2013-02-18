package Dancer::Plugin::Meta;

use strict;
use warnings;

use Dancer ':syntax';
use Dancer::Plugin;
use Dancer::Plugin::Meta::ResourceHandler;

use Data::Dumper;

register resources => sub {
    my ($self, $options ) = plugin_args(@_);
    
    # force the search path to an array
    my $search_path = $options->{search_path};
    $search_path = [$search_path] unless ref $search_path eq 'ARRAY';
    
    Dancer::Plugin::Meta::ResourceHandler->register_routes($search_path);

};

register_plugin;

1;

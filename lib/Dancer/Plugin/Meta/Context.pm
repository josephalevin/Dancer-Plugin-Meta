package Dancer::Plugin::Meta::Context;

use strict;
use warnings;

use Dancer ':syntax';
use Dancer::Plugin;

my $_errors;

register errors => sub {
    return unless defined wantarray;
    my ($self, @args) = plugin_args(@_);

    $_errors = [] unless defined $_errors;

    return wantarray ? @$_errors : $_errors;
};

register_plugin;

1;

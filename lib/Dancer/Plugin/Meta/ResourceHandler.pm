package Dancer::Plugin::Meta::ResourceHandler;

use strict;
use warnings;

use Dancer qw(:script);
use Dancer::Plugin::Meta::Context;

use Data::Dumper;

use Module::Pluggable::Object;

my $_meta = {};

sub register_routes {
    my ($self, $search_path) = @_;

    my %options = (
        search_path => $search_path,
        require     => 1,
    );

    my $finder = Module::Pluggable::Object->new(%options);

    info 'Beginning service resource initialization.';

    for my $resource ($finder->plugins) {
        my $meta = $resource->META();
 
        my $name = $meta->{name};
        info "Registering $name resource.";

        my $verb = lc $meta->{verb};
        my $path = $meta->{path};

        # keep track of all the operations under a resource path
        my $resource_name = $1 if $path =~ qr(^\/?(\w+)\/?);
        $_meta->{$resource_name}->{$path} = [] unless $_meta->{$resource_name}->{$path};
        push @{$_meta->{$resource_name}->{$path}}, $meta;

        # convert the path to the dancer route format, changes {param} into :param?
        $path =~ s/({([\w_\-\.]+)})/:$2?/g;


        info sprintf('%s %s => %s', uc $verb, prefix.$path, $resource );            
        # register the call for the verb and path pattern 
        Dancer::App->current->registry->universal_add($verb, $path , sub {
                                         
            my $envelope = {}; 
            # validate the input
                          
            # before resource hook
            $resource->before_process(@_);
#
            # quit if there were any errors
            if(@{errors()}){
                $envelope->{errors} = errors;                
                status (400);
                return $envelope;
            }

            # call the handler
            my ($status, $response) = $resource->process(@_);

            # wrap the response in an envelope
            $envelope->{response} = $response;

            # collect warnings and errors
                       

            # after resource hook
            #$resource->after(@_);

            #my $content = $self->process_response ($response);
                            
            # output the result
            status $status;
            return $envelope;
        }); 
    }
           
    info 'Finished application resource initialization.';
}

sub META {
    return $_meta;
}

1;


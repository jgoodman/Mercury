package Mercury::Controller::Index;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub home {
    my $self = shift;

    my $items = [
        { name => 'a', cost => '1 gp' },
        { name => 'b', cost => '2 gp' },
        { name => 'c', cost => '3 gp' },
    ];

    $self->render(items => $items);
}

1;

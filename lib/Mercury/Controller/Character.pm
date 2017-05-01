package Mercury::Controller::Character;
use Mojo::Base 'Mojolicious::Controller';

sub inventory {
    my $self = shift;

    my $i = $self->param('character_id');
    my $character = ($self->db->resultset('Character')->search({ id => $i }))[0];
    my $status = !$character ? 404 : 200;

    $self->render(character => $character, status => $status);
}

1;

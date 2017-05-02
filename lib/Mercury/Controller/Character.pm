package Mercury::Controller::Character;
use Mojo::Base 'Mojolicious::Controller';

sub inventory {
    my $self = shift;

    my $i = $self->param('character_id');
    my $character = ($self->db->resultset('Character')->search({ id => $i }))[0];

    $self->render(character => $character);
}

sub purchase_item {
    my $self = shift;

    my $character_id = $self->param('character_id');
    my $character = ($self->db->resultset('Character')->search({ id => $character_id }))[0];

    $self->increment_item_qty($character, $self->param('item_id'));

    $self->redirect_to("/character/$character_id/inventory");
}

sub increment_item_qty {
    my ($self, $character, $item_id) = @_;

    my $slot = ($character->inventory({ item_id => $item_id }))[0];
    if($slot) {
        (my $qty = $slot->qty)++;
        $slot->update({ qty => $qty});
    }
    else {
        $character->create_related('inventory', { item_id => $item_id, qty => 1 });
    }
}

1;

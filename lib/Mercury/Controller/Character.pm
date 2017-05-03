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

    my $item_id      = $self->param('item_id');
    my $item         = ($self->db->resultset('Item')->search({ id => $item_id }))[0];
    my $character_id = $self->param('character_id');
    my $character    = ($self->db->resultset('Character')->search({ id => $character_id }))[0];

    # Validate and subtract money
    unless($character->purse >= $item->cp) {
        return $self->render(error => 'Insufficient Funds', status => 400);
    }
    my $new_amount = $character->purse - $item->cp;
    warn $item->cp, $self->dumper($new_amount);
    $character->update({ purse => $new_amount });

    # Increment item quantity
    my $slot = ($character->inventory({ item_id => $item_id }))[0];
    if($slot) {
        (my $qty = $slot->qty)++;
        $slot->update({ qty => $qty});
    }
    else {
        $character->create_related(inventory => { item_id => $item_id, qty => 1 });
    }

    $self->redirect_to("/character/$character_id/inventory");
}

sub increment_item_qty {
    my ($self, $character, $item_id) = @_;

}

1;


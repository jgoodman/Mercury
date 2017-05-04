package Mercury::Controller::Character;
use Mojo::Base 'Mojolicious::Controller';

sub create {
    my $self = shift;

    my $name      = $self->param('name');
    my $character = ($self->db->resultset('Character')->create({
        name  => $name,
        purse => 0,
    }))[0];

    $self->render(character => $character);
}

sub inventory {
    my $self = shift;

    my $i = $self->param('character_id');
    my $character = ($self->db->resultset('Character')->search({ id => $i }))[0];
    return $self->render(status => 404) unless $character;

    $self->render(character => $character);
}

sub transactions {
    my $self = shift;

    my $i = $self->param('character_id');
    my $character = ($self->db->resultset('Character')->search({ id => $i }))[0];
    return $self->render(status => 404) unless $character;

    my @transactions = $self->db->resultset('TransactionLog')->search({ character_id => $i });
    $self->render(transactions => \@transactions);
}

sub purchase_item {
    my $self = shift;

    my $item_id      = $self->param('item_id');
    my $item         = ($self->db->resultset('Item')->search({ id => $item_id }))[0];
    my $character_id = $self->param('character_id');
    my $character    = ($self->db->resultset('Character')->search({ id => $character_id }))[0];

    return $self->render(status => 404) unless $character && $item;

    unless($character->purse >= $item->cp) {
        return $self->render(error => 'Insufficient Funds', status => 400);
    }

    my $guard = $self->db->txn_scope_guard; # start transaction

    my $transact_log = ($self->db->resultset('TransactionLog')->create({
        character_id  => $character_id,
        item_id       => $item_id,
        item_cost     => $item->cost,
        item_currency => $item->currency,
        purse_prepay  => $character->purse,
    }))[0];

    my $new_amount = $character->purse - $item->cp;
    $character->update({ purse => $new_amount });
    $transact_log->update({ purse_postpay => $new_amount });

    # Increment item quantity
    my $slot = ($character->inventory({ item_id => $item_id }))[0];
    if($slot) {
        (my $qty = $slot->qty)++;
        $slot->update({ qty => $qty});
    }
    else {
        $character->create_related(inventory => { item_id => $item_id, qty => 1 });
    }

    $guard->commit;

    $self->redirect_to("/character/$character_id/inventory");
}

sub increment_item_qty {
    my ($self, $character, $item_id) = @_;

}

1;

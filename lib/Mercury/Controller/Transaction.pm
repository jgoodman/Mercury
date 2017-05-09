package Mercury::Controller::Transaction;
use Mojo::Base 'Mojolicious::Controller';

sub form_deposit {
    my $self = shift;
    $self->render(
        post_url_ref     => $self->param('post_url_ref') || '',
        callback_url_ref => $self->param('callback_url_ref') || '',
    );
}

sub deposit {
    my $self = shift;

    my $category     = 'deposit';
    my $name         = $self->param('name');
    my $amount       = $self->param('amount');
    my $character_id = $self->param('character_id');
    my $character    = ($self->db->resultset('Character')->search({ id => $character_id }))[0];

    return $self->render(status => 404) unless $character;

    my $guard = $self->db->txn_scope_guard; # start transaction

    my $transact_log = ($self->db->resultset('TransactionLog')->create({
        category      => $category,
        character_id  => $character_id,
        name          => $name,
        item_cost     => $amount,
        item_currency => 'cp',
        purse_prepay  => $character->purse,
    }))[0];

    my $new_amount = $character->purse + $amount;
    $character->update({ purse => $new_amount });
    $transact_log->update({ purse_postpay => $new_amount });

    $guard->commit;

    my $callback_url_ref = $self->param('callback_url_ref') || '';
    $self->redirect_to("$callback_url_ref/transaction");
}

1;

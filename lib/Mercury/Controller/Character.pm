package Mercury::Controller::Character;
use Mojo::Base 'Mojolicious::Controller';

sub inventory {
    my $self = shift;
    my $status;

    # TODO This should be in the Result class please

    my $i = $self->param('character_id');

    my $items = [ ];
    my $character  = ($self->db->resultset('Character')->search({ id => $i }))[0];
    if($character) {
        my @inventory = $self->db->resultset('Inventory')->search({
            character_id => $i,
        });
        foreach my $slot (@inventory) {
            my $item = ($self->db->resultset('Item')->search({ id => $slot->item_id }))[0];

            $item->{id}   = $item->id;
            $item->{name} = $item->name;
            $item->{cost} = $item->cost . ' ' . $item->currency;
            $item->{qty}  = $slot->qty;

            push(@$items, $item);
        }
        $status = 200;
    }
    else {
        $status = 404;
    }

    $self->render(items => $items, status => $status);
}

1;

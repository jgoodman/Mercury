package Mercury::Controller::Character;
use Mojo::Base 'Mojolicious::Controller';

sub _characters {
    return [
        { character_id => 1, name => 'Bob', inventory => { 1 => 2 } },
        { character_id => 2, name => 'Sue', inventory => { 3 => 1 } },
    ];
}

sub _items {
    return [
        { item_id => 1, name => 'Goat',          cost => '1 gp' },
        { item_id => 2, name => 'Ginger (1lbs)', cost => '2 gp' },
        { item_id => 3, name => 'Pig',           cost => '3 gp' },
    ];
}

sub inventory {
    my $self = shift;
    my $status;

    my $i = $self->param('character_id');
    $i--;

    my $items = [ ];
    my $character  = _characters()->[$i];
    if($character) {
        my $inventory = $character->{inventory};
        foreach my $item_id (sort keys %$inventory) {
            my $qty = $inventory->{$item_id};

            --$item_id;
            my $item = _items()->[$item_id];
            $item->{qty} = $qty;

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

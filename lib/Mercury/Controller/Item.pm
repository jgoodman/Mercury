package Mercury::Controller::Item;
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

# This action will render a template
sub list {
    my $self = shift;
    $self->render(items => _items());
}

sub info {
    my $self = shift;

    my $i = $self->param('item_id');
    $i--;

    my $item = _items()->[$i];
    my $status = $item ? 200 : 404;

    my $character_id = $self->param('character_id');

    my $img_file = '/images/item/' . $item->{'item_id'} . '.jpg';
    $self->render(
        character_id  => $character_id,
        item     => $item,
        img_file => $img_file,
        status   => $status
    );
}

sub purchase {
    my $self = shift;
    $self->render(msg => 'Item purchased');
}

1;

package Mercury::Controller::Item;
use Mojo::Base 'Mojolicious::Controller';

sub list {
    my $self  = shift;
    my @items = $self->db->resultset('Item')->search;
    $self->render(items => \@items);
}

sub info {
    my $self = shift;

    my $item = ($self->db->resultset('Item')->search({
        id => $self->param('item_id'),
    }))[0];
    my $status = !$item ? 404 : 200;
    my $img_file = '/images/item/' . $item->id . '.jpg';

    my $character_id = $self->param('character_id');

    $self->render(
        character_id  => $character_id,
        item     => $item,
        img_file => $img_file,
        status   => $status
    );
}

1;

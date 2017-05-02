package Mercury::Controller::Item;
use Mojo::Base 'Mojolicious::Controller';

sub list {
    my $self  = shift;
    my @items = $self->db->resultset('Item')->search(undef, {
            order_by => { -asc => [ qw(category type subtype currency cost name) ] }
        });
    $self->render(items => \@items);
}

sub info {
    my $self = shift;

    my $item = ($self->db->resultset('Item')->search({
        id => $self->param('item_id'),
    }))[0];

    my $img_file = '/images/item/' . $item->id . '.jpg';
    my $character_id = $self->param('character_id');

    $self->render(
        character_id  => $character_id,
        item          => $item,
        img_file      => $img_file,
    );
}

1;

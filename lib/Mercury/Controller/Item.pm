package Mercury::Controller::Item;
use Mojo::Base 'Mojolicious::Controller';

use Mojo::Util qw(dumper);
use Mojo::URL;
use Mojo::File;
use List::MoreUtils qw(uniq);
use Image::Grab;

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

sub form_image {
    my $c  = shift;
    $c->render(item_id => $c->param('item_id'));
};

sub missing_image {
    my $c  = shift;
    my @items = grep {
            ! -e $c->config->{'image_dir'}.'/'.$_->id.'.jpg'
        } $c->db->resultset('Item')->search(undef, {
            order_by => { -asc => [ qw(category type subtype currency cost name) ] },
        });
    $c->render(items => \@items);
};

sub query_images {
    my $c  = shift;

    my ($item_id, $search, $links) = @{_pull_images($c, undef)};
    $c->render(
        item_id => $item_id,
        search  => $search,
        links   => $links,
    );
};

sub _pull_images {
    my $c = shift;
    my $start_index = shift;

    my $item_id = $c->param('item_id');
    my $item    = ($c->db->resultset('Item')->search({ id => $item_id }))[0];
    my $search  = $c->param('search') || $item->name;

    my $cx = $c->config->{'google_search_api'}->{'cx'};
    if (ref $cx eq 'HASH') {
        my $cx_key = $cx->{$item->category} ? $item->category : 'fallback';
        $cx = $cx->{$cx_key} || die 'No cx fallback defined';
        $c->app->log->info("Google CSE Engine ID - [$cx_key] $cx");
    }

    my $url = Mojo::URL->new;
    $url->scheme('https');
    $url->host('www.googleapis.com');
    $url->path('/customsearch/v1');
    $url->query(
        key => $c->config->{'google_search_api'}->{'key'},
        cx  => $cx,
        q   => $search,
        ($start_index ? (start => $start_index) : ()),
    );

    $c->app->log->info('Google CSE Request - GET => '.$url->to_string);
    my $resp = $c->ua->get($url->to_string)->res->json;
    $c->app->log->info('Google CSE Response - '.dumper($resp));

    my @links;
    my $results = $resp->{'items'} || [ ];
    foreach my $result (@$results) {
        my $pagemap = $result->{"pagemap"};
        push @links, grep { $_ } map { $_->{"og:image"} } @{$pagemap->{'metatags'}};
        push @links, grep { $_ } map { $_->{"src"} } @{$pagemap->{'cse_image'}};
    }
    @links = grep { !blacklist($_) } uniq(@links);

    my $next_index = $resp->{"queries"}->{"nextPage"}->[0]->{"startIndex"};
    if(!$start_index && $next_index) {
        push @links, @{_pull_images($c, $next_index)->[2]};
    }

    return [$item_id, $search, \@links];
}

sub set_image {
    my $c = shift;
    my $ref = $c->param('ref');
    my $item_id = $c->param('item_id');

    my $image_dir = $c->config->{'image_dir'};

    $c->app->log->info("Grab Image - $ref");
    my $pic = Image::Grab->new;
    $pic->url($ref);
    $pic->grab;

    $c->app->log->info("Save Image - $image_dir/$item_id.jpg");
    my $path = Mojo::File->new("$image_dir/$item_id.jpg");
    $path->spurt($pic->image);

    #`wget -O $image_dir/$item_id.jpg $ref`;

    $c->redirect_to('/items/missing/image');
};

sub blacklist {
    my $url = shift;
    my @blacklist = (
        qr/facebook_share_image.png/
    );
    grep { $url !~ $_ } @blacklist ? 1 : 0;
}

1;

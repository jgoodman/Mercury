package Mercury;
use Mojo::Base 'Mojolicious';
use Mercury::Schema;
use Mojo::UserAgent;

has ua => sub { return Mojo::UserAgent->new };
has schema => sub {
    # TODO: config connect settings
    return Mercury::Schema->connect('dbi:SQLite:' . ($ENV{TEST_DB} || 'test.db'));
};

sub startup {
  my $self = shift;

  $self->helper(db => sub { $self->app->schema });

  my $config = $self->plugin('Config');

  my $r = $self->routes;
  $r->get('/')->to('index#home');
  $r->get('/items')->to('item#list');
  $r->get('/items/missing/image')->to('item#missing_image');
  $r->get('/item/:item_id')->to('item#info');
  $r->get('/item/:item_id/query/images')->to('item#query_images');
  $r->post('/item/:item_id/image')->to('item#set_image');
  $r->get('/item/:item_id/form/image')->to('item#form_image');

  $r->post('/character')->to('character#create');
  $r->get('/character/:character_id')->to('character#info');
  $r->get('/character/:character_id/inventory')->to('character#inventory');
  $r->get('/character/:character_id/transactions')->to('character#transactions');
  $r->post('/character/:character_id/purchase_item/:item_id')->to('character#purchase_item');

  #$r->get('/merchants')->to('merchant#list');
  #$r->get('/merchant/:merchant_id/items')->to('merchant#items');
  #$r->get('/merchant/:merchant_id/item/:item_id')->to('merchant#item');
  #$r->post('/merchant/:merchant_id/item/:item_id/purchase')->to('merchant#item_purchase');
}

1;

package Mercury;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $app = shift;

  my $config = $app->plugin('Config');

  my $r = $app->routes;
  $r->get('/')->to('index#home');
  $r->get('/items')->to('item#list');
  $r->get('/item/:item_id')->to('item#info');
  $r->post('/item/:item_id/purchase/character/:character_id')->to('item#purchase');

  $r->get('/character/:character_id/inventory')->to('character#inventory');

  #$r->get('/merchants')->to('merchant#list');
  #$r->get('/merchant/:merchant_id/items')->to('merchant#items');
  #$r->get('/merchant/:merchant_id/item/:item_id')->to('merchant#item');
  #$r->post('/merchant/:merchant_id/item/:item_id/purchase')->to('merchant#item_purchase');
}

1;

use utf8;
package Mercury::Schema::Result::Inventory;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table("inventory");

__PACKAGE__->add_columns(
  id           => { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  character_id => { data_type => "integer", is_nullable => 0 },
  item_id      => { data_type => "integer", is_nullable => 0 },
  qty          => { data_type => "integer", is_nullable => 0 },
);

__PACKAGE__->set_primary_key("id");

1;

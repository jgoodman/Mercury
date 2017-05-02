use utf8;
package Mercury::Schema::Result::ItemMeta;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table("item_meta");

__PACKAGE__->add_columns(
  id           => { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  item_id      => { data_type => "integer", is_nullable => 0 },
  name         => { data_type => "varchar", is_nullable => 0 },
  value        => { data_type => "varchar", is_nullable => 0 },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(item => 'Mercury::Schema::Result::Item', 'item_id');

1;

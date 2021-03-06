use utf8;
package Mercury::Schema::Result::Character;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table("character");

__PACKAGE__->add_columns(
  id    => { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  name  => { data_type => "varchar", is_nullable => 0 },
  purse => { data_type => "integer", is_nullable => 0 },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many(inventory => 'Mercury::Schema::Result::Inventory', 'character_id');

1;

use utf8;
package Mercury::Schema::Result::Item;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table("item");

__PACKAGE__->add_columns(
  id       => { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  name     => { data_type => "varchar", is_nullable => 0 },
  cost     => { data_type => "integer", is_nullable => 0 },
  currency => { data_type => "varchar", is_nullable => 0 },
);

__PACKAGE__->set_primary_key("id");

1;

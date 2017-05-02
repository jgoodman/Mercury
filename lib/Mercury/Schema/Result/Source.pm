use utf8;
package Mercury::Schema::Result::Source;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table("source");

__PACKAGE__->add_columns(
  id   => { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  type => { data_type => "varchar", is_nullable => 1 },
  name => { data_type => "varchar", is_nullable => 0 },
);

__PACKAGE__->set_primary_key("id");

1;

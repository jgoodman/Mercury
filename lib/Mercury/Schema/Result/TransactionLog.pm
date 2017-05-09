use utf8;
package Mercury::Schema::Result::TransactionLog;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table("transaction_log");

__PACKAGE__->add_columns(
  id            => { data_type => "integer",   is_nullable => 0, is_auto_increment => 1 },
  timestamp     => { data_type => "timestamp", is_nullable => 0, default_value => \"current_timestamp" },
  character_id  => { data_type => "integer",   is_nullable => 0 },
  category      => { data_type => "varchar",   is_nullable => 1 },
  name          => { data_type => "varchar",   is_nullable => 1 },
  item_id       => { data_type => "integer",   is_nullable => 1 },
  item_cost     => { data_type => "varchar",   is_nullable => 1 },
  item_currency => { data_type => "varchar",   is_nullable => 1 },
  purse_prepay  => { data_type => "integer",   is_nullable => 1 },
  purse_postpay => { data_type => "integer",   is_nullable => 1 },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(item => 'Mercury::Schema::Result::Item' => 'item_id');

1;

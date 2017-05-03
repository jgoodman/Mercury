use utf8;
package Mercury::Schema::Result::Item;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table("item");

__PACKAGE__->add_columns(
  id         => { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  name       => { data_type => "varchar", is_nullable => 0 },
  category   => { data_type => "varchar", is_nullable => 1 },
  type       => { data_type => "varchar", is_nullable => 1 },
  subtype    => { data_type => "varchar", is_nullable => 1 },
  cost       => { data_type => "varchar", is_nullable => 1 },
  currency   => { data_type => "varchar", is_nullable => 1 },
  weight     => { data_type => "varchar", is_nullable => 1 },
  desc       => { data_type => "varchar", is_nullable => 1 },
  source_id  => { data_type => "integer", is_nullable => 1 },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many(meta     => 'Mercury::Schema::Result::ItemMeta', 'item_id');
__PACKAGE__->belongs_to(source => 'Mercury::Schema::Result::Source',   'source_id');

sub cp {
    my $self = shift;

    my $c = $self->cost;
    my %map = (
        cp => $c,
        sp => $c * 10,
        gp => $c * 10 * 10,
        pp => $c * 10 * 10 * 10,
    );

    my $cur = $self->currency;
    return $map{$cur} || die 'unknown currency';
}

1;

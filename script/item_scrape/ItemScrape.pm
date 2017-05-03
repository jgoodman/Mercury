package ItemScrape;
use strict;
use warnings;

use Mojo::UserAgent;
use Mojo::File;
use Mojo::Util qw(dumper);
use Text::Unidecode qw(unidecode);
use HTML::Entities;

use FindBin qw($Bin);
use lib "$Bin/../../lib";
use Mercury::Schema;

sub new {
    my $class = shift;
    my $self  = shift || { };
    bless $self, $class;
}

sub space    { shift->{'space'} }
sub category { shift->{'category'} }
sub src      { shift->{'src'} }
sub schema   { shift->{'schema'} ||= Mercury::Schema->connect('dbi:SQLite:' . ($ENV{TEST_DB} || 'test.db')) }
sub ua       { shift->{'ua'}     ||= Mojo::UserAgent->new }

sub source {
    my $self = shift;
    $self->{'source'} ||= (
        $self->schema->resultset('Source')->find_or_create({ type => 'web', name => $self->src })
    )[0];
}

sub _data_file {
    my $self = shift;
    return "$Bin/.data/" . $self->space . '/'. $self->category
}

sub import_data {
    my $self     = shift;

    print '['._clean($self->category)."] Importing data \n";
    foreach my $hash (@{ require($self->_data_file)} ) {
        $hash->{'source_id'} ||= $self->source->id;
        $hash->{'category'}  ||= $self->category;

        print ' -> '
              . join(', ', map { "$_:"._clean($hash->{$_}) } sort(keys(%$hash)))
              . "\n";

        $self->schema->resultset('Item')->find_or_create($hash);
    }
    print "\n";

    return $self;
}

sub scrape_opts { shift->{'scrape_opts'} }
sub scrape_html {
    my $self     = shift;
    return $self if -e $self->_data_file || $self->scrape_opts->{'skip'};
    $self->_parse_table;
    return $self;
}

sub _dom {
    my $self = shift;
    ($self->{'src_page'} ||= $self->ua->get($self->src))->res->dom;
}

sub _parse_table {
    my $self = shift;

    my @rows;
    my $category = $self->category;
    my $id       = $self->scrape_opts->{id};
    my @types    = @{$self->scrape_opts->{types}};

    print '['._clean($category)."] Parsing HTML - table#$id tbody\n";

    foreach my $group (
        $self->_dom->find("table#$id tbody")
            ->map(sub {
                my $d = $_;
                [ $d->find('tr')->map(sub { [ $_->find('td')->map('content')->each ] })->each ];
            })
            ->each
    ) {
        my $type = shift(@types) // die('Out of types');
        my $subtype;

        print ' -> ['.join(':',map { _clean($_) } ($category,$type))."] Processing individual type\n";

        foreach my $values (@$group) {
            if(scalar(@$values) == 1) {
                ($subtype = $values->[0]) =~ s|</?i>||g;
                print ' -> ['.join(':',map { _clean($_) } ($category,$type,$subtype))."] Setting subtype\n";
                next;
            }

            my %item = (
                name      => decode_entities(unidecode(shift(@$values))),
                category  => $category,
                type      => defined($type)    ? lc $type    : '',
                subtype   => defined($subtype) ? lc $subtype : '',
                source_id => $self->source->id,
            );

            $item{'subtype'} =~ s{\s*$category\s*$}{};

            my %meta;
            my @cols = @{$self->_columns};
            foreach my $value (@$values) {
                my $key = lc(shift(@cols));
                $value = decode_entities(unidecode($value));
                $value = undef if $value eq '--';
                $value =~ s{<sup>\d+</sup>}{}g if defined $value;
                if($key =~ m/cost|weight/) {
                    $item{$key} = $value;
                    if($key eq 'cost') {
                        my @remainder;
                        ($item{'cost'}, $item{'currency'}, @remainder) = split(" ", ($item{cost} // ''));
                        $item{'currency'} .= join(' ', @remainder);
                        $item{'currency'} = delete $item{'cost'} if ($item{'cost'} // '') !~ m/^\+?\d+$/;
                    }
                }
                else {
                    $meta{$key} = $value;
                }
            }


            foreach my $k (keys %item) {
                next unless defined $item{$k};
                $item{$k} =~ s{^\s*(\S)}{$1};
                $item{$k} =~ s{(\S)\s*$}{$1};
            }

            print ' -->> '
                  . join(', ', map { "$_:"._clean($item{$_}) } sort(keys(%item)))
                  . "\n";
            push @rows, \%item;
        }
    print "\n";
    }
    print "\n";
    Mojo::File->new($self->_data_file)->spurt(dumper(\@rows));
}

sub _clean { my $v = shift; defined $v ? ('"'.$v.'"') : '(undef)' }

sub _columns {
    my $self = shift;

    return $self->scrape_opts->{columns} if $self->scrape_opts->{columns};

    return $self->{'_columns'} ||= do {
        warn 'Loading columns';
        my $id = $self->scrape_opts->{id};
        my @columns = $self->_dom->find("table#$id thead")
            ->first('content')
            ->find('th')
            ->map('content')
            ->map( sub { s|<sup>\d+</sup>||r } )
            ->each;

        shift(@columns); # remove family

        @columns = map {
            my $k = $_;
            $k =~ s|<[^>]+>([^<>]+)</[^>]+>|$1|g;
            lc($k);
        } @columns;

        #print '"' . join('", "', @columns) . '"' . "\n";
        \@columns;
    };
}

1;

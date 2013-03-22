package Net::Graphite::Reader::Response;
use Moose;
use namespace::autoclean;

use Net::Graphite::Reader::Response::Metric;

use JSON qw(decode_json);
use Try::Tiny;

=head1 NAME

Net::Graphite::Reader::Response - The results of a query

=head1 ATTRIBUTES

=head2 metrics

A list of metrics that were returned.
(Net::Graphite::Reader::Response::Metric objects)

=cut

has 'metrics' => (
  is      => 'ro',
  isa     => 'ArrayRef[Net::Graphite::Reader::Response::Metric]',
  traits  => [qw(Array)],
  handles => { all_metrics => 'elements', },
);

around BUILDARGS => sub {
  my $orig  = shift;
  my $class = shift;

  # Handle a single non-ref argument as JSON.
  if ( @_ == 1 && ! ref($_[0]) ) {
    my $json = $_[0];

    my $data = try { decode_json($json); }
      catch {
        my $error = $_;

        die("Error decoding passed JSON: $_");
      };

    return $class->$orig({metrics => [ map { Net::Graphite::Reader::Response::Metric->new($_) } @$data ]});
  }
  # Handle a passed arrayref as decoded JSON from Graphite.
  elsif ( @_ == 1 && ref($_[0]) eq 'ARRAY' ) {
    return $class->$orig({metrics => [ map { Net::Graphite::Reader::Response::Metric->new($_) } @{$_[0]} ]});
  }
  else {
    return $class->$orig(@_);
  }
};

=head1 METHODS

=cut

__PACKAGE__->meta->make_immutable;

1;

package Net::Graphite::Reader::Response::Metric;
use Moose;
use namespace::autoclean;

use List::Util;

=head1 NAME

Net::Graphite::Reader::Response::Metric - The data for a single metric

=head1 ATTRIBUTES

=head2 target 

The target of the metric

=cut

has 'target' => (
  is       => 'ro',
  isa      => 'Str',
  required => 1,
);

=head2 datapoints

The raw data for this metric returned from Graphite.

=cut

has 'datapoints' => (
  is => 'ro',
  isa => 'ArrayRef',
  traits => ['Array'],
  handles => {
    all_datapoints => 'elements',
  }
);

=head1 METHODS

=head2 non_null_datapoints

Return the data points for which Graphite has a value.

=cut

sub non_null_datapoints {
  my $self = shift;

  my @metrics = grep { defined $_->[0] } $self->all_datapoints;

  return wantarray ? @metrics : \@metrics;
}

=head2 average

Returns the average of the non-null data points in the response for
this metric.

=cut

sub average {
  my $self = shift;

  my @non_null_data = $self->non_null_datapoints;

  return undef if ! @non_null_data;

  return List::Util::sum(map { $_->[0] } @non_null_data) / @non_null_data;
}

=head2 sum

Returns the sum of the non-null data points in the response for this
metric.

=cut

sub sum {
  my $self = shift;

  return List::Util::sum(map { $_->[0] } $self->non_null_datapoints);
}

__PACKAGE__->meta->make_immutable;

1;

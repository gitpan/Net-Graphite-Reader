use strict;
use warnings;

use Test::Most;
use Test::MockObject::Extends;

use Net::Graphite::Reader::Response::Metric;

my $metric = Net::Graphite::Reader::Response::Metric->new(
  target     => 'this.is.my.metric',
  datapoints => [
    [ undef,              1363580040 ],
    [ undef,              1363580100 ],
    [ undef,              1363580160 ],
    [ 37.0,               1363580220 ],
    [ 62.5,               1363580280 ],
    [ 61.0,               1363580340 ],
    [ 60.333333333333336, 1363580400 ],
  ],
);

isa_ok($metric,'Net::Graphite::Reader::Response::Metric');

my $non_null = $metric->non_null_datapoints;

cmp_ok(@$non_null,'==',4,'null data points filtered');

ok(is_close($metric->average,55.2083333333333),'Average of a metric.');
ok(is_close($metric->sum,220.8333333333),'Sum of a metric.');

# Calculate an average

done_testing();

sub is_close {
  my $value_a = shift;
  my $value_b = shift;
  my $epsilon = shift || 0.0001;

  return abs($value_a - $value_b) < $epsilon;
}

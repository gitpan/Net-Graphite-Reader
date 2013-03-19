use strict;
use warnings;

use Test::Most;
use Test::MockObject::Extends;

use Furl;

use Net::Graphite::Reader;

# Mock our test data.
my $furl = Furl->new();

$furl = Test::MockObject::Extends->new();

$furl->set_isa('Furl');

isa_ok($furl,'Furl');

$furl->mock('get',sub{
  my $content = <<'  EOF';
  [
    {"target": "this.is.my.metric",
      "datapoints": [
        [0, 1363557600],
        [1, 1363561200],
        [2, 1363564800],
        [3, 1363568400],
        [4, 1363572000]
      ]
    }
  ]
  EOF

  return Furl::Response->new(undef,200,'OK',{},$content);
});

# Correct number of metrics should be returned.
my $reader = Net::Graphite::Reader->new(furl => $furl, uri => 'http://example.com');

my $response = $reader->query(
  target => 'this.is.my.metric',
  from   => '-24hours',
  to     => 'now',
);

isa_ok($response,'Net::Graphite::Reader::Response');

my @metrics = $response->all_metrics;

cmp_ok(@metrics,'==',1,'Number of returned metrics');

done_testing();

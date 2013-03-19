use strict;
use warnings;

use Test::Most;
use Test::MockObject::Extends;

use Net::Graphite::Reader::Response;

# Build a response from json.
{
  my $json = <<'  EOF';
[
  {"target": "test.metric.one",
    "datapoints": [
      [null, 1363557600],
      [null, 1363561200],
      [null, 1363564800],
      [null, 1363568400],
      [null, 1363572000]
    ]
  },
  {"target": "test.metric.one",
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

  my $response = Net::Graphite::Reader::Response->new($json);

  my @metrics = $response->all_metrics;

  cmp_ok(@metrics,'==',2,'Received two metrics');
}

# Build a response from decoded json.
{
  my $data = [
    {
      "target"     => "test.metric.one",
      "datapoints" => [
        [ undef, 1363557600 ],
        [ undef, 1363561200 ],
        [ undef, 1363564800 ],
        [ undef, 1363568400 ],
        [ undef, 1363572000 ]
      ]
    },
    {
      "target"     => "test.metric.one",
      "datapoints" => [
        [ 0, 1363557600 ],
        [ 1, 1363561200 ],
        [ 2, 1363564800 ],
        [ 3, 1363568400 ],
        [ 4, 1363572000 ]
      ]
    }
  ];

  my $response = Net::Graphite::Reader::Response->new($data);

  my @metrics = $response->all_metrics;

  cmp_ok(@metrics,'==',2,'Received two metrics');
}

done_testing();

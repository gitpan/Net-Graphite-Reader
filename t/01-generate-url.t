use strict;
use warnings;

use Test::Most;

use Net::Graphite::Reader;

my $reader = Net::Graphite::Reader->new(
  uri => 'http://example.com'
);

# Single metric
{
  my $uri = $reader->_build_query_uri({
    target => ['this.is.my.test.metric'],
    from   => '-24hours',
    until  => 'now',
  });

  like($uri, qr{^http://example\.com/render}, 'URI is base + /render path');
  like($uri, qr{format=json}, 'Requesting in json format');
  like($uri, qr{target=this\.is\.my\.test\.metric}, 'target parameter is present.');
  like($uri, qr{from=-24hours}, 'from parameter is present');
  like($uri, qr{until=now}, 'until parameter is present');
}

# Multiple metrics
{
  my $uri = $reader->_build_query_uri({
    target => ['this.is.my.first.metric','this.is.my.second.metric'],
    from   => '-24hours',
    until  => 'now',
  });

  like($uri, qr{^http://example\.com/render}, 'URI is base + /render path');
  like($uri, qr{format=json}, 'Requesting in json format');
  like($uri, qr{target=this\.is\.my\.first\.metric}, 'first target parameter is present.');
  like($uri, qr{target=this\.is\.my\.second\.metric}, 'second target parameter is present.');
  like($uri, qr{from=-24hours}, 'from parameter is present');
  like($uri, qr{until=now}, 'until parameter is present');

}

done_testing();

package Net::Graphite::Reader;
use Moose;
use namespace::autoclean;
our $VERSION = '0.01';

use MooseX::Types::Moose qw(:all);
use MooseX::Types::URI qw(Uri);

use Furl;
use JSON qw(decode_json);
use MIME::Base64 qw(encode_base64);

use Net::Graphite::Reader::Response;

=head1 NAME

Net::Graphite::Reader - Access to Graphite's raw data

=head1 ATTRIBUTES

=head2 uri

Base URI to your graphite instance

=cut

has 'uri' => (
  is       => 'ro',
  isa      => Uri,
  coerce   => 1,
  required => 1,
);


=head2 username

Username (if using basic auth)

=cut

has 'username' => (
  is        => 'ro',
  isa       => Str,
  predicate => '_has_username',
);


=head2 password

Password (if using basic auth)

=cut

has 'password' => (
  is        => 'ro',
  isa       => Str,
  predicate => '_has_password',
);


=head2 furl

Alternative Furl instance to use

=cut

has 'furl' => (
  is      => 'ro',
  isa     => 'Furl',
  lazy    => 1,
  builder => '_build_furl',
);

sub _build_furl {
  my ($self) = @_;
  my %parms = ( timeout => 120 );
  if ( $self->_has_username || $self->_has_password ) {
    $parms{headers} = [
      Authorization => 'Basic ' . encode_base64(join(':',
        $self->_has_username ? $self->username : '',
        $self->_has_password ? $self->password : '',
      )),
    ];
  }
  Furl->new(%parms);
}


=head1 METHODS

=head2 query

=cut

sub query {
  my ($self,%args) = @_;

  my $target = delete $args{target} || die("No target specified");
  $target = ref($target) eq 'ARRAY' ? $target : [$target];

  my $from   = delete $args{from}   || "-1days";
  my $to     = delete $args{to}     || "now";

  my $query = {
    target => $target,
    from   => $from,
    to     => $to,
  };

  my $uri = $self->_build_query_uri($query);

  my $res = $self->furl->get($uri);
  die $res->status_line unless $res->is_success;

  return Net::Graphite::Reader::Response->new($res->content);
}

sub _build_query_uri {
  my $self  = shift;
  my $query = shift;

  my $uri = $self->uri->clone;
  $uri->path('/render');
  $uri->query_form({
    %$query,
    format => 'json',
  });

  return $uri;
}

__PACKAGE__->meta->make_immutable;

1;

package Ambassador::API::V2;
# ABSTRACT: Speak with the getambassador.com API v2

use Moo;
use v5.10;

use Ambassador::API::V2::Role::HasJSON;
use HTTP::Tiny;
use URI;


=head1 SYNOPSIS

    use Ambassador::API::V2;

    my $api = Ambassador::API::V2->new(
        username	=> $app_username,
        key			=> $app_key
    );

    my $result = $api->post('/event/record/' => {
        email			=> 'fake@fakeity.fake',
        campaign_uid	=> 1234
    });

    my $result = $api->get('/shortcode/get/' => {
        short_code	=> $mbsy,
    });

=head1 DESCRIPTION

Speak with the L<getambassador.com> API version 2. See
L<https://docs.getambassador.com>.

=attr username

The username for your app. C<YOUR_APP_USERNAME> in the API docs.

=cut

has username => (
	is 			=> 'ro',
	required 	=> 1
);

=attr key

The key for your app. C<YOUR_APP_KEY> in the API docs.

=cut

has key => (
	is 			=> 'ro',
	required	=> 1
);

=attr url

The URL to call.

Defaults to L<https://getambassador.com/api/v2/>

=cut

has url => (
    is			=> 'ro',
	coerce		=> sub {
		return URI->new($_[0]);
	},
	default		=> sub { 'https://getambassador.com/api/v2/' }
);

# Configure and cache the HTTP::Tiny object
has http => (
    is			=> 'ro',
    default		=> sub {
        return HTTP::Tiny->new(
			agent			=> "Ambassador-API-V2/$VERSION",
			default_headers	=> {
				'Content-Type' => 'application/json'
			}
		);
    }
);


=method new

    my $api = Ambassador::API::V2->new(
        %attributes
    );

Creates a new Ambassador::API::V2 object.

=cut

=method post

=method get

    my $response = $api->post($method, \%args);
    my $response = $api->get($method, \%args);

Call an Ambassador API C<$method> with the given C<%args>.

If successful, it returns an L<Ambassdor::API::V2::Response>.
If it fails, it will throw an L<Ambassador::API::V2::Error>.

See the L<Ambassador API docs|https://docs.getambassador.com/docs/>
for what $methods are available, what C<%args> they take, and which
should be called with C<get> or C<post>.

=cut

sub _make_url {
	my $self = shift;
	my $method = shift;

	return URI->new($self->url . $method);
}

sub _handle_response {
	my $self = shift;
	my($response) = @_;

	die Ambassador::API::V2::Error->new_from_response($response) if !$response->{success};

	return Ambassador::API::V2::Result->new_from_response($response);
}

sub _request {
	my $self = shift;
	my($type, $method, $args) = @_;

	my $url = $self->_make_url($method);

	my $response = $self->http->request(
		uc $type,
		$url,
		{ content => $self->json->encode($args) }
	);

	return $self->_handle_response($response);
}

sub post {
	my $self = shift;
	return $self->request('POST', @_);
}

sub get {
	my $self = shift;
	return $self->request('GET', @_);
}

1;

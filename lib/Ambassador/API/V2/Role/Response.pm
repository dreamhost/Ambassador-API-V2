package Ambassador::API::V2::Role::Response;
# ABSTRACT: A response from the getambassador.com API v2

use Moo::Role;
use Carp;
use Types::Standard ":types";
with 'Ambassador::API::V2::Role::HasJSON';


=head1 DESCRIPTION

Encapsulates the Ambassador Response Format.

See L<https://docs.getambassador.com/docs/response-codes>.

=attr http_response

The original HTTP::Tiny response.

=cut

has http_response => (
	is			=> 'ro',
	isa			=> HashRef,
	required	=> 1,
);

=attr response

The Ambassador "response" as a hash ref.

=attr code

The Ambassador "code" field.

B<NOT> the HTTP repsonse code.

=attr message

The Ambassador "message" field.

=cut

has response => (
	is			=> 'lazy',
	isa			=> HashRef,
	required	=> 1,
);

sub _build_response {
	my $self = shift;

	my $content = eval { $self->json->decode($self->http_response->{content}); };
	croak "Failed to decode @{[ $self->http_response->{content} ]}" if !$content;
	return $content->{response};
}

has code => (
	is			=> 'lazy',
	isa			=> Int,
	required	=> 1,
);

sub _build_code {
	my $self = shift;

	return $self->response->{code};
}

has message => (
	is			=> 'lazy',
	isa			=> Str,
	required	=> 1
);

sub _build_message {
	my $self = shift;

	return $self->response->{message};
}

=method new_from_response

    my $response = Ambassador::API::V2::Response->new_from_response(
        $http_tiny_response
    );

Returns a new object from an HTTP::Tiny response hash ref.

=cut

sub new_from_response {
	my $class = shift;
	my $res = shift;

	return $class->new( http_response => $res );
}

=method is_success

Returns whether the repsonse was successful or not.

=cut

sub is_success {
	my $self = shift;

	return $self->code == 200;
}

=head1 SEE ALSO

L<Ambassador::API::V2::Result>
L<Ambassador::API::V2::Error>

=cut

1;

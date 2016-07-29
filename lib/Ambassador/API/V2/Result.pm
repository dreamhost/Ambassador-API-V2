package Ambassador::API::V2::Result;
# ABSTRACT: A successful API response

use Moo;
use Types::Standard ":types";
with 'Ambassador::API::V2::Role::Response';

=head1 DESCRIPTION

L<Ambassador::API::V2::Role::Response> plus...

=attr data

The "data" portion of an Ambassador response as a hash ref.

=cut

has data => (
	is			=> 'lazy',
	isa			=> HashRef,
	required	=> 1
);

sub _build_data {
	my $self = shift;

	return $self->response->{data};
}

1;

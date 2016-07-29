package Ambassador::API::V2::Error;
# ABSTRACT: An error response from the Ambassador API

use Moo;
use Types::Standard ':types';
with 'Ambassador::API::V2::Role::Response';

use overload
  '""' 		=> \&as_string,
  fallback 	=> 1;

=head1 DESCRIPTION

L<Ambassador::API::V2::Role::Response> plus...

=attr errors

An array ref of errors returned by the Ambassador API.

=cut

has errors => (
	is		=> 'lazy',
	isa		=> ArrayRef,
);

sub _build_errors {
	my $self = shift;

	return $self->response->{errors}{error};
}


=method as_string

  my $string = $error->as_string;

Returns the C<< $error->message >> and C<< $error->errors >> formatted
for human consumption.

=cut

sub as_string {
	my $self = shift;

	return join '', map { "$_\n" } $self->message, @{$self->errors};
}


=head2 Overloading

If used as a string, C<as_string> will be called.

    print $error;

=cut

1;

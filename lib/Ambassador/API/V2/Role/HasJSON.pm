package Ambassador::API::V2::Role::HasJSON;
# ABSTRACT: Adds a json attribute with a JSON::MaybeXS object

use Moo::Role;
use JSON::MaybeXS;

=attr json

Returns a JSON::MaybeXS object.

=cut

# Configure and cache the JSON object
has json => (
    is      => 'ro',
    default => sub {
        return JSON->new->utf8(1);
    }
);

1;

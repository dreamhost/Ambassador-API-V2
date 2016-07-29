use Test2::Bundle::Extended -target => 'Ambassador::API::V2';
use Test2::Tools::Spec;

describe bad_args => sub {
	my $Args;
	case no_args 		=> sub { $Args = {} };
	case no_key  		=> sub { $Args = { username => "blah" } };
	case no_username	=> sub { $Args = { key => "blah" } };

	tests args_error => sub {
		like dies { $CLASS->new($Args) }, qr/Missing required arguments: /;
	};
};

tests get => sub {
    SKIP: {
		for my $key (qw(TEST_AMBASSADOR_API_V2_USERNAME TEST_AMBASSADOR_API_V2_KEY)) {
			skip "Set $key for sandbox API tests" unless $ENV{$key};
		}

		my $api = $CLASS->new(
			username 	=> $ENV{TEST_AMBASSADOR_API_V2_USERNAME},
			key			=> $ENV{TEST_AMBASSADOR_API_V2_KEY},
		);

		my $response = $api->get('/shortcode/get/', {
			short_code		=> '6ClZ',
			sandbox			=> "1"
		});

		ok $response->is_success;
		like $response->data->{shortcode},
		  hash {
			  field valid 			=> 1;
			  field sandbox 		=> 1;
			  field discount_value	=> 'schrug';
		  };
	}
};

done_testing;

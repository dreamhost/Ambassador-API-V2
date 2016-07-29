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

done_testing;

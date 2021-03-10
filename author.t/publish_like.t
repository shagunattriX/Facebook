use Test::More tests => 4;
use lib '../lib';

use_ok('Facebook::Graph');
my $fb = Facebook::Graph->new;
isa_ok($fb, 'Facebook::Graph');

die "You need to set an environment variable for FB_ACCESS_TOKEN to test this" unless $ENV{FB_ACCESS_TOKEN};

$fb->access_token($ENV{FB_ACCESS_TOKEN});

warn 'a';
my $response = $fb->add_like('635277468_144288935595157')
  ->publish;
warn 'b';
use Data::Dumper;
eval{$response->as_json};
print Dumper($@)."\n";
warn 'c';
my $out = $response->as_hashref;
ok(ref $out eq 'HASH', 'got a hash back') or debug($response->as_json);
ok(exists $out->{id}, 'we got back an id');


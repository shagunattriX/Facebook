use strict;
use warnings;

use Test::More tests => 3;
use lib '../lib';

use_ok('Facebook::Graph');
my $fb = Facebook::Graph->new;
isa_ok($fb, 'Facebook::Graph');

die "You need to set an environment variable for FB_ACCESS_TOKEN to test this" unless $ENV{FB_ACCESS_TOKEN};

$fb->access_token($ENV{FB_ACCESS_TOKEN});

my $response = $fb->rsvp_attending('1727225617504143')
  ->publish;
is($response->as_string, '{"success":true}', 'we get back a true string');


package Facebook::Graph::Authorize;

use Moo;
with 'Facebook::Graph::Role::Uri';

has app_id => (
    is      => 'ro',
    required=> 1,
);

has postback => (
    is      => 'ro',
    required=> 1,
);

has permissions => (
    is          => 'rw',
    lazy        => 1,
    predicate   => 'has_permissions',
    default     => sub { [] },
);

has display => (
    is      => 'rw',
    default => sub { 'page' },
);

sub extend_permissions {
    my ($self, @permissions) = @_;
    push @{$self->permissions}, @permissions;
    return $self;
}

sub set_display {
    my ($self, $display) = @_;
    $self->display($display);
    return $self;
}

sub uri_as_string {
    my ($self) = @_;
    my $uri = $self->uri;
    $uri->path('oauth/authorize');
    my %query = (
        client_id       => $self->app_id,
        redirect_uri    => $self->postback,
        display         => $self->display,
    );
    if ($self->has_permissions) {
        $query{scope} = join(',', @{$self->permissions});
    }
    $uri->query_form(%query);
    return $uri->as_string;
}

1;


=head1 NAME

Facebook::Graph::Authorize - Authorizing an app with Facebook


=head1 SYNOPSIS

 my $fb = Facebook::Graph->new(
    secret      => $facebook_application_secret,
    app_id      => $facebook_application_id,
    postback    => 'https://www.yourapplication.com/facebook/postback',
 );

 my $uri = $fb->authorize
    ->extend_permissions(qw( email publish_stream ))
    ->set_display('popup')
    ->uri_as_string;

=head1 DESCRIPTION

Get an authorization code from Facebook so that you can request an access token to make privileged requests. The result of this package is to give you a URI to redirect a user to Facebook so they can log in, and approve whatever permissions you are requesting.

=head1 METHODS

=head2 new ( [ params ] )

=over

=item params

A hash or hashref of parameters to pass to the constructor.

=over

=item app_id

The application id that you get from Facebook after registering (L<http://developers.facebook.com/setup/>) your application on their site.

=item postback

The URI that Facebook should post your authorization code back to.

=back

=back

=head2 extend_permissions ( permissions )

Ask for extra permissions for your app. By default, if you do not request extended permissions your app will have access to only general information that any Facebook user would have. Returns a reference to self for method chaining.

=head3 permissions

An array of permissions. See L<http://developers.facebook.com/docs/authentication/permissions> for more information about what's available.


=head2 uri_as_string ( )

Returns a URI string to redirect the user back to Facebook.



=head1 LEGAL

Facebook::Graph is Copyright 2010 - 2012 Plain Black Corporation (L<http://www.plainblack.com>) and is licensed under the same terms as Perl itself.

=cut

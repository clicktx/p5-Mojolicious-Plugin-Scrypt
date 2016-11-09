package Mojolicious::Plugin::Scrypt;
use Mojo::Base 'Mojolicious::Plugin';
use Crypt::ScryptKDF qw/scrypt_hash scrypt_hash_verify random_bytes/;

our $VERSION = '0.01';

sub register {
    my ( $self, $app, $conf ) = @_;

    $app->helper(
        scrypt => sub {
            my $c = shift;
            my ( $secret, $salt ) = ( shift, shift || _salt() );

            return scrypt_hash( $secret, $salt );
        }
    );

    $app->helper(
        scrypt_verify => sub {
            my $c = shift;
            my ( $plain, $encoded ) = @_;

            #returns: 1 (ok) or 0 (fail)
            return scrypt_hash_verify( $plain, $encoded );
        }
    );
}

sub _salt {
    my $len = shift || 20;
    random_bytes($len);
}

1;
__END__

=encoding utf8

=head1 NAME

Mojolicious::Plugin::Scrypt - Mojolicious Plugin

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('Scrypt');

  # Mojolicious::Lite
  plugin 'Scrypt';

=head1 DESCRIPTION

L<Mojolicious::Plugin::Scrypt> is a L<Mojolicious> plugin.

=head1 METHODS

L<Mojolicious::Plugin::Scrypt> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 AUTHOR

Munenori Sugimura <clicktx@gmail.com>

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicious.org>.

=cut

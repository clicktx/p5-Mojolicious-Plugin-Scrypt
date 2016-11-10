package Mojolicious::Plugin::Scrypt;
use Mojo::Base 'Mojolicious::Plugin';
use Crypt::ScryptKDF qw/scrypt_hash scrypt_hash_verify/;

our $VERSION = '0.01';

sub register {
    my ( $self, $app, $conf ) = @_;
    my $salt_len = $conf->{salt_length}    || 32;
    my $N        = $conf->{cost}           || 16384;
    my $r        = $conf->{block_size}     || 8;
    my $p        = $conf->{parallelism}    || 1;
    my $len      = $conf->{derived_length} || 32;

    $app->helper(
        scrypt => sub {
            my $c = shift;
            my ( $secret, $salt ) = @_;
            unless ($salt) {
                return scrypt_hash( $secret, \$salt_len, $N, $r, $p, $len );
            }
            return scrypt_hash( $secret, $salt, $N, $r, $p, $len );
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

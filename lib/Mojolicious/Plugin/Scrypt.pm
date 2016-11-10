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

Mojolicious::Plugin::Scrypt - Scrypt password for Mojolicious

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('Scrypt');

  # Mojolicious::Lite
  plugin 'Scrypt';

=head2 Plugin Configurations

    $self->plugin( 'Scrypt', {
        salt_length     => int,     # default: 32
        cost            => int,     # default: 16384
        block_size      => int,     # default: 8
        parallelism     => int,     # default: 1
        derived_length  => int,     # default: 32
    });

For more infomation see L<Crypt::ScryptKDF>.

=head1 DESCRIPTION

L<Mojolicious::Plugin::Scrypt> is a L<Mojolicious> plugin.

=head1 HELPERS

=head2 scrypt

    my $encoded = $app->scrypt($password);

    my $salt = 'saltSalt';
    my $encoded2 = $app->scrypt($password, $salt);

=head2 scrypt_verify

    sub login {
        my $c = shift;
        my $password = $c->param('password');
        my $encoded = get_hash_from_db();

        if ( $c->scrypt_verify($password, $encoded) ){
            # Authenticated
            ...
        } else {
            # Fail
            ...
        }
    }


=head1 METHODS

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 AUTHOR

Munenori Sugimura <clicktx@gmail.com>

=head1 SEE ALSO

L<Crypt::ScryptKDF>, L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicious.org>.

=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 LICENSE of Mojolicious::Plugin::I18N

Mojolicious::Plugin::LocaleTextDomainOO uses Mojolicious::Plugin::I18N code. Here is LICENSE of Mojolicious::Plugin::I18N

This program is free software, you can redistribute it and/or modify it under the terms of the Artistic License version 2.0.

=cut

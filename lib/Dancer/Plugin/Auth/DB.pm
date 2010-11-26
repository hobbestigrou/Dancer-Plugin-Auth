package Dancer::Plugin::Auth::DB;

use strict;
use warnings;
use Dancer ':syntax';
use Dancer::Plugin;
use Dancer::Plugin::DBIC;
use Digest::SHA qw(sha256);

=head1 NAME

Dancer::Plugin::Auth::DB - Interface for manage authentication with DBIX.

=encoding utf8

=cut

my $settings  = plugin_setting;
my $tablename = $settings->{table_name};
my $rowuser   = $settings->{row_user};
my $rowpass   = $settings->{row_pass};

register subscribe => sub {
    my ( $username, $password, $schema_table ) = @_;

    my $password_crypt = sha256( $password );
    my $search_user = schema->resultset($tablename)->find({
        $rowuser => $username,
    });

    if ( $search_user ) {
        die "User already exists";
    }
 
   $schema_table->{$rowuser} = $username;
   $schema_table->{$rowpass} = $password_crypt;

   my $user = schema->resultset($tablename)->create(
       $schema_table
   );

  if ( ! $user ) {
      die "Error not subscribe";
  }
};

register login => sub {
    my ( $username, $password ) = @_;
    
    my $password_crypt = sha256( $password );
    my $user_login  = schema->resultset($tablename)->find({
        $rowuser => $username,
        $rowpass => $password_crypt,
    });

   if ( $user_login ) {
       session user_id => $user_login->{id};
       session user    => $username;
       return 1;
   } 
   else {
       die "Not login user";
   }
};

register logout => sub {
    session->destroy;
};

register_plugin;

=head1 SYNOPSIS

    use Dancer;
    use Dancer::Plugin::Auth::DB;

    get '/login' => sub {
        login();
    };
    
    dance;

=head1 DESCRIPTION

Provides an easy to manage authentication with a database for Dancer application.
This module use Dancer::Plugin::DBIC. In the config file you must specified the
name of the table contain the user, name of the row for username and password.

This module use SHA256 digests to store password.

=head1 CONFIGURATION

     plugins:
         Auth::DB:
           table_name: 'Mytable'
           row_user: 'name_row_user'
           row_pass: 'name_row_pass'

=head1 METHODS

=head2 subscribe($username, $password, $schema) 

To add a new user in a database. The lastest argument is hashref and is optional. 

=head2 login($username, $password)

To login. If login is succesful, add user_id and user_name in session.

=head2 logout

To logout.

=head1 AUTHOR

Natal Ngétal, C<< <hobbestigrou@cpan.org> >>

L<Dancer>
L<Dancer::Plugin::DBIC>
l<Digest::SHA>

=cut 

1;

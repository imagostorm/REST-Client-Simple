package REST::Client::Simple;

use 5.014002;
use strict;
use warnings;
use LWP;
use Data::Dumper;
use LWP::Debug '+';

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $self = bless {@_}, $class;
    map { $self->{ '_' . $_ } = $self->{$_} } qw/host port no_keep_alive/;
    return $self;
}

sub get {
    my $self   = shift;
    my %params = @_;
    $params{type} = 'get';
    return $self->_request(%params);
}

sub GET {
    my $self = shift;
    return $self->get(@_);
}

sub host {
    my $self = shift;
    return $self->{_host};
}

sub _request {
    my $self    = shift;
    my %params  = @_;
    my $type    = $self->_get_type( $params{type} );
    my $headers = $params{headers};
    my $content = $params{content};
    my $data    = $params{data};
    my $path    = $params{path};
    my $url     = $self->_get_url($path);
    my $req     = HTTP::Request->new( $type => $url );

    unless ( $self->{_no_keep_alive} ) {
        $req->header( 'Connection' => 'Keep-Alive' );
    }

    # die Dumper $req;
    my $result = $self->_ua->request($req);
    if ( $result->is_success ) {
        my $processed = $self->_process_result($result);
    }
    else {
        die Dumper $result;
    }
}

sub _get_type {
    my $self = shift;
    return uc(shift);
}

sub _get_url {
    my $self     = shift;
    my $host     = $self->host;
    my $path     = shift;
    $path ||= '';
    $host  ||= '';
    my $params   = shift;
    my $fullpath = $host . $path;
    my @url_parts =
      map { my $value = $params->{$_}; "$_=$value" } keys %$params;
    $fullpath .= join( "&", @url_parts );
    $fullpath =~ s/\/+/\//g;
    $fullpath = 'http://' . $fullpath unless $fullpath =~ /^http:\/\//;
    $fullpath .= '/' unless $fullpath =~ /\/$/;
    return $fullpath;
}

sub _ua {
    my $self = shift;
    unless ( $self->{_ua} ) {
        $self->{_ua} = LWP::UserAgent->new;
    }
    return $self->{_ua};
}

sub _parse {
    my $self    = shift;
    my $result  = shift;
    my $content = $result->content;

    my $type = $self->{_type} || 'auto';
    my $parse_method = "__parse_$type";
    return $self->$parse_method($content);
}

sub _process_result {
    my $self     = shift;
    my $result   = shift;
    my $hash_ref = $self->_parse($result);
}

sub __parse_json {
    my $self        = shift;
    my $json_string = shift;
    require JSON;
    my $json   = new JSON;
    my $parsed = $json->decode($json_string);
    return $parsed;
}

sub __parse_yaml {
    my $self = shift;
    die;
}

sub __parse_xml {
    my $self = shift;
    die;
}

sub __parse_auto {
    my $self    = shift;
    my $content = shift;
    my $parsed  = eval { $self->__parse_json($content) };
    if ( $@ && !$parsed ) {
        $parsed = eval { $self->__parse_yaml($content) };
    }
    if ( $@ && !$parsed ) {
        $parsed = eval { $self->__parse_xml($content) };
    }
    if ( $@ && !$parsed ) {
        return $content;
    }
}

sub _json {
    my $self = shift;
    unless ( $self->{_json} ) {
        require JSON;
        $self->{_json} = new JSON;
    }
    return $self->{_json};
}

sub _xml {
    my $self = shift;
    unless ( $self->{_xml} ) {
        require XML::Simple;
        my $xs = new XML::Simple;
        $self->{_xml} = $xs;
    }
    return $self->{_xml};
}

# Preloaded methods go here.

1;
__END__

=head1 NAME

REST::Client::Simple - universal REST client with primitive interface.

=head1 SYNOPSIS

  use REST::Client::Simple;
  my $client = REST::Client::Simple->new(host => 'my.super.host', port => 80);
  my $result = $client->get(path => '', params => {}, headers => {});
  
  
  =head1 RESULTING TYPE RECOGNIZING
  
  
  =head1 METHODS
  
  
  =head2 new 
  
  
  =head2 GET
  
  =head2 POST 

=head1 DESCRIPTION
ion other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.


=head1 AUTHOR

Polina Shubina, E<lt>imagostorm@gmail.com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by imagostorm

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.


=cut

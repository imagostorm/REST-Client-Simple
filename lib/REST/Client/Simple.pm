package REST::Client::Simple;

use 5.014002;
use strict;
use warnings;

our $VERSION = '0.01';


# Preloaded methods go here.

1;
__END__

=head1 NAME

REST::Client::Simple - universal REST client with primitive interface.

=head1 SYNOPSIS

  use REST::Client::Simple;
  my $client = REST::Client::Simple->new(host => 'my.super.host', port => 80);
  my $result = $client->get(path => '', params => {}, headers => {});

=head1 DESCRIPTION

Stub documentation for REST::Client::Simple, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

algol, E<lt>algol@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by algol

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.


=cut

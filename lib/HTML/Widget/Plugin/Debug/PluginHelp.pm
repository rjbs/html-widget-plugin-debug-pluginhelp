use strict;
use warnings;

package HTML::Widget::Plugin::Debug::PluginHelp;
use base qw(HTML::Widget::Plugin);

=head1 NAME

HTML::Widget::Plugin::Debug::PluginHelp - help on your loaded plugins, in HTML

=head1 VERSION

version 0.001

  $Id$

=cut

our $VERSION = '0.001';

=head1 DESCRIPTION

This plugin dumps a bunch of HTML documenting the core and specific API for the
factory's plugins.

=cut

use HTML::Element;

=head1 METHODS

=head2 C< provided_widgets >

This plugin provides the following widgets: plugin_help

=cut

sub provided_widgets { qw(plugin_help) }

=head2 C< plugin_help >

This method returns a whole bunch of HTML.

No arguments are expected or respected.

=cut

sub attribute_args { qw() }
sub boolean_args   { qw() }

sub plugin_help {
  my ($self, $factory, $arg) = @_;

  my $html = '';

  $html .= "<h1>Making a widget:</h1>\n";
  $html .= "<code>\$factory->widget_type({ argument => value, ... })</code>\n";

  $html .= "<h1>Glossary</h1>\n<dl>\n"

         . "<dt>Attribute Args</dt>\n"
         . "<dd>These may be supplied as top-level arguments, but become "
         . "attributes of the produced elements.<dd>\n"

         . "<dt>Boolean Args</dt>\n"
         . "<dd>These are a special form of attribute args; if they're true, "
         . "the value in element's attributes is the attribue name.  Thus, "
         . '<code>{ disabled => 1 }</code> becomes '
         . '<code>disabled="disabled"</code>.</dd>'

         . "</dl>\n"
         ;


  $html .= "<h1>Plugins</h1>\n";
  for my $plugin (sort $factory->plugins) {
    $html .= "<h2>$plugin</h2>\n";

    $html .= "<h3>provided widgets</h3>\n";
    if (my @widgets = $plugin->provided_widgets) {
      $html .= "<ul>\n";
      $html .= "<li>" . (ref $_ ? $_->[1] : $_) . "</li>\n"
        for $plugin->provided_widgets;
      $html .= "</ul>\n";
    } else {
      $html .= "(none)";
    }

    $html .= "<h3>attribute args</h3>\n";
    if (my @args = $plugin->attribute_args) {
      my %is_bool = map { $_ => 1 } $plugin->boolean_args;
      $html .= "<ul>\n";
      $html .= "<li>$_" . ($is_bool{$_} ? ' (boolean)' : '') . "</li>\n"
        for @args;
      $html .= "</ul>\n";
    } else {
      $html .= "(none)";
    }
  }

  return "<div style='max-width:45em;margin-left:auto;margin-right:auto'>$html</div>";
}

=head1 AUTHOR

Ricardo SIGNES <C<rjbs @ cpan.org>>

=head1 COPYRIGHT

Copyright (C) 2005-2007, Ricardo SIGNES.  This is free software, released under
the same terms as perl itself.

=cut

1;

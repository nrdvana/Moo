use strictures 1;
use Test::More;
use Test::Fatal;

use Moo ();

BEGIN {
  package BaseClass;

  sub new {
    my $class = shift;
    my $self = bless {}, $class;
    return $self;
  }
}

BEGIN {
  package ExtraClass;

  sub new {
    my $class = shift;
    $class->next::method(@_);
  }
}

BEGIN {
  package ChildClass;
  use Moo;
  extends 'BaseClass';

  unshift our @ISA, 'ExtraClass';
}

like exception {
  ChildClass->new;
}, qr/Parent constructor of ChildClass was expected to be BaseClass, but found ExtraClass/,
  'Interfering with @ISA after using extends triggers error';

done_testing;

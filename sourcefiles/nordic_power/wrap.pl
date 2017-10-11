#!/usr/bin/perl -w

use Text::Wrap;
$Text::Wrap::columns = 75;

@lines = <>;
@wrapped = Text::Wrap::wrap('', '', @lines);

print @wrapped;
#!/usr/bin/perl -w
# iDOC= policy page

# Imports
use idoc;

# Retrieve parameters
my ($language) = @ARGV or die "Usage: $0 [language]\n";

die "Illegal language: $language" if (not $dateformats{$language});

# Page titles
my %titles = (
	sv	=> 'Riktlinjer för iDOC=',
	en	=> 'iDOC= policy',
	de	=> 'Die iDOC= Richtlinien',
	fi	=> 'iDOC=:n suuntaviivat',
	es	=> 'Las politicas del iDOC=',
	hu	=> 'Az iDOC= szabályzata',
);

# Charset identifier if necessary
my $meta = '';
if ($language eq "hu")
{
	$meta = '<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-2">';
}
else
{
	$meta = '<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1">';
}

# Print page
print <<"EOM";
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="$language" dir="ltr">
<head>
 $meta
 <title>$titles{$language}</title>
 <link rev="made" href="m&#65;ilto:peter&#64;softwolves.pp&#46;se">
 <link rel="stylesheet" type="text/css" href="idoc.css">
EOM

&langlinks($language, 'policy.%s.html', %titles);

print <<"EOM";
 <link rel="search" href="search">
 <link rel="top" href="./">
 <meta name="author" content="Peter Karlsson">
 <meta name="keywords" content="cbm, c64, documentation, international, project, project 64, commodore 64, eight-bit, svenska, deutsch, english, hungarian, magyar">
</head>

<body bgcolor="#ffffcc" text="#000000" link="#0000cc" alink="#880000"
      vlink="#000088">

EOM

# Document body
page($language, $dateformats{$language}, "policy", "policy.input");

# Link back
page($language, $dateformats{$language}, "policy", "backtohome.input");

# Trailer
print <<"EOM";
<hr noshade>
<a href="http://validator.w3.org/check?uri=http://cbm.6502.org/policy.$language.html">
 <img src="../pics/vh401.gif" width=88 height=31 border=0
  alt="[HTML 4.01]"></a>

<a href="http://jigsaw.w3.org/css-validator/validator?uri=http://cbm.6502.org/idoc.css">
 <img src="../pics/vcss.gif" width=88 height=31 border=0 alt="[CSS 2]"></a>

</body>
</html>
EOM

# We're done!

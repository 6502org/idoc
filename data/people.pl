#!/usr/bin/perl -w
# iDOC= people page

# Imports
use File::Basename;
use lib dirname (__FILE__);
use idoc;

# Retrieve parameters
my ($language) = @ARGV or die "Usage: $0 [language]\n";

die "Illegal language: $language" if (not $dateformats{$language});

# Page titles
my %titles = (
	sv	=> 'Folket bakom iDOC=',
	en	=> 'iDOC= people',
	de	=> 'Die Leute hinter iDOC=',
	fi	=> 'iDOC=:n tekijät',
	es	=> 'La gente del iDOC=',
	hu	=> 'Az iDOC= résztvevői',
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

&langlinks($language, 'people.%s.html', %titles);

print <<"EOM";
 <link rel="top" href="./">
 <meta name="author" content="Peter Krefting">
 <meta name="keywords" content="cbm, c64, documentation, international, project, project 64, commodore 64, eight-bit, svenska, deutsch, english, hungarian, magyar">
</head>

<body bgcolor="#ffffcc" text="#000000" link="#0000cc" alink="#880000"
      vlink="#000088">
EOM

# Document body
page($language, $dateformats{$language}, "people", "people.input");

# Table

printlist($language,
          $paths{'datadir'} . "/people.list");

print "<p><!--<small>$lastupdated{$language} ";
filedate($paths{'datadir'} . "/people.list",
         $dateformats{$language});
print "</small>--></p>\n";

# Link back
page($language, $dateformats{$language}, "people", "backtohome.input");

# Trailer
print <<"EOM";
<hr noshade>
<img src="pics/vh401.gif" width=88 height=31 border=0 alt="[HTML 4.01]">
<img src="pics/vcss.gif" width=88 height=31 border=0 alt="[CSS 2]">

</body>
</html>
EOM

# We're done!

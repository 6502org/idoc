#!/usr/bin/perl -w
# iDOC= introductory page

# Imports
use File::Basename;
use lib dirname (__FILE__);
use idoc;

# Retrieve parameters
my ($language) = @ARGV or die "Usage: $0 [language]\n";

die "Illegal language: $language" if (not $dateformats{$language});

# Page titles
my %titles = (
	sv	=> 'Introduktion till iDOC=',
	en	=> 'Introduction to iDOC=',
	de	=> 'Einführung in iDOC=',
	fi	=> 'iDOC=:n esittely',
	es	=> 'Introducción a iDOC=',
	hu	=> 'Bevezetés az iDOC-ba',
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

&langlinks($language, 'intro.%s.html', %titles);

print <<"EOM";
 <link rel="search" href="search">
 <link rel="top" href="./">
 <meta name="author" content="Peter Krefting">
 <meta name="keywords" content="cbm, c64, documentation, international, project, project 64, commodore 64, eight-bit, svenska, deutsch, english, hungarian, magyar">
</head>

<body bgcolor="#ffffcc" text="#000000" link="#0000cc" alink="#880000"
      vlink="#000088">

EOM

# Document body
page($language, $dateformats{$language}, "intro", "intro.input");

# Link back
page($language, $dateformats{$language}, "intro", "backtohome.input");

# Trailer
print <<"EOM";
<hr noshade>
<img src="../pics/vh401.gif" width=88 height=31 border=0 alt="[HTML 4.01]">
<img src="../pics/vcss.gif" width=88 height=31 border=0 alt="[CSS 2]">

</body>
</html>
EOM

# We're done!

#!/usr/bin/perl -w
# iDOC= main page

# Imports
use File::Basename;
use lib dirname (__FILE__);
use idoc;

# Retrieve parameters
my ($language) = @ARGV or die "Usage: $0 [language]\n";

die "Illegal language: $language" if (not $dateformats{$language});

# Page titles
my %titles = (
	sv	=> 'iDOC=',
	en	=> 'iDOC=',
	de	=> 'iDOC=',
	fi	=> 'iDOC=',
	es	=> 'iDOC=',
	hu	=> 'iDOC=',
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
 <title>iDOC=</title>
 <link rev="made" href="m&#65;ilto:peter&#64;softwolves.pp&#46;se">
 <link rel="stylesheet" type="text/css" href="idoc.css">
EOM

&langlinks($language, 'index.%s.html', %titles);

print <<"EOM";
 <link rel="top" href="./">
 <meta name="author" content="Peter Krefting">
 <meta name="keywords" content="cbm, c64, documentation, international, project, project 64, commodore 64, eight-bit, svenska, deutsch, english, hungarian, magyar">
</head>

<body bgcolor="#ffffcc" text="#000000" link="#0000cc" alink="#880000"
      vlink="#000088">

EOM

# Document body
page($language, $dateformats{$language}, "index", "main.input");

# Tables
# Requests
%requesttitles = (
	sv => "Efterfrĺgade dokument",
	en => 'Requested documents',
	de => "Gesuchte Dokumente",
	fi => "Kaivatuimmat dokumentit",
	es => 'Documentos solicitados',
	hu => 'Keresett dokumentumok',
);

print "<h3 class=main>$requesttitles{$language}</h3>\n";
print "<!--<small>$lastupdated{$language}";
filedate($paths{'datadir'} . "/requests.list",
         $dateformats{$language});
print "</small>--><p>\n";

printlist($language,
          $paths{'datadir'} . "/requests.list");

# Current projects

%currentprojects = (
	sv => "Pĺgĺende projekt",
	en => "Current projects",
	de => "Projekte, an denen gerade gearbeitet wird",
	fi => "Keskeneräiset hankkeet",
	es => 'Proyectos actuales',
	hu => 'Folyamatban lévő projektek',
);

print "<h3 class=main>$currentprojects{$language}</h3>\n";
print "<!--<small>$lastupdated{$language} ";
filedate($paths{'datadir'} . "/currentprojects.list",
         $dateformats{$language});
print "</small>--><p>\n";

printlist($language,
          $paths{'datadir'} . "/currentprojects.list");

# Document footer
page($language, $dateformats{$language}, "index", "main-footer.input");

# Trailer
print <<"EOM";
<hr noshade class=decorative>
<a href="https://www.softwolves.pp.se/cbm/">Softwolves' CBM page</a>
<hr noshade>
<img src="pics/vh401.gif" width=88 height=31 border=0 alt="[HTML 4.01]">
<img src="pics/vcss.gif" width=88 height=31 border=0 alt="[CSS 2]">
EOM

# Anyborwser campaign
%anybrowser = (
	en => qq'<a href="http://www.anybrowser.org/campaign/"><img src="pics/anybrowser3.gif" alt="Best viewed with ANY browser."',
	sv => qq'<a href="http://www.anybrowser.org/campaign/anybrowser_swe.html"><img src="pics/anybr_sw.gif" alt="Visas bäst med VALFRI vävläsare."',
	de => qq'<a href="http://www.anybrowser.org/campaign/anybrowser_de.html"><img src="pics/allebr.gif" alt="Geeignet für ALLE Brauser."',
	fi => qq'<a href="http://www.anybrowser.org/campaign/"><img src="pics/anybrowser3.gif" alt="Tämä sivu näkyy parhaiten MILLÄ TAHANSA selaimella."',
	es => qq'<a href="http://www.anybrowser.org/campaign/"><img src="pics/anybrowser3.gif" alt="Se ve mejor con CUALQUIER navegador."',
	hu => qq'<a href="http://www.anybrowser.org/campaign/"><img src="pics/anybrowser3.gif" alt="Bármilyen böngészővel jól olvasható."',
);

print $anybrowser{$language},
      qq' width="88" height="31" border="0"></a>\n';

# Trailer, part 2
print <<"EOM";

</body>
</html>
EOM

# We're done!

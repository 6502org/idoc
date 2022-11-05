#!/usr/bin/perl -w
# iDOC= etexts

# Imports
use File::Basename;
use lib dirname (__FILE__);
use idoc;
use POSIX qw(strftime);

# Retrieve parameters
my ($language, $list, $sorting) = @ARGV
	or die "Usage: $0 [language] [list] [sorting]\n";

die "Illegal language" if (not $dateformats{$language});

# Page titles
my %titles = (
	sv	=> 'iDOC=s dokument',
	en	=> 'iDOC= documents',
	de	=> 'iDOC=-Dokumente',
	fi	=> 'iDOC=:n dokumentit',
	es	=> 'Documentos iDOC=',
	hu	=> 'iDOC= dokumentumok',
);

# Load titles and other strings
if ($language eq "sv")
{
	%strings = (
		hw => "Maskinvaru-/fastprogramrelaterat",
		ms => "Blandat",
		gm => "Spelrelaterat",
		pr => "Programmeringsrelaterat",
		vc => "VIC 20",
		c2 => "C128",
		all => "Samtliga dokument",
		isFilename => "Filnamn",
		isSize => "Storlek",
		bytes => "byte",
		isTitle => "Titel",
		isLanguage => "Språk",
		isAddedon => "Tillagd den",
		isNew => "Ny!",
		none => "ingen sortering",
		file => "sorterat efter filnamn",
		name => "sorterat efter titel",
		sv => "Svenska",
		en => "Engelska",
		de => "Tyska",
		hu => "Ungerska",
		fr => "Franska",
		fi => "Finska",
		it => "Italienska",
		docs => "Dokument",
		langsv => "Svenskspråkiga dokument",
		langde => "Tyskspråkiga dokument",
		langhu => "Ungerskspråkiga dokument",
		langfr => "Franskspråkiga dokument",
	);
}
elsif ($language eq "en")
{
	%strings = (
		hw => "Hardware/firmware related",
		ms => "Miscellaneous",
		gm => "Game related",
		pr => "Programming related",
		vc => "VIC 20",
		c2 => "C128",
		all => "All documents",
		isFilename => "File name",
		isSize => "Size",
		bytes => "bytes",
		isTitle => "Title",
		isLanguage => "Language",
		isAddedon => "Added on",
		isNew => "New!",
		none => "no sorting",
		file => "sorted by file name",
		name => "sorted by title",
		sv => "Swedish",
		en => "English",
		de => "German",
		hu => "Hungarian",
		fr => "French",
		fi => "Finnish",
		it => "Italian",
		docs => "Documents",
		langsv => "Documents in Swedish",
		langde => "Documents in German",
		langhu => "Documents in Hungarian",
		langfr => "Documents in French",
	);
}
elsif ($language eq "de")
{
	%strings = (
		hw => "Hardware-/Firmware-bezogen",
		ms => "Gemischtes",
		gm => "Spielebezogen",
		pr => "Programmierung",
		vc => "VC 20",
		c2 => "C128",
		all => "Alle Dokumente",
		isFilename => "Dateiname",
		isSize => "Größe",
		bytes => "Byte",
		isTitle => "Titel",
		isLanguage => "Sprache",
		isAddedon => "Hinzugefügt am",
		isNew => "Neu!",
		none => "unsortiert",
		file => "sortiert nach Dateinamen",
		name => "sortiert nach Titel",
		sv => "Schwedisch",
		en => "Englisch",
		de => "Deutsch",
		hu => "Ungarisch",
		fr => "Französisch",
		fi => "Finnisch",
		it => "Italienisch",
		docs => "Dokumente",
		langsv => "Schwedischsprachige",
		langde => "Deutschsprachige",
		langhu => "Ungarischsprachige",
		langfr => "Französischsprachige",
	);
}
elsif ($language eq	"fi")
{
	%strings = (
		hw => "Kovoon ja valmoon liittyvää",
		ms => "Sekalaista",
		gm => "Peleihin liittyvää",
		pr => "Ohjelmointiin liittyvää",
		vc => "VIC 20",
		c2 => "C128",
		all => "Kaikki dokumentit",
		isFilename => "Tiedostonimi",
		isSize => "Koko",
		bytes => "tavua",
		isTitle => "Otsikko",
		isLanguage => "Kieli",
		isAddedon => "Lisätty",
		isNew => "Uusi!",
		none => "lajittelematta",
		file => "tiedostonimen mukaan lajiteltuna",
		name => "otsikon mukaan lajiteltuna",
		sv => "ruotsi",
		en => "englanti",
		de => "saksa",
		hu => "unkari",
		fr => "ranska",
		fi => "suomeksi",
		it => "italia",
		docs => "Dokumentit",
		langsv => "Ruotsinkieliset dokumentit",
		langde => "Saksankieliset dokumentit",
		langhu => "Unkarinkieliset dokumentit",
		langfr => "Ranskankieliset dokumentit",
	);
}
elsif ($language eq "es")
{
	%strings = (
		hw => "Relacionado con Hardware/Firmware",
		ms => "Varios",
		gm => "Relacionado con juegos",
		pr => "Relacionado con programación",
		vc => "VIC 20",
		c2 => "C128",
		all => "Todos los documentos",
		isFilename => "Nombre de archivo",
		isSize => "Tamaño",
		bytes => "bytes",
		isTitle => "Título",
		isLanguage => "Idioma",
		isAddedon => "Agregado",
		isNew => "¡Nuevo!",
		none => "no ordenado",
		file => "ordenado por nombre de archivo",
		name => "ordenado por título",
		sv => "Sueco",
		en => "Inglés",
		de => "Alemán",
		hu => "Húngaro",
		fr => "Francés",
		fi => "Finlandés",
		es => "Español",
		it => "Italiano",
		docs => "Documentos",
		langsv => "Documentos en Sueco",
		langde => "Documentos en Alemán",
		langhu => "Documentos en Húngaro",
		langfr => "Documentos en Francés",
		langes => "Documentos en Español",
	);
}
elsif ($language eq "hu")
{
	%strings = (
		hw => "Hardware/firmware anyagok",
		ms => "Minden más",
		gm => "Játékokkal kapcsolatos anyagok",
		pr => "Programozással kapcsolatos anyagok",
		vc => "VIC 20",
		c2 => "C128",
		all => "Az összes dokumentum",
		isFilename => "Fájlnév",  
		isSize => "Méret",
		bytes => "bájt",
		isTitle => "Cím",
		isLanguage => "Nyelv",
		isAddedon => "Hozzáadás dátuma",
		isNew => "Új!",   
		none => "rendezés nélkül",
		file => "fájlnév alapján rendezve",
		name => "cím alapján rendezve",
		sv => "Svéd",
		en => "Angol",
		de => "Német",
		hu => "Magyar",
		fr => "Francia",
		fi => "Finn",
		it => "Olasz",
		docs => "dokumentumok",
		langsv => "dokumentumok svédül",
		langde => "dokumentumok németül",
		langhu => "dokumentumok magyarul",
		langfr => "dokumentumok franciául",
	);
}
else
{
	die;
}

@sortorders   = ("none", "file", "name");
@doclanguages = ("langsv", "langde", "langhu", "langfr");
@lists        = ("gm", "hw", "pr", "vc", "c2", "ms", @doclanguages, "all");

# Strings for documents in different languages
$strings{langsv} = "$strings{isLanguage}: $strings{sv}"
	unless $strings{langsv};
$strings{langde} = "$strings{isLanguage}: $strings{de}"
	unless $strings{langde};
$strings{langhu} = "$strings{isLanguage}: $strings{hu}"
	unless $strings{langhu};
$strings{langfr} = "$strings{isLanguage}: $strings{fr}"
	unless $strings{langfr};


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

foreach $sortorder (@sortorders)
{
	if ($sortorder ne $sorting)
	{
		print ' <link rel="alternate" type="text/html" hreflang="';
		print $language, qq'" href="etexts-$list-$sortorder" ';
		print 'title="', $strings{$sortorder}, qq'">\n';
	}	
}

&langlinks($language, "etexts-$list-$sorting.%s.html", %titles);

print <<"EOM";
 <link rel="search" href="search">
 <link rel="top" href="./">
 <meta name="author" content="Peter Krefting">
 <meta name="keywords" content="cbm, c64, documentation, international, project, project 64, commodore 64, eight-bit, svenska, deutsch, english, hungarian, magyar">
</head>

<body bgcolor="#ffffcc" text="#000000" link="#0000cc" alink="#880000"
      vlink="#000088">
EOM

# Test the lists and sort parameters for sanity
$ok = 0;
foreach (@lists)
{
	$ok = 1 if $_ eq $list;
}
$list = "all" unless $ok;

$ok = 0;
foreach (@sortorders)
{
	$ok = 1 if $_ eq $sorting;
}
$sorting = "none" unless $ok;

# Select date from which documents are flagged as new
@newsince = localtime(time - (30 * 24 * 60 * 60));
$newsince = sprintf "%04d%02d%02d",
                    $newsince[5] + 1900, $newsince[4] + 1, $newsince[3];

# Select sort field
$sortfield = 2 if $sorting eq "file";
$sortfield = 3 if $sorting eq "name";
$sortfield ||= 1; # else

# Document body
print qq(<div align="center" class="left"><h1 align="center"><img src="../pics/idoccbm.gif" alt="" height=150 width=211></h1>\n);
print qq(<h2 align="center">$strings{$list}</h2>\n);
print qq(<p align="center"><strong>$strings{$sorting}</strong><br><small>[ \n);
$i = 0;
foreach $sortorder (@sortorders)
{
	if ($sortorder ne $sorting)
	{
		print "- \n" if $i;
		print qq(<a href="etexts-$list-$sortorder">$strings{$sortorder}</a>\n);
		$i ++;
	}	
}

print "]</small></p></div><hr noshade class=decorative>\n";

# Links to other lists

print "<ul>\n";

foreach $other (@lists)
{
	if ($other eq $list)
	{
		print qq( <li><strong>$strings{$other}</strong>\n);
	}
	else
	{
		print qq( <li><a href="etexts-$other-$sorting">$strings{$other}</a>\n);
	}
}
print "</ul>\n<hr noshade class=decorative>\n";

# Table

print "<h2 class=clear>$strings{docs}</h2>";
printelist($language,
           $paths{'datadir'} . '/etexts.list', $list, $sorting);

# Update time

#my @filedata = stat $filename{$key};
my $filetime = (stat $paths{'datadir'} . "/etexts.list")[9];
$update = strftime("%Y-%m-%d", localtime($filetime))
	if $dateformats{$language} eq "YMD";
$update = strftime("%m/%d/%Y", localtime($filetime))
	if $dateformats{$language} eq "MDY";
$update = strftime("%d.%m.%Y", localtime($filetime))
	if $dateformats{$language} eq "DMY";

print "<p>\n<small>$lastupdated{$language} $update</small>\n";


# Link back
page($language, $dateformats{$language}, "etexts-$list-$sorting",
     "backtohome.input");
  
# Trailer
print <<"EOM";
<hr noshade>
<a href="http://validator.w3.org/check?uri=http://cbm.6502.org/etexts-$list-$sorting.$language.html">
 <img src="../pics/vh401.gif" width=88 height=31 border=0
  alt="[HTML 4.01]"></a>

<a href="http://jigsaw.w3.org/css-validator/validator?uri=http://cbm.6502.org/idoc.css">
 <img src="../pics/vcss.gif" width=88 height=31 border=0 alt="[CSS 2]"></a>

</body>
</html>
EOM

# We're done!

sub printelist
{
	my ($lang, $filename, $list, $sorting) = @_;
	my (%sortkey, %filename, %title, %language, %date);

	my $sortfield;
	$sortfield = 1	if $sorting eq "none";
	$sortfield = 2	if $sorting eq "file";
	$sortfield = 3	if $sorting eq "name";

	open INPUT, $filename or die "Unable to open input: $!";

	my $langtable = 0;
	if (index($list, "lang") == 0)
	{
		$langtable = 1;
		$showlanguage = substr($list, 4, 2);
	}

	# Check date for "New!" mark
	my $newfrom = strftime("%Y%m%d", localtime(time - 30 * 24 * 60 * 60));

	# Save entries to a hash
	my $entries = 0;
	LINE: while (<INPUT>)
	{
		chomp;
		next LINE if /^#/;
		@data = split(/¤/, $_);
		next LINE unless $#data;

		# @data = (lista, etextnummer, filnamn, beskrivning, språk, datum)
		if ((!$langtable && ($data[0] eq $list || $list eq "all")) ||
		    ( $langtable && index($data[4], $showlanguage) >= 0))
		{
			my $sortkey = $data[$sortfield];
			$sortkey .= " $data[1]" while defined $sortkey{$sortkey};
			$sortkey{$sortkey}	= $data[1];	# sortfield => key
			$filename{$data[1]} = $data[2];
			$title{$data[1]}    = $data[3];
			$language{$data[1]} = $data[4];
			$date{$data[1]}     = $data[5];

			$entries ++;
		}
	}
	close INPUT;

	print "<table border=1>\n";
	print " <tr><th>#<th>$strings{isFilename}<th>$strings{isSize}".
	      "<th>$strings{isTitle}<th>$strings{isLanguage}".
	      "<th>$strings{isAddedon}\n";

	# Print the hash in a sorted fashion

	foreach $key (sort alphasort keys %sortkey)
	{
		$num = $sortkey{$key};
		my @filedata = stat '../html/docs/' . $filename{$num};
		my $filesize = 0;
		$filesize = $filedata[7] if $#filedata != -1;
		my $addedon;
		my $y = substr($date{$num}, 0, 4);
		my $m = substr($date{$num}, 4, 2);
		my $d = substr($date{$num}, 6, 2);
		if ($dateformats{$language} eq "YMD")
		{
			$addedon = sprintf("%s-%s-%s", $y, $m, $d);
		}
		elsif ($dateformats{$language} eq "DMY")
		{
			$addedon = sprintf("%d.%d.%d", $d, $m, $y);
		}
		elsif ($dateformats{$language} eq "MDY")
		{
			$addedon = sprintf("%d/%d/%d", $m, $d, $y);
		}

		my $languages = "";
		foreach (split(/\+/, $language{$num}))
		{
			$_ = "en" if $_ eq "uk" || $_ eq "us";
			if (defined $strings{$_})
			{
				$languages .= $strings{$_} . " ";
			}
			else
			{
				$languages .= $_ . " ";
			}
		}
		$languages =~ s/^([a-z])/\U$1/;

		my $newmark = $date{$num} ge $newfrom
		                ? "<em>" . $strings{"isNew"} . "</em>"
		                : "";
		printf " <tr><td>%d<td><a href=\"download/%s\">%s</a> ".
		       "<td align=\"right\">%d %s<td>%s<td>%s<td>%s %s\n",
		       $num,$filename{$num},$filename{$num},
		       $filesize,$strings{"bytes"},$title{$num},
		       $languages,$addedon,$newmark;
	}

	print "</table>\n";
}

sub alphasort
{
	my ($left, $right) = ($a, $b);

	$left =~ tr/ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÑÒÓÔÕÖØÙÚÛÜİàáâãäåæçèéêëìíîïñòóôõøùúûüıÿ/AAAAAAACEEEEIIIINOOOOOOUUUUYaaaaaaaceeeeiiiinooooouuuuyy/;
	$left =~ s/[^A-Za-z0-9]//g;

	$right =~ tr/ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÑÒÓÔÕÖØÙÚÛÜİàáâãäåæçèéêëìíîïñòóôõøùúûüıÿ/AAAAAAACEEEEIIIINOOOOOOUUUUYaaaaaaaceeeeiiiinooooouuuuyy/;
	$right =~ s/[^A-Za-z0-9]//g;

	return lc($left) cmp lc($right);
}

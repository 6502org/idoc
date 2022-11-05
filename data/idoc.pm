#!/usr/bin/perl

use FindBin qw($Bin);
use File::Basename;
$basepath = dirname($Bin);
$rootpath = dirname($basepath);

# Paths
%paths = (
    'cgidir'  => "$basepath/cgi",
    'datadir' => "$basepath/data",
    'docdir'  => "$basepath/docs",
    'htmldir' => "$rootpath/html",
    'srcdir'  => "$rootpath/sourcefiles",
);

# Date formats
%dateformats = (
	'sv' => 'YMD',
	'en' => 'YMD',
	'de' => 'DMY',
	'fi' => 'DMY',
	'es' => 'DMY',
	'hu' => 'YMD',
);

# Last updated strings
%lastupdated = (
	'sv' => 'Senast uppdaterad',
	'en' => 'Last updated on',
	'de' => 'Aktualisiert am',
	'fi' => 'Viimeksi päivitetty',
	'es' => 'Última actualización',
	'hu' => 'Utolsó frissítés:',
);

# Country names
%country = (
	'sv' => {	'se' => 'Sverige',
				'at' => 'Österrike',
				'hu' => 'Ungern',
				'fi' => 'Finland',
				'ch' => 'Schweiz',
				'de' => 'Tyskland',
				'no' => 'Norge',
				'es' => 'Spanien',
				'mx' => 'Mexico',
				'it' => 'Italien',
			},
	'en' => {	'se' => 'Sweden',
				'at' => 'Austria',
				'hu' => 'Hungary',
				'fi' => 'Finland',
				'ch' => 'Switzerland',
				'de' => 'Germany',
				'no' => 'Norway',
				'es' => 'Spain',
				'mx' => 'Mexico',
				'it' => 'Italy',
			},
	'de' => {	'se' => 'Schweden',
				'at' => 'Österreich',
				'hu' => 'Ungarn',
				'fi' => 'Finnland',
				'ch' => 'Schweiz',
				'de' => 'Deutschland',
				'no' => 'Norwegen',
				'es' => 'Spanien',
				'mx' => 'Mexico',
				'it' => 'Italien',
			},
	'fi' => {	'se' => 'Ruotsi',
				'at' => 'Itävalta',
				'hu' => 'Unkari',
				'fi' => 'Suomi',
				'ch' => 'Sveitsi',
				'de' => 'Saksa',
				'no' => 'Norja',
				'es' => 'Espanja',
				'mx' => 'Meksiko',
				'it' => 'Italia',
			},
	'es' => {	'se' => 'Suecia',
				'at' => 'Austria',
				'hu' => 'Hungría',
				'fi' => 'Finlandia',
				'ch' => 'Suiza',
				'de' => 'Alemania',
				'no' => 'Noruega',
				'es' => 'España',
				'mx' => 'México',
				'it' => 'Italia',
			},
	'hu' => {	'se' => 'Svédország',
				'at' => 'Ausztria',  
				'hu' => 'Magyarország',
				'fi' => 'Finnország',  
				'ch' => 'Svájc',
				'de' => 'Németország',
				'no' => 'Norvégia',   
				'es' => 'Spanyolország',
				'mx' => 'Mexikó',
				'it' => 'Olaszország',
			},
);

# Language names
%language = (
	'sv' => 'svenska',
	'en' => 'English',
	'de' => 'Deutsch',
	'fi' => 'suomeksi',
	'es' => 'Español',
	'hu' => 'Magyar',
);

1;

sub page
{
	my ($lang,  $dateformat, $me, $filename) = @_;
	my ($llang, $ltable, $data);


	open INPUT, $filename or die "Unable to open input: $!";
	LINE: while (<INPUT>)
	{
		next LINE if /^#/;
		($llang, $data) = split(/;/, $_, 2);
		next LINE if not $data;

		# Shown?
		if (($llang  eq $lang  || $llang  eq 'all'))
		{
			print $data;
		}

		# Link?
		if ($llang eq 'link3')
		{
			printf "$data\n", $me;
		}

		# Date of file
		if ($llang eq 'filedate')
		{
			chomp $data;
			filedate($data, $dateformat);
		}
	}
	close INPUT;
}

sub filedate
{
	my ($filename, $dateformat) = @_;

	if (-r $filename and $age = (stat $filename)[9])
	{
		@time = localtime($age);
		printf "%02d.%02d.%d", $time[3], $time[4] + 1, $time[5] + 1900
			if $dateformat eq "DMY";
		printf "%02d/%02d/%d", $time[4] + 1, $time[3], $time[5] + 1900
			if $dateformat eq "MDY";
		printf "%d-%02d-%02d", $time[5] + 1900, $time[4] + 1, $time[3]
			if $dateformat eq "YMD";
	}
}

sub printlist
{
	my ($lang, $filename) = @_;
	my ($skew, @header, @titles, @data, $entries);

	open INPUT, $filename or die "Unable to open input: $!";

	# Grab titles
	TITLE: while (<INPUT>)
	{
		chomp;
		@header = split(/¤/, $_);
		if (/^#/ && $header[1] eq $lang)
		{
			@header = @header[2 .. $#header];
			last TITLE;
		}
		elsif (/^[^#]/)
		{
			last TITLE;
		}
	}

	die sprintf("No titles were found in %s", $filename) unless @header;

	print "<table border=1>\n<tr>";

	# Check if we have a flag specification in the array, and print the
	# titles at the same time if in tabular mode
	my $i = 0;
	my $isflag = -1;
	foreach (@header)
	{
		if ($_ eq "FLAG")
		{
			$isflag = $i;
		}
		else
		{
			print "<th>", $_;
		}
		$titles[$i ++] = $_;
	}
	print "\n";

	@header = ();

	$entries = 0;
	LINE: while (<INPUT>)
	{
		chomp;
		next LINE if /^#/;
		@data = split(/¤/, $_);
		next LINE unless $#data;

		print "\n<tr>";

		$i = 0;
		$nf = $#data;
		FIELD: foreach (@data)
		{
			print "<td>";

			if ($i + 1 == $isflag)
			{
#				if ($data[$i+1] ne "mx")
#				{
					print qq(<img src="flags/$data[$i+1]_lo.gif" );
					print qq(alt="" width=23 height=15> );
#				}

				if ($country{$lang}{$data[$i+1]})
				{
					print "$country{$lang}{$data[$i+1]}";
				}
				else
				{
					print $_;
				}

				last FIELD;
			}
			else
			{
				print $_;
			}

			$i ++;
		}
		$entries ++;
	}
	close INPUT;

	print "\n</table>\n";
}

sub langlinks(&&\%)
{
	my ($thislanguage, $thispage, %titles) = @_;
	foreach $otherlanguage (keys %titles)
	{
		if ($otherlanguage ne $thislanguage)
		{
			print    ' <link rel="alternate" type="text/html"';
			print  qq' hreflang="$otherlanguage" href="';
			printf $thispage, $otherlanguage;
			print  '" title="', $titles{$otherlanguage};
			print ' (', $language{$otherlanguage}, qq')">\n';
		}
	}
}

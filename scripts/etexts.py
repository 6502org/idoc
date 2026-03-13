#!/usr/bin/env python3
"""iDOC= etexts"""

import os
import re
import sys
import time

from idoc import (DELIM, ENCODING, dateformats, langlinks, lastupdated, out,
                  outln, page, paths, setup_output)

setup_output()

if len(sys.argv) < 4:
    sys.exit('Usage: %s [language] [list] [sorting]' % sys.argv[0])
lang = sys.argv[1]
lst = sys.argv[2]
sorting = sys.argv[3]

if lang not in dateformats:
    sys.exit('Illegal language')

titles = {
    'sv': 'iDOC=s dokument',
    'en': 'iDOC= documents',
    'de': 'iDOC=-Dokumente',
    'fi': 'iDOC=:n dokumentit',
    'es': 'Documentos iDOC=',
    'hu': 'iDOC= dokumentumok',
}

# Load strings for the selected language
all_strings = {
    'sv': {
        'hw': 'Maskinvaru-/fastprogramrelaterat',
        'ms': 'Blandat',
        'gm': 'Spelrelaterat',
        'pr': 'Programmeringsrelaterat',
        'vc': 'VIC 20',
        'c2': 'C128',
        'all': 'Samtliga dokument',
        'isFilename': 'Filnamn',
        'isSize': 'Storlek',
        'bytes': 'byte',
        'isTitle': 'Titel',
        'isLanguage': 'Spr\xe5k',
        'isAddedon': 'Tillagd den',
        'isNew': 'Ny!',
        'none': 'ingen sortering',
        'file': 'sorterat efter filnamn',
        'name': 'sorterat efter titel',
        'sv': 'Svenska',
        'en': 'Engelska',
        'de': 'Tyska',
        'hu': 'Ungerska',
        'fr': 'Franska',
        'fi': 'Finska',
        'it': 'Italienska',
        'docs': 'Dokument',
        'langsv': 'Svenskspr\xe5kiga dokument',
        'langde': 'Tyskspr\xe5kiga dokument',
        'langhu': 'Ungerskspr\xe5kiga dokument',
        'langfr': 'Franskspr\xe5kiga dokument',
    },
    'en': {
        'hw': 'Hardware/firmware related',
        'ms': 'Miscellaneous',
        'gm': 'Game related',
        'pr': 'Programming related',
        'vc': 'VIC 20',
        'c2': 'C128',
        'all': 'All documents',
        'isFilename': 'File name',
        'isSize': 'Size',
        'bytes': 'bytes',
        'isTitle': 'Title',
        'isLanguage': 'Language',
        'isAddedon': 'Added on',
        'isNew': 'New!',
        'none': 'no sorting',
        'file': 'sorted by file name',
        'name': 'sorted by title',
        'sv': 'Swedish',
        'en': 'English',
        'de': 'German',
        'hu': 'Hungarian',
        'fr': 'French',
        'fi': 'Finnish',
        'it': 'Italian',
        'docs': 'Documents',
        'langsv': 'Documents in Swedish',
        'langde': 'Documents in German',
        'langhu': 'Documents in Hungarian',
        'langfr': 'Documents in French',
    },
    'de': {
        'hw': 'Hardware-/Firmware-bezogen',
        'ms': 'Gemischtes',
        'gm': 'Spielebezogen',
        'pr': 'Programmierung',
        'vc': 'VC 20',
        'c2': 'C128',
        'all': 'Alle Dokumente',
        'isFilename': 'Dateiname',
        'isSize': 'Gr\xf6\xdfe',
        'bytes': 'Byte',
        'isTitle': 'Titel',
        'isLanguage': 'Sprache',
        'isAddedon': 'Hinzugef\xfcgt am',
        'isNew': 'Neu!',
        'none': 'unsortiert',
        'file': 'sortiert nach Dateinamen',
        'name': 'sortiert nach Titel',
        'sv': 'Schwedisch',
        'en': 'Englisch',
        'de': 'Deutsch',
        'hu': 'Ungarisch',
        'fr': 'Franz\xf6sisch',
        'fi': 'Finnisch',
        'it': 'Italienisch',
        'docs': 'Dokumente',
        'langsv': 'Schwedischsprachige',
        'langde': 'Deutschsprachige',
        'langhu': 'Ungarischsprachige',
        'langfr': 'Franz\xf6sischsprachige',
    },
    'fi': {
        'hw': 'Kovoon ja valmoon liittyv\xe4\xe4',
        'ms': 'Sekalaista',
        'gm': 'Peleihin liittyv\xe4\xe4',
        'pr': 'Ohjelmointiin liittyv\xe4\xe4',
        'vc': 'VIC 20',
        'c2': 'C128',
        'all': 'Kaikki dokumentit',
        'isFilename': 'Tiedostonimi',
        'isSize': 'Koko',
        'bytes': 'tavua',
        'isTitle': 'Otsikko',
        'isLanguage': 'Kieli',
        'isAddedon': 'Lis\xe4tty',
        'isNew': 'Uusi!',
        'none': 'lajittelematta',
        'file': 'tiedostonimen mukaan lajiteltuna',
        'name': 'otsikon mukaan lajiteltuna',
        'sv': 'ruotsi',
        'en': 'englanti',
        'de': 'saksa',
        'hu': 'unkari',
        'fr': 'ranska',
        'fi': 'suomeksi',
        'it': 'italia',
        'docs': 'Dokumentit',
        'langsv': 'Ruotsinkieliset dokumentit',
        'langde': 'Saksankieliset dokumentit',
        'langhu': 'Unkarinkieliset dokumentit',
        'langfr': 'Ranskankieliset dokumentit',
    },
    'es': {
        'hw': 'Relacionado con Hardware/Firmware',
        'ms': 'Varios',
        'gm': 'Relacionado con juegos',
        'pr': 'Relacionado con programaci\xf3n',
        'vc': 'VIC 20',
        'c2': 'C128',
        'all': 'Todos los documentos',
        'isFilename': 'Nombre de archivo',
        'isSize': 'Tama\xf1o',
        'bytes': 'bytes',
        'isTitle': 'T\xedtulo',
        'isLanguage': 'Idioma',
        'isAddedon': 'Agregado',
        'isNew': '\xa1Nuevo!',
        'none': 'no ordenado',
        'file': 'ordenado por nombre de archivo',
        'name': 'ordenado por t\xedtulo',
        'sv': 'Sueco',
        'en': 'Ingl\xe9s',
        'de': 'Alem\xe1n',
        'hu': 'H\xfangaro',
        'fr': 'Franc\xe9s',
        'fi': 'Finland\xe9s',
        'es': 'Espa\xf1ol',
        'it': 'Italiano',
        'docs': 'Documentos',
        'langsv': 'Documentos en Sueco',
        'langde': 'Documentos en Alem\xe1n',
        'langhu': 'Documentos en H\xfangaro',
        'langfr': 'Documentos en Franc\xe9s',
        'langes': 'Documentos en Espa\xf1ol',
    },
    'hu': {
        'hw': 'Hardware/firmware anyagok',
        'ms': 'Minden m\xe1s',
        'gm': 'J\xe1t\xe9kokkal kapcsolatos anyagok',
        'pr': 'Programoz\xe1ssal kapcsolatos anyagok',
        'vc': 'VIC 20',
        'c2': 'C128',
        'all': 'Az \xf6sszes dokumentum',
        'isFilename': 'F\xe1jln\xe9v',
        'isSize': 'M\xe9ret',
        'bytes': 'b\xe1jt',
        'isTitle': 'C\xedm',
        'isLanguage': 'Nyelv',
        'isAddedon': 'Hozz\xe1ad\xe1s d\xe1tuma',
        'isNew': '\xdaj!',
        'none': 'rendez\xe9s n\xe9lk\xfcl',
        'file': 'f\xe1jln\xe9v alapj\xe1n rendezve',
        'name': 'c\xedm alapj\xe1n rendezve',
        'sv': 'Sv\xe9d',
        'en': 'Angol',
        'de': 'N\xe9met',
        'hu': 'Magyar',
        'fr': 'Francia',
        'fi': 'Finn',
        'it': 'Olasz',
        'docs': 'dokumentumok',
        'langsv': 'dokumentumok sv\xe9d\xfcl',
        'langde': 'dokumentumok n\xe9met\xfcl',
        'langhu': 'dokumentumok magyarul',
        'langfr': 'dokumentumok franci\xe1ul',
    },
}

strings = all_strings[lang]

sortorders = ['none', 'file', 'name']
doclanguages = ['langsv', 'langde', 'langhu', 'langfr']
lists = ['gm', 'hw', 'pr', 'vc', 'c2', 'ms'] + doclanguages + ['all']

# Strings for documents in different languages
for lk in ('langsv', 'langde', 'langhu', 'langfr'):
    if lk not in strings:
        lang_code = lk[4:]  # e.g. 'sv' from 'langsv'
        strings[lk] = '%s: %s' % (strings['isLanguage'], strings[lang_code])

# Charset identifier
if lang == 'hu':
    meta = '<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-2">'
else:
    meta = '<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1">'

# Print page
out("""\
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="%s" dir="ltr">
<head>
 %s
 <title>%s</title>
 <link rev="made" href="m&#65;ilto:peter&#64;softwolves.pp&#46;se">
 <link rel="stylesheet" type="text/css" href="idoc.css">
""" % (lang, meta, titles[lang]))

for sortorder in sortorders:
    if sortorder != sorting:
        out(' <link rel="alternate" type="text/html" hreflang="')
        out(lang)
        out('" href="etexts-%s-%s.%s.html" ' % (lst, sortorder, lang))
        outln('title="%s">' % strings[sortorder])

langlinks(lang, 'etexts-%s-%s.%%s.html' % (lst, sorting), titles)

out("""\
 <link rel="top" href="./">
 <meta name="author" content="Peter Krefting">
 <meta name="keywords" content="cbm, c64, documentation, international, project, project 64, commodore 64, eight-bit, svenska, deutsch, english, hungarian, magyar">
</head>

<body bgcolor="#ffffcc" text="#000000" link="#0000cc" alink="#880000"
      vlink="#000088">
""")

# Validate list and sort parameters
if lst not in lists:
    lst = 'all'
if sorting not in sortorders:
    sorting = 'none'

# Select date from which documents are flagged as new
newsince = time.localtime(time.time() - (30 * 24 * 60 * 60))
newsince_str = '%04d%02d%02d' % (newsince.tm_year, newsince.tm_mon, newsince.tm_mday)

# Select sort field
if sorting == 'file':
    sortfield = 2
elif sorting == 'name':
    sortfield = 3
else:
    sortfield = 1

# Document body
out('<div align="center" class="left"><h1 align="center">'
    '<img src="pics/idoccbm.gif" alt="" height=150 width=211></h1>\n')
outln('<h2 align="center">%s</h2>' % strings[lst])
out('<p align="center"><strong>%s</strong><br><small>[ \n' % strings[sorting])
i = 0
for sortorder in sortorders:
    if sortorder != sorting:
        if i:
            outln('- ')
        outln('<a href="etexts-%s-%s.%s.html">%s</a>'
              % (lst, sortorder, lang, strings[sortorder]))
        i += 1

outln(']</small></p></div><hr noshade class=decorative>')

# Links to other lists
outln('<ul>')
for other in lists:
    if other == lst:
        outln(' <li><strong>%s</strong>' % strings[other])
    else:
        outln(' <li><a href="etexts-%s-%s.%s.html">%s</a>'
              % (other, sorting, lang, strings[other]))
outln('</ul>\n<hr noshade class=decorative>')


# Alpha sort helper: strip accents and non-alphanumeric chars
def _sort_key(s):
    # Transliterate accented chars to ASCII equivalents
    _xlat = str.maketrans(
        '\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf'
        '\xd1\xd2\xd3\xd4\xd5\xd6\xd8\xd9\xda\xdb\xdc\xdd'
        '\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef'
        '\xf1\xf2\xf3\xf4\xf5\xf8\xf9\xfa\xfb\xfc\xfd\xff',
        'AAAAAAACEEEEIIIINOOOOOOUUUUYaaaaaaaceeeeiiiinooooouuuuyy'
    )
    t = s.translate(_xlat)
    t = re.sub(r'[^A-Za-z0-9]', '', t)
    return t.lower()


def printelist(lang_arg, filename, lst_arg, sorting_arg):
    if sorting_arg == 'file':
        sf = 2
    elif sorting_arg == 'name':
        sf = 3
    else:
        sf = 1

    langtable = False
    showlanguage = ''
    if lst_arg.startswith('lang'):
        langtable = True
        showlanguage = lst_arg[4:6]

    # Check date for "New!" mark
    newfrom = time.strftime('%Y%m%d', time.localtime(time.time() - 30 * 24 * 60 * 60))

    # Read entries into dicts keyed by etext number
    sortkeys = {}   # sortkey -> etext number
    filenames = {}  # etext number -> filename
    etitles = {}    # etext number -> title
    languages = {}  # etext number -> language string
    dates = {}      # etext number -> date string

    with open(filename, encoding=ENCODING) as f:
        for line in f:
            line = line.rstrip('\n')
            if line.startswith('#'):
                continue
            data = line.split(DELIM)
            if len(data) <= 1:
                continue

            # data = (list, etext_number, filename, description, language, date)
            if (not langtable and (data[0] == lst_arg or lst_arg == 'all')) or \
               (langtable and showlanguage in data[4]):
                sk = data[sf]
                while sk in sortkeys:
                    sk += ' ' + data[1]
                sortkeys[sk] = data[1]
                filenames[data[1]] = data[2]
                etitles[data[1]] = data[3]
                languages[data[1]] = data[4]
                dates[data[1]] = data[5]

    outln('<table border=1>')
    outln(' <tr><th>#<th>%s<th>%s<th>%s<th>%s<th>%s'
          % (strings['isFilename'], strings['isSize'],
             strings['isTitle'], strings['isLanguage'],
             strings['isAddedon']))

    for key in sorted(sortkeys.keys(), key=_sort_key):
        num = sortkeys[key]
        filepath = '../build/download/' + filenames[num]
        try:
            filesize = os.path.getsize(filepath)
        except OSError:
            filesize = 0

        # Format date
        y = dates[num][0:4]
        m = dates[num][4:6]
        d = dates[num][6:8]
        if dateformats[lang_arg] == 'YMD':
            addedon = '%s-%s-%s' % (y, m, d)
        elif dateformats[lang_arg] == 'DMY':
            addedon = '%d.%d.%d' % (int(d), int(m), int(y))
        elif dateformats[lang_arg] == 'MDY':
            addedon = '%d/%d/%d' % (int(m), int(d), int(y))
        else:
            addedon = ''

        # Build language display string
        lang_parts = []
        for lc in languages[num].split('+'):
            if lc in ('uk', 'us'):
                lc = 'en'
            if lc in strings:
                lang_parts.append(strings[lc])
            else:
                lang_parts.append(lc)
        lang_display = ''.join(s + ' ' for s in lang_parts)
        # Capitalize first character if lowercase
        if lang_display and lang_display[0].islower():
            lang_display = lang_display[0].upper() + lang_display[1:]

        newmark = ''
        if dates[num] >= newfrom:
            newmark = '<em>%s</em>' % strings['isNew']

        outln(' <tr><td>%d<td><a href="download/%s">%s</a> '
              '<td align="right">%d %s<td>%s<td>%s<td>%s %s'
              % (int(num), filenames[num], filenames[num],
                 filesize, strings['bytes'], etitles[num],
                 lang_display, addedon, newmark))

    outln('</table>')


# Table
out('<h2 class=clear>%s</h2>' % strings['docs'])
printelist(lang, paths['datadir'] + '/etexts.list', lst, sorting)

# Update time
filetime = os.path.getmtime(paths['datadir'] + '/etexts.list')
if dateformats[lang] == 'YMD':
    update = time.strftime('%Y-%m-%d', time.localtime(filetime))
elif dateformats[lang] == 'MDY':
    update = time.strftime('%m/%d/%Y', time.localtime(filetime))
elif dateformats[lang] == 'DMY':
    update = time.strftime('%d.%m.%Y', time.localtime(filetime))
else:
    update = ''

outln('<p>\n<!--<small>%s %s</small>-->' % (lastupdated[lang], update))

# Link back
page(lang, dateformats[lang], 'etexts-%s-%s' % (lst, sorting),
     'backtohome.input')

# Trailer
out("""\
<hr noshade>
<img src="pics/vh401.gif" width=88 height=31 border=0 alt="[HTML 4.01]">
<img src="pics/vcss.gif" width=88 height=31 border=0 alt="[CSS 2]">

</body>
</html>
""")

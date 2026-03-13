import os
import sys
import time

# All I/O uses latin-1 to pass through both ISO-8859-1 and
# ISO-8859-2 content without conversion.
ENCODING = 'latin-1'

# Delimiter used in .list files (0xA4, currency sign in ISO-8859-1)
DELIM = '\xa4'

_scriptdir = os.path.dirname(os.path.abspath(__file__))
_basepath = os.path.dirname(_scriptdir)
_rootpath = os.path.dirname(_basepath)

paths = {
    'cgidir':  os.path.join(_basepath, 'cgi'),
    'datadir': os.path.join(_basepath, 'data'),
    'docdir':  os.path.join(_basepath, 'docs'),
    'htmldir': os.path.join(_rootpath, 'html'),
    'srcdir':  os.path.join(_rootpath, 'sourcefiles'),
}

dateformats = {
    'sv': 'YMD',
    'en': 'YMD',
    'de': 'DMY',
    'fi': 'DMY',
    'es': 'DMY',
    'hu': 'YMD',
}

lastupdated = {
    'sv': 'Senast uppdaterad',
    'en': 'Last updated on',
    'de': 'Aktualisiert am',
    'fi': 'Viimeksi p\xe4ivitetty',
    'es': '\xdaltima actualizaci\xf3n',
    'hu': 'Utols\xf3 friss\xedt\xe9s:',
}

country = {
    'sv': {
        'se': 'Sverige',    'at': '\xd6sterrike', 'hu': 'Ungern',
        'fi': 'Finland',    'ch': 'Schweiz',      'de': 'Tyskland',
        'no': 'Norge',      'es': 'Spanien',      'mx': 'Mexico',
        'it': 'Italien',
    },
    'en': {
        'se': 'Sweden',     'at': 'Austria',      'hu': 'Hungary',
        'fi': 'Finland',    'ch': 'Switzerland',   'de': 'Germany',
        'no': 'Norway',     'es': 'Spain',         'mx': 'Mexico',
        'it': 'Italy',
    },
    'de': {
        'se': 'Schweden',   'at': '\xd6sterreich', 'hu': 'Ungarn',
        'fi': 'Finnland',   'ch': 'Schweiz',       'de': 'Deutschland',
        'no': 'Norwegen',   'es': 'Spanien',       'mx': 'Mexico',
        'it': 'Italien',
    },
    'fi': {
        'se': 'Ruotsi',     'at': 'It\xe4valta',  'hu': 'Unkari',
        'fi': 'Suomi',      'ch': 'Sveitsi',       'de': 'Saksa',
        'no': 'Norja',      'es': 'Espanja',       'mx': 'Meksiko',
        'it': 'Italia',
    },
    'es': {
        'se': 'Suecia',     'at': 'Austria',       'hu': 'Hungr\xeda',
        'fi': 'Finlandia',  'ch': 'Suiza',         'de': 'Alemania',
        'no': 'Noruega',    'es': 'Espa\xf1a',    'mx': 'M\xe9xico',
        'it': 'Italia',
    },
    'hu': {
        'se': 'Sv\xe9dorsz\xe1g',   'at': 'Ausztria',
        'hu': 'Magyarorsz\xe1g',    'fi': 'Finnorsz\xe1g',
        'ch': 'Sv\xe1jc',           'de': 'N\xe9metorsz\xe1g',
        'no': 'Norv\xe9gia',        'es': 'Spanyolorsz\xe1g',
        'mx': 'Mexik\xf3',          'it': 'Olaszorsz\xe1g',
    },
}

language = {
    'sv': 'svenska',
    'en': 'English',
    'de': 'Deutsch',
    'fi': 'suomeksi',
    'es': 'Espa\xf1ol',
    'hu': 'Magyar',
}


def setup_output():
    """Reconfigure stdout for latin-1 output."""
    sys.stdout.reconfigure(encoding=ENCODING, errors='replace')


def out(s=''):
    """Print a string without a trailing newline."""
    sys.stdout.write(s)


def outln(s=''):
    """Print a string with a trailing newline."""
    sys.stdout.write(s + '\n')


def page(lang, dateformat, me, filename):
    filepath = os.path.join(paths['datadir'], filename)
    with open(filepath, encoding=ENCODING) as f:
        for line in f:
            if line.startswith('#'):
                continue
            parts = line.split(';', 1)
            if len(parts) < 2:
                continue
            llang, data = parts
            if llang == lang or llang == 'all':
                out(data)
            if llang == 'link3':
                outln(data.replace('%s', me, 1))
            if llang == 'filedate':
                filedate(data.rstrip('\n'), dateformat)


def filedate(filename, dateformat):
    try:
        mtime = os.path.getmtime(filename)
    except OSError:
        return
    t = time.localtime(mtime)
    if dateformat == 'DMY':
        out('%02d.%02d.%d' % (t.tm_mday, t.tm_mon, t.tm_year))
    elif dateformat == 'MDY':
        out('%02d/%02d/%d' % (t.tm_mon, t.tm_mday, t.tm_year))
    elif dateformat == 'YMD':
        out('%d-%02d-%02d' % (t.tm_year, t.tm_mon, t.tm_mday))


def printlist(lang, filename):
    with open(filename, encoding=ENCODING) as f:
        header = []
        for line in f:
            line = line.rstrip('\n')
            cols = line.split(DELIM)
            if line.startswith('#') and len(cols) > 1 and cols[1] == lang:
                header = cols[2:]
                break
            elif not line.startswith('#'):
                header = cols
                break

        if not header:
            raise SystemExit('No titles were found in %s' % filename)

        out('<table border=1>\n<tr>')

        titles = []
        isflag = -1
        for i, h in enumerate(header):
            if h == 'FLAG':
                isflag = i
            else:
                out('<th>' + h)
            titles.append(h)
        outln()

        entries = 0
        for line in f:
            line = line.rstrip('\n')
            if line.startswith('#'):
                continue
            data = line.split(DELIM)
            if len(data) <= 1:
                continue

            out('\n<tr>')
            for i, field in enumerate(data):
                out('<td>')
                if i + 1 == isflag:
                    out('<img src="flags/%s_lo.gif" '
                        'alt="" width=23 height=15> ' % data[i + 1])
                    cname = country.get(lang, {}).get(data[i + 1])
                    if cname:
                        out(cname)
                    else:
                        out(field)
                    break
                else:
                    out(field)
            entries += 1

    outln('\n</table>')


def langlinks(thislanguage, thispage, titles):
    for otherlanguage in titles:
        if otherlanguage != thislanguage:
            out(' <link rel="alternate" type="text/html"')
            out(' hreflang="%s" href="' % otherlanguage)
            out(thispage % otherlanguage)
            out('" title="%s' % titles[otherlanguage])
            outln(' (%s)">' % language[otherlanguage])

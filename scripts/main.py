#!/usr/bin/env python3
"""iDOC= main page"""

import sys

from idoc import (dateformats, filedate, langlinks, lastupdated, out, outln,
                  page, paths, printlist, setup_output)

setup_output()

if len(sys.argv) < 2:
    sys.exit('Usage: %s [language]' % sys.argv[0])
lang = sys.argv[1]

if lang not in dateformats:
    sys.exit('Illegal language: %s' % lang)

titles = {
    'sv': 'iDOC=', 'en': 'iDOC=', 'de': 'iDOC=',
    'fi': 'iDOC=', 'es': 'iDOC=', 'hu': 'iDOC=',
}

if lang == 'hu':
    meta = '<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-2">'
else:
    meta = '<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1">'

out("""\
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="%s" dir="ltr">
<head>
 %s
 <title>iDOC=</title>
 <link rev="made" href="m&#65;ilto:peter&#64;softwolves.pp&#46;se">
 <link rel="stylesheet" type="text/css" href="idoc.css">
""" % (lang, meta))

langlinks(lang, 'index.%s.html', titles)

out("""\
 <link rel="top" href="./">
 <meta name="author" content="Peter Krefting">
 <meta name="keywords" content="cbm, c64, documentation, international, project, project 64, commodore 64, eight-bit, svenska, deutsch, english, hungarian, magyar">
</head>

<body bgcolor="#ffffcc" text="#000000" link="#0000cc" alink="#880000"
      vlink="#000088">

""")

# Document body
page(lang, dateformats[lang], 'index', 'main.input')

# Tables
# Requests
requesttitles = {
    'sv': 'Efterfr\xe5gade dokument',
    'en': 'Requested documents',
    'de': 'Gesuchte Dokumente',
    'fi': 'Kaivatuimmat dokumentit',
    'es': 'Documentos solicitados',
    'hu': 'Keresett dokumentumok',
}

outln('<h3 class=main>%s</h3>' % requesttitles[lang])
out('<!--<small>%s' % lastupdated[lang])
filedate(paths['datadir'] + '/requests.list', dateformats[lang])
outln('</small>--><p>')

printlist(lang, paths['datadir'] + '/requests.list')

# Current projects
currentprojects = {
    'sv': 'P\xe5g\xe5ende projekt',
    'en': 'Current projects',
    'de': 'Projekte, an denen gerade gearbeitet wird',
    'fi': 'Keskener\xe4iset hankkeet',
    'es': 'Proyectos actuales',
    'hu': 'Folyamatban l\xe9v\xf5 projektek',
}

outln('<h3 class=main>%s</h3>' % currentprojects[lang])
out('<!--<small>%s ' % lastupdated[lang])
filedate(paths['datadir'] + '/currentprojects.list', dateformats[lang])
outln('</small>--><p>')

printlist(lang, paths['datadir'] + '/currentprojects.list')

# Document footer
page(lang, dateformats[lang], 'index', 'main-footer.input')

# Trailer
out("""\
<hr noshade class=decorative>
<a href="https://www.softwolves.pp.se/cbm/">Softwolves' CBM page</a>
<hr noshade>
<img src="pics/vh401.gif" width=88 height=31 border=0 alt="[HTML 4.01]">
<img src="pics/vcss.gif" width=88 height=31 border=0 alt="[CSS 2]">
""")

# Anybrowser campaign
anybrowser = {
    'en': '<a href="http://www.anybrowser.org/campaign/"><img src="pics/anybrowser3.gif" alt="Best viewed with ANY browser."',
    'sv': '<a href="http://www.anybrowser.org/campaign/anybrowser_swe.html"><img src="pics/anybr_sw.gif" alt="Visas b\xe4st med VALFRI v\xe4vl\xe4sare."',
    'de': '<a href="http://www.anybrowser.org/campaign/anybrowser_de.html"><img src="pics/allebr.gif" alt="Geeignet f\xfcr ALLE Brauser."',
    'fi': '<a href="http://www.anybrowser.org/campaign/"><img src="pics/anybrowser3.gif" alt="T\xe4m\xe4 sivu n\xe4kyy parhaiten MILL\xc4 TAHANSA selaimella."',
    'es': '<a href="http://www.anybrowser.org/campaign/"><img src="pics/anybrowser3.gif" alt="Se ve mejor con CUALQUIER navegador."',
    'hu': '<a href="http://www.anybrowser.org/campaign/"><img src="pics/anybrowser3.gif" alt="B\xe1rmilyen b\xf6ng\xe9sz\xf5vel j\xf3l olvashat\xf3."',
}

outln(anybrowser[lang] + ' width="88" height="31" border="0"></a>')

# Trailer, part 2
out("""
</body>
</html>
""")

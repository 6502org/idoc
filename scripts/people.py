#!/usr/bin/env python3
"""iDOC= people page"""

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
    'sv': 'Folket bakom iDOC=',
    'en': 'iDOC= people',
    'de': 'Die Leute hinter iDOC=',
    'fi': 'iDOC=:n tekij\xe4t',
    'es': 'La gente del iDOC=',
    'hu': 'Az iDOC= r\xe9sztvev\xf5i',
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
 <title>%s</title>
 <link rev="made" href="m&#65;ilto:peter&#64;softwolves.pp&#46;se">
 <link rel="stylesheet" type="text/css" href="idoc.css">
""" % (lang, meta, titles[lang]))

langlinks(lang, 'people.%s.html', titles)

out("""\
 <link rel="top" href="./">
 <meta name="author" content="Peter Krefting">
 <meta name="keywords" content="cbm, c64, documentation, international, project, project 64, commodore 64, eight-bit, svenska, deutsch, english, hungarian, magyar">
</head>

<body bgcolor="#ffffcc" text="#000000" link="#0000cc" alink="#880000"
      vlink="#000088">
""")

# Document body
page(lang, dateformats[lang], 'people', 'people.input')

# Table
printlist(lang, paths['datadir'] + '/people.list')

out('<p><!--<small>%s ' % lastupdated[lang])
filedate(paths['datadir'] + '/people.list', dateformats[lang])
outln('</small>--></p>')

# Link back
page(lang, dateformats[lang], 'people', 'backtohome.input')

# Trailer
out("""\
<hr noshade>
<img src="pics/vh401.gif" width=88 height=31 border=0 alt="[HTML 4.01]">
<img src="pics/vcss.gif" width=88 height=31 border=0 alt="[CSS 2]">

</body>
</html>
""")

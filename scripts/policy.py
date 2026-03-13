#!/usr/bin/env python3
"""iDOC= policy page"""

import sys

from idoc import (dateformats, langlinks, out, outln, page, setup_output)

setup_output()

if len(sys.argv) < 2:
    sys.exit('Usage: %s [language]' % sys.argv[0])
lang = sys.argv[1]

if lang not in dateformats:
    sys.exit('Illegal language: %s' % lang)

titles = {
    'sv': 'Riktlinjer f\xf6r iDOC=',
    'en': 'iDOC= policy',
    'de': 'Die iDOC= Richtlinien',
    'fi': 'iDOC=:n suuntaviivat',
    'es': 'Las politicas del iDOC=',
    'hu': 'Az iDOC= szab\xe1lyzata',
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

langlinks(lang, 'policy.%s.html', titles)

out("""\
 <link rel="top" href="./">
 <meta name="author" content="Peter Krefting">
 <meta name="keywords" content="cbm, c64, documentation, international, project, project 64, commodore 64, eight-bit, svenska, deutsch, english, hungarian, magyar">
</head>

<body bgcolor="#ffffcc" text="#000000" link="#0000cc" alink="#880000"
      vlink="#000088">

""")

# Document body
page(lang, dateformats[lang], 'policy', 'policy.input')

# Link back
page(lang, dateformats[lang], 'policy', 'backtohome.input')

# Trailer
out("""\
<hr noshade>
<img src="pics/vh401.gif" width=88 height=31 border=0 alt="[HTML 4.01]">
<img src="pics/vcss.gif" width=88 height=31 border=0 alt="[CSS 2]">

</body>
</html>
""")

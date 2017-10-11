#!/bin/sh
# $Id: lookat.cgi,v 1.2 2002/07/14 09:26:06 peter Exp $

PARAM="$1"
CHECK="${PARAM//\//:}"

cd /var/www/cbm.6502.org/html/docs

if [ "$1" = "" ]; then
	echo Content-type: text/html
	echo
	echo "<html><head><title>Error!</title></head>"
	echo "<body>The CGI script was called incorrectly</body></html>"
elif [ "$1" != "$CHECK" ]; then
	echo Content-type: text/html
	echo
	echo "<html><head><title>Error!</title></head>"
	echo "<body>The CGI script was called with an invalid parameter</body></html>"
elif [ ! -f "$1.zip" ]; then
	echo Content-type: text/html
	echo
	echo "<body>The requested file could not be found!</body></html>"
else
	# /home/peter/src/expires 31
	echo Content-type: text/plain
	echo
	unzip -qq -c "$1.zip"
fi

exit 0

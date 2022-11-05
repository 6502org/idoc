#!/bin/bash
# Update iDOC='s web pages
# © 1999-2003 Peter Krefting <peter@softwolves.pp.se>
# Update iDOC='s web pages
set -e

unset LANG LC_ALL

HERE=$(dirname $0)
cd "$HERE"

for language in sv en de fi es hu; do
  echo -n "${language}: "
  echo -n "index "
  ./main.pl ${language}  > ../html/index.${language}.html
  for page in people intro policy; do
    echo -n "${page} "
    ./${page}.pl ${language}  > ../html/${page}.${language}.html
  done
  echo
  echo -n "  etexts:"
  for table in gm hw pr vc c2 ms langsv langde langhu langfr all; do #28
    echo -n " ${table}"
    for sorting in none file name; do
      ./etexts.pl ${language} ${table} ${sorting}  > ../html/etexts-${table}-${sorting}.${language}.html
    done
  done
  echo
done

echo -n "copy: "
cp -v ../html/index.en.html ../html/index.html
cp -v ../html/alternative/index.en.html ../html/alternative/index.html

echo Done
exit 0

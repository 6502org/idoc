#!/bin/bash
# Update iDOC='s web pages
# © 1999-2003 Peter Krefting <peter@softwolves.pp.se>
# Update iDOC='s web pages
set -e

unset LANG LC_ALL

HERE=$(dirname $0)
cd "$HERE"

echo -n "clean: "
mkdir -p ../build/
rm -rfv ../build/*

echo -n "copy: "
cp -vR ../static/* ../build/

for language in sv en de fi es hu; do
  echo -n "${language}: "
  echo -n "index "
  ./main.pl ${language}  > ../build/index.${language}.html
  for page in people intro policy; do
    echo -n "${page} "
    ./${page}.pl ${language}  > ../build/${page}.${language}.html
  done
  echo
  echo -n "  etexts:"
  for table in gm hw pr vc c2 ms langsv langde langhu langfr all; do #28
    echo -n " ${table}"
    for sorting in none file name; do
      ./etexts.pl ${language} ${table} ${sorting}  > ../build/etexts-${table}-${sorting}.${language}.html
    done
  done
  echo
done

echo "copy: "
cp -v ../build/index.en.html ../build/index.html
cp -v ../build/alternative/index.en.html ../build/alternative/index.html

echo Done
exit 0

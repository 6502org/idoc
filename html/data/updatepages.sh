#!/bin/bash
# Update iDOC='s web pages
# © 1999-2003 Peter Krefting <peter@softwolves.pp.se>
# Update iDOC='s web pages

unset LANG LC_ALL

HERE=$(dirname $0)
cd "$HERE"

for language in sv en de fi es hu; do
  echo -n "${language}: "
  echo -n "index "
  ./main.pl ${language}  > ../index.${language}.html
  if [ $language = hu ]; then
    echo 'Content-Type: text/html;charset=iso-8859-2' > ../index.${language}.html.meta
  else
    echo 'Content-Type: text/html;charset=iso-8859-1' > ../index.${language}.html.meta
  fi
  for page in people intro policy; do
    echo -n "${page} "
    ./${page}.pl ${language}  > ../${page}.${language}.html
    if [ $language = hu ]; then
      echo 'Content-Type: text/html;charset=iso-8859-2' > ../${page}.${language}.html.meta
    else
      echo 'Content-Type: text/html;charset=iso-8859-1' > ../${page}.${language}.html.meta
    fi
  done
  echo
  echo -n "  etexts:"
  for table in gm hw pr vc c2 ms langsv langde langhu langfr all; do #28
    echo -n " ${table}"
    for sorting in none file name; do
      ./etexts.pl ${language} ${table} ${sorting}  > ../etexts-${table}-${sorting}.${language}.html
      if [ $language = hu ]; then
        echo 'Content-Type: text/html;charset=iso-8859-2' > ../etexts-${table}-${sorting}.${language}.html.meta
      else
        echo 'Content-Type: text/html;charset=iso-8859-1' > ../etexts-${table}-${sorting}.${language}.html.meta
      fi
    done
  done
  echo
done

echo -n "links: "
ln -sf index.en.html ../${version}/index.html
for page in people intro policy search; do
  ln -sf ${page}.en.html ../${version}/${page}.html
done
for table in gm hw pr vc c2 ms langsv langde langhu langfr all; do
  for sorting in none file name; do
    ln -sf etexts-${table}-${sorting}.en.html ../${version}/etexts-${table}-${sorting}.html
  done
done
echo

echo Done
exit 0

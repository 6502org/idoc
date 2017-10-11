#!/bin/bash
# Uppdatera iDOC=s webbsidor
# © 1999-2003 Peter Karlsson <peter@softwolves.pp.se>
# Uppdtera iDOC=s webbsidor
# $Id: updatepages.sh,v 1.18 2003/02/01 21:12:04 peter Exp $

unset LANG LC_ALL

# cd /home/peter/public_html/idoc/data

for language in sv en de fi es hu; do
  echo -n "${language}: "
  echo -n "index "
  ./main.pl ${language}  > ../index.${language}.shtml
  if [ $language = hu ]; then
    echo 'Content-Type: text/html;charset=iso-8859-2' > ../index.${language}.shtml.meta
  else
    echo 'Content-Type: text/html;charset=iso-8859-1' > ../index.${language}.shtml.meta
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

echo -n "länkar: "
ln -sf index.en.shtml ../${version}/index.shtml
for page in people intro policy search; do
  ln -sf ${page}.en.html ../${version}/${page}.html
done
for table in gm hw pr vc c2 ms langsv langde langhu langfr all; do
  for sorting in none file name; do
    ln -sf etexts-${table}-${sorting}.en.html ../${version}/etexts-${table}-${sorting}.html
  done
done
echo

echo Klar
exit 0

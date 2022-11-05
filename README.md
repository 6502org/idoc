# iDOC=

iDOC= is a project [initiated by Peter Krefting](https://www.softwolves.pp.se/cbm/artiklar/oblivion.en.html) that collects documentation (primarily text files) related to Commodore computers in various languages.  Before March 1999, it was known an International Project 64.

## Build

The iDOC= website is fully static and is built from this repository.  Building iDOC= requires a Unix-like machine (e.g. Linux, macOS) with GNU Make and Perl 5.

On Ubuntu 18.04 LTS, this will install the requirements:

```text
$ apt install build-essential perl
```

Run `make` in the git checkout to build:

```text
$ git clone https://github.com/6502org/idoc.git
Cloning into 'idoc'...
remote: Enumerating objects: 2064, done.
remote: Counting objects: 100% (868/868), done.
remote: Compressing objects: 100% (508/508), done.
remote: Total 2064 (delta 539), reused 500 (delta 307), pack-reused 1196
Receiving objects: 100% (2064/2064), 131.59 MiB | 10.09 MiB/s, done.
Resolving deltas: 100% (769/769), done.

$ cd idoc 

$ make 
...
sv: index people intro policy 
  etexts: gm hw pr vc c2 ms langsv langde langhu langfr all
en: index people intro policy 
  etexts: gm hw pr vc c2 ms langsv langde langhu langfr all
de: index people intro policy 
  etexts: gm hw pr vc c2 ms langsv langde langhu langfr all
fi: index people intro policy 
  etexts: gm hw pr vc c2 ms langsv langde langhu langfr all
es: index people intro policy 
  etexts: gm hw pr vc c2 ms langsv langde langhu langfr all
hu: index people intro policy 
  etexts: gm hw pr vc c2 ms langsv langde langhu langfr all
copy: 
../build/index.en.html -> ../build/index.html
../build/alternative/index.en.html -> ../build/alternative/index.html
Done
```

The `build/` directory will contain the complete iDOC= website.

If the system has Python 3 installed, iDOC= can be served locally with:


```text
$ python3 -m http.server --directory build/ --bind 127.0.0.1 8000
Serving HTTP on 127.0.0.1 port 8000 (http://127.0.0.1:8000/) ...
```

Open a browser to http://127.0.0.1:8000/ to view it.

## Repository Layout 

 - `build/` - contains the complete iDOC= website after a successful build.  This directory is what would be served by a webserver, e.g. as an Apache public directory.  
 - `data/` - data and scripts used to build the website.  The `build/` directory will contain of the output of these scripts combined with the contents of `static/`.
 - `static/`- files used in the build that never change.  This includes the documents that are downloaded from the website (`static/docs/`). 
 - `sourcefiles` - materials that were once used to create the documents in `static/docs/`.  The files in this directory are not used during the build.


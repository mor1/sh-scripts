Mort's (Ba)SH Scripts
=====================


envfns
------

Environment manipulation shell functions.

* denv: remove all occurrences of value from environment variable 
* aenv: add value to start of given environment variable
* enva: add value to end of given environment variable
* cenv: clean environment variable, removing repeats
* ppkl: pretty-print a Python pickle file
* ctime: pretty-print time given as seconds from Unix epoch
* ps1txt set primary prompt for a console
* ps1xt: set primary prompt for an XTerm


filefns
-------

Filesystem related shell functions.

* loc: heuristic estimation of lines-of-code (LoCs)
* mnm: multi-file `nm` with grep for $1
* rfc: fetch and disply/print an IETF RFC
* rgrep: recursive grep
* symt: test existence of dangling symlinks
* trawl: recursive grep through selected files


linux-install
-------------

Wraps up the usual commands to install a newly built kernel on my
system.  Probably slightly bit-rotted now.


numfns
------

Some simple number base conversion shell functions.  Because I can.

* d2b/b2d: decimal-binary conversion
* d2o/o2d: decimal-octal conversion
* d2h/h2d: decimal-hex conversion
* dswp: print decimal number as byte-swapped
* prip: print IP address given as network-endian hex as dotted quad 


pdfmerge
--------

Merge a set of PDFs into a single PDF.  Relies on PDFTeX (from TeTeX)
and the LaTeX package `pdfpages`.

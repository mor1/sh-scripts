#!/usr/bin/env bash 
#
# Wrapper for GS to merge PDF files.
#
# Copyright (C) 2010 Richard Mortier <mort@cantab.net>.  All Rights
# Reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
# USA.

tmpf=/tmp/pdfmerge.$$.tex

usage () {
  printf "Usage: %s -o <outfile> infiles ...\n" "$(basename ${0})"
  exit 2
  }

outf=
while getopts 'o:?h' OPT ; do
  case $OPT in
    o ) outf="$OPTARG" ;;
    h ) usage ;;
    ? ) usage ;;
  esac
done
shift $(($OPTIND - 1))

if [ "$outf" = "" ] ; then usage ; fi

printf "Merging files [ %s ] into %s\n" "$*" "$outf"

rm -f $tmpf
echo "\documentclass[a4]{article}" >> $tmpf
echo "\usepackage{pdfpages}" >> $tmpf
echo "\begin{document}" >> $tmpf
while [ "$1" != "" ] ; do
  echo "\includepdf[pages=-]{$1}" >> $tmpf
  shift 1
done
echo "\end{document}" >> $tmpf

pdflatex $tmpf
tmpb=$(basename $tmpf)
mv ${tmpb%.tex}.pdf $outf
rm -f $tmpf ${tmpb%.tex}.{aux,log}

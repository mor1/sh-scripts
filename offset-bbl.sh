#!/usr/bin/env bash
#
# Simple GAWK script to offset entries in a BibTeX `.bbl` file. For use when
# (e.g.) concatenating multiple bibs and you want to number consecutively from
# 1.
#
# Copyright (C) 2014 Richard Mortier <mort@cantab.net>. All Rights Reserved.
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License version 2 as published by the Free
# Software Foundation
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place - Suite 330, Boston, MA 02111-1307, USA.

set -ex

OFFSET=$1
FILE=$2

gawk -vOFFSET=$OFFSET -F "([[]|[]])" \
    '{ if ($2) printf ("%s[%d]%s\n",$1, $2+OFFSET,$3); else print $0 }' \
    $FILE > $FILE.offset

mv $FILE.offset $FILE

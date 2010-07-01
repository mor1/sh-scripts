#!/usr/bin/env bash 
#
# Move photos from current directory into subdirs by date.
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

export NO_PROMPT_VARS
set -o noclobber

for n in *.JPG; do
  LINE=$(ls -lT $n | tr -s " ")
  y=$(echo ${LINE} | cut -d " " -f 9)
  case $(echo ${LINE} | cut -d " " -f 6) in
    Jan ) m="01" ;;
    Feb ) m="02" ;;
    Mar ) m="03" ;;
    Apr ) m="04" ;;
    May ) m="05" ;;
    Jun ) m="06" ;;
    Jul ) m="07" ;;
    Aug ) m="08" ;;
    Sep ) m="09" ;;
    Oct ) m="10" ;;
    Nov ) m="11" ;;
    Dec ) m="12" ;;
  esac
  d=$(printf "%02s" $(echo ${LINE} | cut -d " " -f 7))
  sd=${y}-${m}-${d}
  
  f=$(echo ${LINE} | tr -s " " | cut -f 10 -d " ")
  [ ! -d ${sd} ] && mkdir ${sd} 
  mv $f $sd
done

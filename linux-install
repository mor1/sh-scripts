#!/bin/sh

#
# Old Linux install script
#
# Copyright (C) 2000 Richard Mortier <mort@cantab.net>.  All Rights
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

# options:
#   -t         -- install as test kernel
#   -s         -- run mkinitrd
#   -l <label> -- label for lilo.conf
#   -v         -- verbose (ie. don't /dev/null messages from commands)

REALVER=`grep UTS_RELEASE include/linux/version.h | cut -d'"' -f2`
SCSI=0
OFILE=/dev/null

######################################################################
#
# parse args

argsdone=0
while [ $argsdone != 1 ]
do
  case $1 in
  -l)  LABEL=$2 ;          shift ;;
  -t)  VERSION="test" ;    shift ;;
  -s)  SCSI=1 ;            shift ;;
  -v)  OFILE=/dev/stdout ; shift ;;
  *)   argsdone=1                ;;
  esac
done

if [ "$VERSION" != "test" ] ; then
  VERSION=$REALVER
fi

if [ "$LABEL" = "" ] ; then
  LABEL=$VERSION
fi

######################################################################

echo "+++ real version = $REALVER"
echo "+++ version      = $VERSION"
echo "+++ label        = $LABEL"

######################################################################
#
# Do It

echo "+++ make modules_install"
make modules_install >$OFILE

echo "+++ copy bzImage to /boot/vmlinuz-$VERSION"
cp arch/i386/boot/bzImage /boot/vmlinuz-$VERSION >$OFILE

if [ $SCSI = 1 ] ; then
  echo "+++ mkinitrd -v /boot/initrd-$VERSION.img $REALVER"
  mkinitrd -vf /boot/initrd-$VERSION.img $REALVER >$OFILE
fi

echo "+++ copy System.map to /boot/System.map-$VERSION"
cp System.map /boot/System.map-$VERSION >$OFILE
rm -f /boot/System.map >$OFILE
ln -s /boot/System.map-$VERSION /boot/System.map >$OFILE

######################################################################
#
# Run lilo

echo "+++ run lilo"
lilo -v >$OFILE

echo "+++ lilo -R $LABEL"
lilo -R $LABEL >$OFILE

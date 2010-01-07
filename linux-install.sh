#!/bin/sh

######################################################################
#
# $Id: linux-install,v 1.6 2000/11/18 16:12:37 rmm1002 Exp $

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

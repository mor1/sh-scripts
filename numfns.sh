#
# Provide bin -> {dec, hex}, dec -> {bin,oct,hex} and hex -> dec
# conversion from bash.  Why?  Because I was bored.  Just for kicks,
# now have IP addr pretty printer too.
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

########################################################################
#
# decimal to  binary, octal and hex

d2b () {
        if [ $# != 1 ]; then
                echo "Usage: d2b <num> : convert <num> from decimal to binary"
                return 1;
        fi

        local n=$1
        local ret=""

        while [ $n != 0 ]; do
                ret=$[$n%2]$ret ;
                n=$[$n>>1] ;
        done

        echo $ret
}

d2o () {
        if [ $# != 1 ]; then
                echo "Usage: d2o <num> : convert <num> from decimal to octal"
                return 1;
        fi

        local n=$1
        local ret=""

        while [ $n != 0 ]; do
                ret=$[$n%8]$ret ;
                n=$[$n>>3] ;
        done

        echo $ret
}

d2h () {
        if [ $# != 1 ]; then
                echo "Usage: d2h <num> : convert <num> from decimal to hex"
                return 1;
        fi


        local n=$1
        local ret=""

        local t
        local hd

        while [ $n != 0 ]; do
                t=$[$n%16]
                hd=""
                case $t in
                        [0-9]) hd="$t" ;;
                        10)    hd=a ;;
                        11)    hd=b ;;
                        12)    hd=c ;;
                        13)    hd=d ;;
                        14)    hd=e ;;
                        15)    hd=f ;;
                esac
                if [ ! $hd ]; then
                        echo "error in value"
                        return 0
                fi

                ret=$hd$ret ;
                n=$[$n>>4] ;
        done

        echo $ret
}

########################################################################
#
# binary to decimal

b2d () {
        if [ $# != 1 ]; then
                echo "Usage: b2d <num> : convert <num> from binary to decimal"
                return 1;
        fi

        local n=$1
        local ret=0
        local base=1
        
        local lsd

        while [ $n ]; do
                lsd=$[$n%2]
                ret=$[$ret + $[$base*$lsd]]
                base=$[$base*2]
                n=${n%$lsd}
        done

        echo $ret
}

########################################################################
#
# octal to decimal

o2d () {
        if [ $# != 1 ]; then
                echo "Usage: o2d <num> : convert <num> from octal to decimal"
                return 1;
        fi

        local n=$1
        local ret=""
        local base=1

        local lsd
        local pre
        local lsc

        while [ $n ]; do
                pre=${n%[0-7]}
                lsc=${n#$pre}
                if [ ! $lsc ]; then
                        echo "error in value"
                        return 0
                fi

                ret=$[$ret + $[$lsc*$base]]
                base=$[$base*8]
                n=${n%$lsc}
        done

        echo $ret                
}

########################################################################
#
# hex to decimal

dec_digit () {
        local ret=$1

        case $1 in
                a|A)   ret=10 ;;
                b|B)   ret=11 ;;
                c|C)   ret=12 ;;
                d|D)   ret=13 ;;
                e|E)   ret=14 ;;
                f|F)   ret=15 ;;
        esac

        return $ret
}
h2d () {
        if [ $# != 1 ]; then
                echo "Usage: h2d <num> : convert <num> from hex to decimal"
                return 1;
        fi

        local n=$1
        local ret=0
        local base=1

        local pre
        local lsc
        local lsd

        while [ $n ]; do
                pre=${n%[0-9a-fA-F]}
                lsc=${n#$pre}
                if [ ! $lsc ]; then
                        echo "error in value"
                        return 0
                fi
                lsd=`dec_digit $lsc`
                lsd=$?
                ret=$[$ret + $[$lsd*$base]]
                base=$[$base*16]
                n=${n%$lsc}
        done

        echo $ret
}

########################################################################
#
# prip

prip () {
        if [ $# != 1 ]; then
                echo "Usage: prip <addr> : print <addr> (hex, netendian) as dotted quad"
                return 1;
        fi
        

        local argsdone=0
        local NETENDIAN=1
        while [ $argsdone != 1 ]; do
                case $1 in
                -b|-n) NETENDIAN=1 ; shift ;;
                -l)    NETENDIAN=0 ; shift ;;
                *)     argsdone=1
                esac
        done

        local n=$1
        local len=${#n}

        local n0
        local n1
        local n2
        local n3

        if [ $(($len % 2)) = 1 ]; then
                n=0$n
        fi
        n=$((0x$n))

        #
        # number as n=n3n2n1n0
        #

        n0=$(($(($n & 0x000000ff)) >>  0))
        n1=$(($(($n & 0x0000ff00)) >>  8))
        n2=$(($(($n & 0x00ff0000)) >> 16))
        n3=$(($(($n & 0xff000000)) >> 24))

        if [ $n0 -lt 0 ]; then
                n0=$(($n0+256))
        fi
        if [ $n1 -lt 0 ]; then
                n1=$(($n1+256))
        fi
        if [ $n2 -lt 0 ]; then
                n2=$(($n2+256))
        fi
        if [ $n3 -lt 0 ]; then
                n3=$(($n3+256))
        fi

        if [ $NETENDIAN -eq 1 ]; then
                echo "${n3}.${n2}.${n1}.${n0}"
        else
                echo "${n0}.${n1}.${n2}.${n3}"
        fi
}

########################################################################
#
# dswp

dswp () {
        if [ $# != 1 ]; then
                echo "Usage: dswp <num> : print <num> (decimal) byte-swapped"
                return 1;
        fi
        
        local n=0x`d2h $1`

        #
        # number as n=n3n2n1n0
        #

        local n0=`d2h $(($(($n & 0x000000ff)) >>  0))`
        local n1=`d2h $(($(($n & 0x0000ff00)) >>  8))`
        local n2=`d2h $(($(($n & 0x00ff0000)) >> 16))`
        local n3=`d2h $(($(($n & 0xff000000)) >> 24))`

        echo `h2d $n0$n1$n2$n3`
}

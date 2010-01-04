#!/bin/sh -
##############################################################
# whoiss, wrapper for Unix' whois
#
# Performs lookups for any number of domains, netblocks, handles, IPs, ...
# in a single command line without specifying the TLD server.
#
# Available From:
#   http://www.roble.com/docs/whoiss
#
# See Also:
#   http://www.internic.net/whois.html
#   http://www.geektools.com/cgi-bin/proxy.cgi
#   http://www.geektools.com/dist/whoislist.gz
#   http://dir.yahoo.com/Computers_and_Internet/Internet/Directory_Services/Whois/
#   http://whois.bw.org
#
# Thanks To:
#   Kare.Presttun@***.no and tcora@***.army.mil for their contributions.
#
# No Thanks To:
#   Network Solutions (aka Verisign, aka Notwork Solutions, aka Verislime) 
#   for originally corrupting the root whois servers.
#
# To Do:   
#   Keep server list updated.
#   Set $MINPAGE per # lines in display
#
############################################################## 
## (path to the) binary to wrap
BINARY=whois
## use a file viewer (default=less) for more than $MINPAGE queries
MINPAGE=0
##############################################################
# $Id: whoiss.sh,v 1.1 2008/04/30 14:16:25 mort Exp $
##############################################################
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/ucb

if [ "$1" = "" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ]; then
	echo "USAGE: `basename $0` <domain|ip|netblock|handle> [<domain[ip|...>] [...]"
	exit 0
fi

whois_ip () {
	whois="`$BINARY -h whois.arin.net $query |grep "OrgID"|awk '{print $NF}'`"
	if [ "$whois" = APNIC ]; then
		# asia
		whois=whois.apnic.net
	elif [ "$whois" = RIPE ]; then
		# europe
		whois=whois.ripe.net
	elif [ "$whois" = AUNIC ]; then
		# aus/nz/...
		whois=whois.aunic.net
	elif [ "$whois" = LACNIC ] || [ "$whois" = LNIC ]; then
		# latin america - caribbean
		whois=whois.lacnic.net
	else
		#whois=rwhois.arin.net
		whois=whois.arin.net
	fi
 }

whois_name () {
	if [ "`echo $query | grep -- '^NETBLK'`" != "" ]; then
		## netblock ##
		query="`echo ${query} | sed 's/^NETBLK-//'`"
		whois=whois.arin.net
	elif [ "`echo $query | grep -- '^RIPE-'`" != "" ] || \
	[ "`echo $query | grep -- '-RIPE$'`" != "" ]; then
		## euro handle ##
		whois=whois.ripe.net
	elif [ "`echo $query | grep -- '^ARIN-'`" != "" ] || \
	[ "`echo $query | grep -- '-ARIN$'`" != "" ]; then
		## us handle ##
		whois=whois.arin.net
	else
		## parse tld ##
		query="`echo $query |tr \[A-Z] \[a-z]`"
		TLD="`echo $query | awk -F. '{print $NF}'`" 
		## fix URLs ##
		WWWTEST="`echo $query | sed 's/^www.//'`" 
		if [ "$WWWTEST" != "$TLD" ]; then query=${WWWTEST} ; fi

		case $TLD in
			org)
				whois="`$BINARY -h whois.publicinterestregistry.net $query | \
				grep 'Registrant.*Whois.Server' | awk -F: '{print $NF}' | sed 's/
/ /g'`"
				;;
			com|net)
				whois=whois.internic.net
				# aka whois.crsnic.net
				;;
			us)
				whois=whois.nic.us
				;;
			gov)
				whois=whois.nic.gov
				;;
			ca)
				whois=whois.cira.ca
				;;
			al|am|at|az|ba|be|bg|by|cy|cz|de|dk|dz|ee|eg|es|fi|fo|\
			fr|gb|ge|gr|hr|hu|ie|il|is|it|li|lt|lu|lv|ma|md|mk|mt|\
			no|pl|pt|ro|si|sk|sm|su|tn|tr|ua|uk|va|yu)
				#whois.ripe.net, Europe, Middle East and parts of Africa
				whois=whois.ripe.net
				;;
			br)
				#whois=whois.registro.br
				whois=whois.nic.br
				# TODO: query whois.registro.br if indicated
				;;
			au)
				if [ "`echo $query | sed 's/.au$//' | awk -F. '{print $NF}'`" = net ]; then
					whois=whois.connect.com.au
				else
					whois=whois.aunic.net
				fi
				;;
			cn|hk|jp|tw)
				whois=whois.apnic.net
				;;
			se)
				whois=whois.nic-se.se
				;;
			nl)
				whois=whois.nic.nl
				;;
			ru)
				whois=whois.ripn.net
				;;
			tw)
				whois=whois.twnic.net
				;;
			ch)
				whois=whois.nic.ch
				;;
			id)
				whois=whois.idnic.net.id
				;;
			my)
				whois=whois.mynic.net
				;;
			th)
				whois=whois.thnic.net
				;;
			sg)
				whois=whois.nic.net.sg
				;;
			kr)
				whois=whois.krnic.net
				;;
			za)
				if [ "`echo $query | sed 's/.za$//' | awk -F. '{print $NF}'`" = co ]; then
					whois=whois.co.za
				else
					whois=whois.frd.ac.za
				fi
				;;
			mil)
				#us military
				whois=whois.nic.mil
				;;
			in)
				# warning: older versions of `sh` may have problems parsing 'in'
				whois=whois.ncst.ernet.in
				;;
			*-[0-9]*)
				# probably an arin handle
				whois=whois.arin.net
				;;
			*)
				#rs.internic.net, North and South America and parts of Africa
				whois=rs.internic.net
				;;
		esac
	fi
 }

run_query () {
	echo "==========[ Querying $whois for $query ]=========="
	echo ""
	$BINARY -h $whois $query
}

## parse invalid delimiters "[", "(", ... ##
for query in `echo $* | sed -e 's/\[/ /g' -e 's/(/ /g'` ; do
	if [ "$query" = "." ]; then
		continue
	elif [ "`echo $query | grep '[a-zA-Z]'`" = "" ]; then
		whois_ip
	else
		whois_name
	fi
	if [ "$whois" = whois.internic.net ]; then
		whois=`$BINARY -h $whois $query|grep "Whois Server:"|awk '{ print $NF }'`
	fi
	if [ "$whois" = "" ]; then
		# (yet another netsol/verisign bug)
		whois="whois.networksolutions.com"
	fi
	if [ $# -gt "$MINPAGE" ]; then
		## find a decent file viewer ##
		if [ -x /bin/less ]; then
			PAGER="/bin/less -ceinx4"
		elif [ -x /usr/bin/less ]; then
			PAGER="/usr/bin/less -ceinx4"
		elif [ -x /usr/local/bin/less ]; then
			PAGER="/usr/local/bin/less -ceinx4"
		else
			PAGER=${PAGER:-more} 
		fi
		run_query | $PAGER
	else
		run_query
		## to stdout ##
	fi
done

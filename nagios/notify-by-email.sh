#!/bin/bash
##############
#  	Author: Danie van Zyl (https://github.com/anythinglinux/misc_scripts/nagios)
#	Purpose:
#	Notification script that shows who acknowledged a service alert with comments of the author. 
#
#	Should be added under nagios e.g.
#	define command{
#       command_name    notify-by-email
#       command_line   /usr/lib64/nagios/plugins/notify-by-email.sh $NOTIFICATIONTYPE$ "$SERVICEDESC$" "$HOSTALIAS$" "$HOSTADDRESS$" "$SERVICESTATE$" "$SERVICEDURATION$" "$LONGDATETIME$" "$SERVICEOUTPUT$" "$CONTACTEMAIL$" "$NOTIFICATIONAUTHOR$" "$NOTIFICATIONCOMMENT$" 
#	}
#
##############

MAIL=/usr/bin/mail
ntype=${1}
sdesc=${2}
halias=${3}
haddr=${4}
sstate=${5}
sduration=${6}
ldate=${7}
soutput=${8}
cemail=${9}
cname=${10}
ackcomment=${11}

function compile_email {
	local _type=$1
	local _msg=""
	local _subj=""
	if [[ "$_type" == "ACKNOWLEDGEMENT" ]];then
		_msg="***** Nagios  *****\n\nNotification Type: $ntype\nDate/Time: $ldate\nService: $sdesc\nHost: $halias\nAddress: $haddr\nState: $sstate\nDuration: $sduration\nAdditional Info:\n$soutput\n---\nAcknowledged by $cname\nComment: $ackcomment\n\n"
		_subj="** $ntype alert - $halias/$sdesc is $sstate - ack by $cname **" 
	else 
		_msg="***** Nagios  *****\n\nNotification Type: $ntype\nDate/Time: $ldate\nService: $sdesc\nHost: $halias\nAddress: $haddr\nState: $sstate\nDuration: $sduration\nAdditional Info:\n$soutput\n\n"
		_subj="** $ntype alert - $halias/$sdesc is $sstate **" 
	fi
	/usr/bin/printf "%b" "$_msg" | $MAIL -s "$_subj" $cemail
}

case $ntype in
	"ACKNOWLEDGEMENT")
		compile_email $ntype
	;;
	*)
		compile_email $ntype
	;;
esac

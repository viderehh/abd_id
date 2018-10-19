#!/bin/bash
#
#  2018/bf

#whats device ip and names
ip=`ifconfig | egrep "172|192" | awk '{print $2}'`; echo -e "\nIP: $ip"
local_name=`hostname`; echo "Hostname: $local_name" 
dns_name=`host $ip 192.168.99.210 | awk '{print $5}'| grep .`;echo "DNS Name: $dns_name"
echo -e "\nUser Accounts" ; ls /Users/ | egrep -v "\.|Guest|Shared"

users=`cat /Users/Shared/abd_tmp` # gefüttert aus /Users/Shared/abd_tmp
echo -e "\nUser | eMail | Status | AdobeID"
for user in $users
do
 if [ -f /Users/$user/Library/Application\ Support/Adobe/OOBE/ANEData.db ]; then
        userid=`sqlite3 /Users/$user/Library/Application\ Support/Adobe/OOBE/ANEData.db "select userid from NotificationData" | head -n 1`
        user_email=`sqlite3 /Users/"$user"/Library/Application\ Support/Adobe/OOBE/filesync.db "select user_email from users"|head -n 1`
        css=`sqlite3 /Users/"$user"/Library/Application\ Support/Adobe/OOBE/opm.db "select subDomain from opm_data" | grep CSService | head -n 1`
                if [[ $css =~ "CSS" ]];then 
                status="activated" 
                else
                status="not activated"
                fi    
 adb_id="$user | $user_email | $status | $userid"
echo -e "$adb_id\n"
 fi
done

exit 0

#!/bin/bash
#
#  2018/bf

echo -e "\nUser Accounts" ; ls -s /Users/ | egrep -v "Shared|root|total|localized" | awk '{print $2}'

users=`cat /Users/Shared/abd_tmp` # gefüttert aus /Users/Shared/abd_tmp
echo -e "\nUser has Adobe Credentials"
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


#! /bin/ash
mv /etc/config/4g/apn_list.json /etc/config/4g/apn_list.orig
cp /etc/4g_apn_list.json /etc/config/4g/apn_list.json
mv /etc/apn/apn_list.json /etc/apn/apn_list.orig
cp /etc/apn_list.json /etc/apn/apn_list.json
cp /usr/share/telephony/model/data_dial.lua /usr/share/telephony/model/data_dial.orig
sed -i -e 's/if able == 1 then/if 1 == 0 then/g' /usr/share/telephony/model/data_dial.lua
sed -i -e 's/\/etc\/runonce.sh//g' /etc/rc.local
exit 0
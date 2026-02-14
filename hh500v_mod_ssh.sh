#!/bin/bash
mkdir tmp tmp/backup tmp/cfg
tar -xpf configure.bin
openssl aes-256-cbc -d -salt -k 123456 -in tmp/tmp_backupdir/backupbin -out - | tar -C tmp/backup -zxpf -
tar -C tmp/cfg -zxpf tmp/backup/cfg.tar.tgz
sed -i 's/^root:[^:]*/root:/' tmp/cfg/etc/shadow
sed -i 's@exit 0@[[ $(flag_manage read ssh_close | fgrep -c result::FF) -lt 1 ]] \&\& { flag_manage write ssh_close FF; /etc/init.d/dropbear start; }\n/etc/runonce.sh\n&@' tmp/cfg/etc/rc.local
cp runonce.sh tmp/cfg/etc/runonce.sh
cp 4g_apn_list.json tmp/cfg/etc/4g_apn_list.json
cp apn_list.json tmp/cfg/etc/apn_list.json
cd tmp/cfg
tar -I 'gzip -9' --owner=0 --group=0 -cf ../backup/cfg.tar.tgz *
cd ../backup
tar -I 'gzip -9' --owner=0 --group=0 -cf - * | openssl aes-256-cbc -e -salt -k 123456 -in - -out ../tmp_backupdir/backupbin
cd ../..
cp configure.bin configure.bin.orig
tar -I 'gzip -9' --owner=0 --group=0 -cf configure.bin tmp/tmp_backupdir/

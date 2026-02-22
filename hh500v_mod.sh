#!/bin/bash
set -euo pipefail

#This is the help function. It will print text.
helpFunction()
{
    echo ""
    echo "Usage: $0 -s (ssh) y/n -u (unpackonly) y/n -p (packonly) y/n"
    echo -e "\t-s y will enable a SSH server on port 42000 and remove the root password."
    echo -e "\t-s n will not enable a SSH server and does not remove the root password."
    echo -e "\t-u y will only unpack configure.bin so you can dig around yourself. No changes to the unpacked data."
    echo -e "\t-u n will skip this option and continue with the usual function of the script." 
    echo -e "\t-p y will only pack and encrypt the contents of {$PWD}/tmp back to configure.bin"
    echo -e "\t-p n will skip this option and continue with the usual function of the script."
    exit 1
}

#Were arguments passed properly? Read the arguments and display help if "?" was passed.
while getopts "s:u:p:" opt
do
   case "$opt" in
      s ) sshyn="$OPTARG" ;;
      u ) unpackonlyyn="$OPTARG" ;;
      p ) packonlyyn="$OPTARG" ;;
      ? ) helpFunction ;;
   esac
done

#Are -s -u and -p passed? Display help if not.
if [ -z "${sshyn:-}" ] || [ -z "${unpackonlyyn:-}" ] || [ -z "${packonlyyn:-}" ]
then
   echo "Please choose either y or n for -s -u and -p";
   helpFunction
fi

#Validate user input.
case "$sshyn" in
  y|n) ;;
  *) echo "-s must be y or n"; exit 1 ;;
esac

case "$unpackonlyyn" in
  y|n) ;;
  *) echo "-u must be y or n"; exit 1 ;;
esac

case "$packonlyyn" in
  y|n) ;;
  *) echo "-p must be y or n"; exit 1 ;;
esac

#Validate illogical options and make the user aware.
if [ "$unpackonlyyn" = y ] && [ "$packonlyyn" = y ]; then
    echo "Cannot use -u y and -p y together."
    exit 1
fi

#We need to be able to write to the current directory. Can we do that?
if touch .testwperm 2>/dev/null
then
    rm .testwperm
    echo "Write permission check passed. Continuing."
else
    echo "Please make sure the current directory and the files within are writeable."
    exit 1
fi
       
#Create directories tmp, tmp/backup and tmp/cfg - be polite and ask if this is desired.
if [ "$packonlyyn" = n ];
then
    while true; do
        read -p "Continue with creating tmp directory in the current working directory ${PWD}? y/n: " yn
        case $yn in
            [Yy]* ) mkdir -p tmp tmp/backup tmp/cfg; break;;
            [Nn]* ) echo "Interrupting as you do not wish to continue."; exit 0;;
                * ) echo "Please answer Y or N. Stop the script with N."
        esac
    done
fi
#Unpack configure.bin and decrypt the contents, then unpack the decrypted tarball.
if [ "$packonlyyn" = n ];
then
    echo "Backing up configure.bin to configure.bin.ORIG, decrypting configure.bin and writing to directory ${PWD}/tmp."
    cp configure.bin configure.bin.ORIG
    tar -xpf configure.bin
    openssl aes-256-cbc -d -salt -k 123456 -in tmp/tmp_backupdir/backupbin -out - | tar -C tmp/backup -zxpf -
    tar -C tmp/cfg -zxpf tmp/backup/cfg.tar.tgz
fi

#Modify tmp/cfg/etc/shadow to remove the password for root
if [ "$sshyn" = "y" ] && [ "$packonlyyn" = "n" ]; 
    then
        echo "Removing root password from tmp/cfg/etc/shadow and enabling SSH on port 42000."
        echo "You can ignore the warnings about deprecated key variations - this is normal."
        echo " "
        sed -i 's/^root:[^:]*/root:/' tmp/cfg/etc/shadow
        sed -i 's@exit 0@[[ $(flag_manage read ssh_close | fgrep -c result::FF) -lt 1 ]] \&\& { flag_manage write ssh_close FF; /etc/init.d/dropbear start; }\n/etc/runonce.sh\n&@' tmp/cfg/etc/rc.local
    fi

#Make clear that the files have been decrypted and unpacked only if -u y was passed.
if [ "$unpackonlyyn" = "y" ] && [ "$packonlyyn" = "n" ]; 
    then 
        echo "You selected -u y - You can now browse the decrypted and unpacked contents in ${PWD}/tmp/ and make changes yourself."
        exit 0
    fi

#Make sure runonce.sh is marked as executable.
if [[ -x runonce.sh ]]
then
    echo "runonce.sh is marked as executable. Continuing."
else
    echo "runonce.sh is not marked as executable. Marking runonce.sh as executable."
    chmod +x runonce.sh
fi

#Copy static files to respectice directories to add them to configure.bin

if [ "$packonlyyn" = n ];
then
    echo "Copying runonce.sh, 4g_apn_list.json and apn_list.json to their destination inside ${PWD}/tmp/cfg/etc/"
    cp runonce.sh tmp/cfg/etc/runonce.sh
    cp 4g_apn_list.json tmp/cfg/etc/4g_apn_list.json
    cp apn_list.json tmp/cfg/etc/apn_list.json
fi

#Pack and encrypt the contents of tmp
if [ "$unpackonlyyn" = "n" ]
then
    cd tmp/cfg
    tar -I 'gzip -9' --owner=0 --group=0 -cf ../backup/cfg.tar.tgz *
    cd ../backup
    tar -I 'gzip -9' --owner=0 --group=0 -cf - * | openssl aes-256-cbc -e -salt -k 123456 -in - -out ../tmp_backupdir/backupbin
    cd ../..
    tar -I 'gzip -9' --owner=0 --group=0 -cf configure.bin tmp/tmp_backupdir/

About this project
------------------
The TCL HH500V 5G Linkhub, also sold by Vodafone between late 2021 and mid 2023 as "GigaCube 5G" is, in it's branded version, unable to connect automatically to unknown networks via LTE/5G. In case a SIM card is inserted that doesn't pass the proper APN to the system, you have to manually add a profile. Unfortunately, this disables automatic reconnects to the mobile network in case the connection goes down due to, for instance, a reboot. You will often see that a SIM card passes "ims" as "attach access point" instead of the desired APN.
This set of sh-scripts and JSON-files will fix this issue and, if you want, provides a root shell at port 42000. The root shell is only available if you either remove or change the password according to the manual which is available below.
Further files can be altered and modified, if you desire to do so. There are quite some options which can be changed through modification of individual files, like "antenna.json".
Feel free to add your own APN to the JSON files - make sure to follow the syntax, though.

How to use the script
---------------------
The main component of this set of files is "hh500v_mod.sh".
The script uses common programs, like "openssl", "cp", "sed", "tar" and so on. There is nothing special about the script itself.

Here are some use-cases:

You want to enable SSH, remove the password for root, copy the altered APN JSON files and "runonce.sh" over to a modified "configure.bin" file:

./hh500v_mod.sh -s y -u n -p n

You want to unpack and decrypt configure.bin only?

./hh500v_mod.sh -s n -u y -p n

You want to pack and encrypt a modified version of configure.bin?

./hh500v_mod.sh -s n -u n -p y

What can go wrong?
------------------
Depending on what you modify inside tmp/cfg/etc you might mess up configuration files or funcstions used by modules or scripts that keep the device running. If you don't know what you're doing, you should always keep in mind that you might compromise security or end up bricking the device. Even though that is unlikely to happen - it can happen. So use with caution and make sure you understand the consequences of the changes you do.

I messed things up. What do I do?
---------------------------------
Since the data written to the root partition of the device will survive a reboot, a factory reset will undo all changes - thanks to the fact that you don't write to the actual underlying firmware image but only to an overlay file system. Therefore, if something went wrong, perform a factory reset and start over. HOWEVER: If you used tools that will try to perform a firmware upgrade, you might have damaged the original firmware image. In this case, a factory reset might not help you. 

I don't understand how to use the script, neither am I using Linux. What do I do?
---------------------------------------------------------------------------------
There is a configure.bin file located in "modded config" - download configure.bin and verify the MD5 sum located in the same directory against the file you've downloaded. This file can be used via the "backup and restore" function in the WebGUI of your HH500V. It will not alter anything, except copying the prepared APN JSON files and runonce.sh. Then, after a reboot, runonce.sh is executed once after bootup and the "fix" is implemented. Your device will now automatically connect to the mobile network depending on your operator. This "ready to use" mod is currently only implementing access point definitions for the three largest german network operators.

Man, you did a crappy job. I can do better!
-------------------------------------------
Sorry! :) I'm not a programmer - just a curious person. So, if you can contribute, do so! I'll be more than happy to merge any meaningful changes.

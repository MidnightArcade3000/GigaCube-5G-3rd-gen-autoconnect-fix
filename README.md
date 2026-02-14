About this project
------------------
The TCL HH500V 5G Linkhub, also sold by Vodafone between late 2021 and mid 2023 as "GigaCube 5G" is, in it's branded version, unable to connect automatically to unknown networks via LTE/5G. In case a SIM card is inserted that doesn't pass the proper APN to the system, you have to manually add a profile. Unfortunately, this disabled automatic reconnects to the mobile network in case the connection goes down due to a reboot. You will often see that a SIM card passes "ims" as "attach access point" instead of the desired APN.
This set of sh-scripts and JSON-files will fix this issue and, if you want, provides a root shell at port 42000. The root shell is only available if you either remove or change the password according to the manual which is available below.
Feel free to add your own APN to the JSON files - make sure to follow the syntax, though.

How to use the script
---------------------
Information will follow.

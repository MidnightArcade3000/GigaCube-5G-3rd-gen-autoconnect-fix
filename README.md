About this project
------------------
The TCL HH500V 5G Linkhub, also sold by Vodafone between late 2021 and mid 2023 as "GigaCube 5G" is, in it's branded version, unable to connect automatically to unknown networks via LTE/5G. In case a SIM card is inserted that doesn't pass the proper APN to the system, you have to manually add a profile. Unfortunately, this disables automatic reconnects to the mobile network in case the connection goes down due to, for instance, a reboot. You will often see that a SIM card passes "ims" as "attach access point" instead of the desired APN.
This set of sh-scripts and JSON-files will fix this issue and, if you want, provides a root shell at port 42000. The root shell is only available if you either remove or change the password according to the manual which is available below.
Further files can be altered and modified, if you desire to do so. There are quite some options which can be changed through modification of individual files, like "antenna.json".
Feel free to add your own APN to the JSON files - make sure to follow the syntax, though.

Recommended thread on the OpenWRT forums: https://forum.openwrt.org/t/openwrt-support-for-vodafone-gigacube-b157/150371/197

Tested with firmware: HH500V_VDFDE_V2.0.0B19

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
There is a configure.bin file located in "modded_config" - download configure.bin and verify the MD5 sum located in the same directory against the file you've downloaded. This file can be used via the "backup and restore" function in the WebGUI of your HH500V. It will not alter anything, except copying the prepared APN JSON files and runonce.sh. Then, after a reboot, runonce.sh is executed once after bootup and the "fix" is implemented. Your device will now automatically connect to the mobile network depending on your operator. This "ready to use" mod is currently only implementing access point definitions for the three largest german network operators.

Man, you did a crappy job. I can do better!
-------------------------------------------

Sorry! :) I'm not a programmer - just a curious person. So, if you can contribute, do so! I'll be more than happy to merge any meaningful changes.

Über dieses Projekt
-------------------

Der TCL HH500V 5G Linkhub, der von Vodafone zwischen Ende 2021 und Mitte 2023 auch als „GigaCube 5G“ verkauft wurde, ist in seiner gebrandeten Version nicht in der Lage, sich automatisch über LTE/5G mit unbekannten Netzwerken zu verbinden. Falls eine SIM-Karte eingelegt wird, die dem System nicht den korrekten APN übermittelt, muss manuell ein Profil hinzugefügt werden. Leider deaktiviert dies die automatische Wiederverbindung zum Mobilfunknetz, falls die Verbindung (beispielsweise durch einen Neustart) unterbrochen wird. Oftmals ist zu beobachten, dass eine SIM-Karte „ims“ als „Attach Access Point“ anstelle des gewünschten APNs übergibt.

Diese Sammlung von sh-Skripten und JSON-Dateien behebt dieses Problem und stellt auf Wunsch eine Root-Shell auf Port 42000 zur Verfügung. Die Root-Shell ist nur verfügbar, wenn du entweder das Passwort entfernst oder es gemäß der unten stehenden Anleitung ändern.
Weitere Dateien können nach Belieben angepasst und modifiziert werden. Es gibt etliche Optionen, die durch die Bearbeitung einzelner Dateien, wie z. B. „antenna.json“, geändert werden können.

Füge gerne deine eigenen APNs zu den JSON-Dateien hinzu – achte aber darauf, die Syntax einzuhalten.

Empfohlener Thread im OpenWRT-Forum: https://forum.openwrt.org/t/openwrt-support-for-vodafone-gigacube-b157/150371/197

Getestet mit Firmware: HH500V_VDFDE_V2.0.0B19

Verwendung des Skripts
----------------------

Die Hauptkomponente dieses Dateisatzes ist „hh500v_mod.sh“.
Das Skript nutzt gängige Programme wie „openssl“, „cp“, „sed“, „tar“ und so weiter. Das Skript selbst weist keine Besonderheiten auf.

Hier sind einige Anwendungsfälle:

Du willst SSH aktivieren, das Root-Passwort entfernen, die geänderten APN-JSON-Dateien sowie „runonce.sh“ in eine modifizierte „configure.bin“-Datei kopieren:

./hh500v_mod.sh -s y -u n -p n

Du willst die configure.bin nur entpacken und entschlüsseln?

./hh500v_mod.sh -s n -u y -p n

Du willst eine modifizierte Version der configure.bin packen und verschlüsseln?

./hh500v_mod.sh -s n -u n -p y

Was kann schiefgehen?
---------------------

Abhängig davon, was du innerhalb von tmp/cfg/etc änderst, könnten Konfigurationsdateien oder Funktionen kaputtgehen, die von Modulen oder Skripten benötigt werden, um das Gerät am Laufen zu halten. Wenn du nicht genau weißt, was du tust, dann sei dir im Klaren darüber, dass du die Sicherheit des Gerätes gefährden oder das Gerät unbrauchbar machen (bricken) kannst. Obwohl das unwahrscheinlich ist, kann es trotzdem passieren. Verwende das Skript daher mit Vorsicht und denke daran, dass du die Konsequenzen deiner Änderungen verstehen solltest.

Ich habe einen Fehler gemacht. Was soll ich tun?
------------------------------------------------

Da die auf die Root-Partition des Geräts geschriebenen Daten einen Neustart überdauern, wird erst ein Werksreset alle Änderungen rückgängig machen – dank der Tatsache, dass nicht in das eigentliche zugrunde liegende Firmware-Image geschrieben wird, sondern nur in ein Overlay-Dateisystem. Wenn also etwas schiefgelaufen ist, führe einen Werksreset durch und fang nochmal von vorne an. ABER: Wenn du Tools verwendet hast, die versuchen, ein Firmware-Upgrade durchzuführen, hast du möglicherweise das originale Firmware-Image beschädigt. In diesem Fall hilft ein Werksreset möglicherweise nicht weiter.

Ich verstehe nicht, wie man das Skript benutzt, und ich verwende auch kein Linux. Was mache ich?
------------------------------------------------------------------------------------------------

Im Ordner „modded_config“ befindet sich eine configure.bin-Datei. Lade diese herunter und vergleiche die MD5-Summe im selben Verzeichnis mit der Datei, die du heruntergeladen hast. Diese Datei kann über die Funktion „Sichern und Wiederherstellen“ im WebGUI deines HH500V verwendet werden. Sie ändert nichts, außer die vorbereiteten APN-JSON-Dateien und runonce.sh zu kopieren. Nach einem Neustart wird runonce.sh einmalig ausgeführt und der „Fix“ implementiert. Dein Gerät wird sich nun je nach Netzbetreiber automatisch mit dem Mobilfunknetz verbinden. Dieser „Ready-to-use“-Mod implementiert derzeit nur Access-Point-Definitionen für die drei größten deutschen Netzbetreiber.

Mensch, du hast echt miese Arbeit geleistet. Das kann ich besser!
-----------------------------------------------------------------
Sorry! :) Ich bin kein Programmierer – nur eine neugierige Person. Wenn du etwas beitragen kannst, dann mach das gern! Ich bin gerne bereit, sinnvolle Änderungen zu mergen.


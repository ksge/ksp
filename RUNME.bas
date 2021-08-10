'KSGE LAUNCHER
'LAUNCH BINARIES IN THE RIGHT WAY

chdir "core"

#IFDEF __FB_WIN32__
	print
#ELSE
	screen 17
	color 15,1
	cls
	print "                            *** Kiss Strip Game Engine ***"
	print "ON LINUX THIS GAME REQUIRES THE FOLLOWING PACKAGES INSTALLED INTO THE SYSTEM: "
	print
	print "VLC , XTERM and WGET"
	print
	print "FOR EXAMPLE ON DEBIAN YOU CAN INSTALL THEM WITH:"
	print "sudo apt install xterm vlc wget"
	print
	print "this game is tested only on Debian 10"
	print
	print "press ENTER to continue"
	sleep
#ENDIF 

'shell "./ksec"

#IFDEF __FB_WIN32__
	shell "start /max ksge.exe 0"
#ELSE
	shell "xterm -fa 'Monospace' -fs 14 -e ./ksge 0"
#ENDIF

end


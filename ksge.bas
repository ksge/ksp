' KSGE K.I.S.S. STRIP GAME ENGINE
' A STRIP GAME ENGINE BUILD WITH FREEBASIC AND BASED ON LIBVLC AND CCRYPT 
' THIS VERSION CAN PLAY ONLY ENCRYPTED VIDEOCLIPS AND CHECKS FOR THE RIGHT ACTIVATION KEY
' COMPILE WITH FREEBASIC COMPILER (FBC) TESTET WITH VERSION 1.0.7 ON LINUX (DEBIAN 10 and UBUNTU 18.04) AND WINDOWS 10
' ON DEBIAN/UBUNTU gcc , libvlc-dev , libncurses5 , libncurses5-dev are needed
' sudo apt install -y gcc libncurses-dev libgpm-dev libx11-dev libxext-dev libxpm-dev libxrandr-dev libxrender-dev libgl1-mesa-dev libffi-dev libtinfo5 libvlc-dev 
' VIDEOCLIPS SHOULD BE ENCRYPTED WITH CCRYPT HERE IS AN EXAMPLE: ./ccrypt -e -K Str1pgame$areWonferful! YOURFOLDER/*.mkv
' ON LINUX VLC MEDIA PLAYER IS NEEDED TO LAUNCH THE GAME; INSTALL IT WITH: sudo apt install vlc
' the right ccrypt version must be placed in game folder with folder name ccrypt (for windows folder must be named ccrypt-win)
' on windows also wget and md5 must be placed in the game folder with folder name wget-win and md5
' ON WINDOWS libvlc.dll libvlccore.dll and plugin folder must be placed in the game folder (al components can be found in vlc package, on windows vlc version 2.2.8 is at today reccomended)
' 
' CHANGELOG:
' VERSION 1.0 20181129 First working version
' VERSION 1.1 20181216 if a clip isn't found the game tries to go further
' VERSION 3.0 20181230 added play encrypted videoclips 
' VERSION 3.1 20190107 fixed video path/extension bug and slimmed the vlc command line (no single instance and other fixes)
' VERSION 4.0 20190120 vlc replaced by mpv
' VERSION 5.0 20190217 mpv replaced again by libvlc
' VERSION 5.1          checksum of ccrypt bin, on linux every file write during game into memory, static commands inside ksge (except rows), hw mac address check with demo mode, 
' VERSION 5.2 20190823 various bugfixes
' VERSION 5.3 20190827 various bugfixes + testend on Ubuntu 18.04.3
' VERSION 5.4 20190828 various bugfixes + tested on Windows 10 1903
' VERSION 5.5 20190922 bugfixes for key file reading
' VERSION 5.6 20191027 added checksum on clips, bugfix for abnormal quit on end
' VERSION 5.7 20200220 changed colors/messages in console window
' VERSION 5.8 20200918 fixed key read bug
' VERSION 5.9 20201001 fixed md5 *.cpt checksum bug on linux
' VERSION 6.0 20201017 support for PokerView.py added popup when opponent lost
' VERSION 6.1 20210310 support for kspc-url v2, will launch it when game start if a valid activation file is present
' VERSION 6.2 20210311 fixed multiple nic mac address bug + artwork on terminal window
' VERSION 6.3 20210601 small bugfixes on game startup on win

dim totaladdr as integer
dim shared K1 as string*64
dim shared HW1 as string*64
dim shared lin as string*64
dim shared Kh as string*64
dim raddress(1 to 20) as string
dim usdprice as integer
dim randomizeprice as double
dim shared action as string
dim shared shash as string
dim shared shashw as string
dim shared emlf as string
dim shared EML as string
dim shared rown as string
dim shared rurl as string
dim shared kspcha as string
dim shared kspchaw as string
dim shared scode as string


'********************************************************
'static parameters previously passed via command line
const C1 as string = "ModelName" 'model name wich should be equal to folder name
K1 = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" 'key used for encrypt media content and activation file
Kh = "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy" ' key used for temporary activation file (helpme)
shash = "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz  -" 'single hash for all clip *.cpt files
shashw = "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww  -" 'single hash for all clip *.cpt files for windows platform
kspcha = "kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk  kspc"
kspchaw= "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv  kspc.exe"
usdprice = 10 'target price in USD (intended more or less because of volatility and randomization), please insert integer number example: 5
randomizeprice = 0.00009999 'randomize price in satoshi
raddress(1) = "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb" 'address to check transaction for (where monetize)
totaladdr = 1
rurl = "KISS STRIP GAME ENGINE"
rown = "search for kiss strip poker homepage on the web"
const C3 as string = "mkv" 'clip file format
'print "K1:" 'debug
'print K1 'debug
'sleep 'debug
const C2 as string = "0" 'debug 0=no 1=yes
const C4 as string = "KISS STRIP POKER" 'game name
dim C5 as string = Command(1)  'number of winning rows to strip opponent if no specified in command line
const C5bis as string = "2" 'number of standard rows (in case Commnand(1) = 0
const C6 as integer = 3 'number of stages allowed for demo
scode = "https://github.com/ksge"
sub artwork
	cls '6.3
	print "                   .:+!++:::.  .:u+::.     " + C4
	print "                 !!!X:!X<!!!<!#%?!!~XX!!!!:   with"
	print "             :<!!X!!!!:!!>?~!~:<!~!!!?!!!X!!!:  " + C1
	print "           <!!!%!!!!!~!!!!!!<!!!!!!!!!!!!!!!X!!:"
	print "         <!!!!!!!!!!:<<<~~~!~~~~!~~~~!~!<!:!!!!!!:"
	print "       :!!!!!!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~<!~!!!!!."
	print "     .!\!!!!!~~~~~~~~~.ijdkOKISS$$bou. `~~~~~~~~:!!!:"
	print "    <~~~~~~~~~~~~   ~*?*****STRIP$$$$R'$Mx ~~~~~~~~!~~"
	print "   '`~~~~~~          M#?#'?#*GAME*?''??*MX     `~~~~~~~"
	print "    `~~:::::::::~:~~:<:H!!:~<:ENGINE>:<:!::::::::::<<~~"
	print "       ~!!!!!?!!MMXHM@$5@HM%8kdNh!HNRZ7$@MR$N!!?!<'~~"
	print "         ~!!!!!!!!!?!!R?MMM!#$T*M!RMSMXM7!!!!!!!\~~"
	print "           ~~~!!!!!~!!!!!!!!!<!!!!:!!!!!!!!<!~!~~  "
	print "              ~~~~!!!!~!~!~~~!>!:~!!!!!!!!!~~~"
	print "                 `~~~~~~!<!~~!<!!~~!::~~~~~"
	print "                         ~~~~~~~~~~~~!    " + rurl
	if emlf <> "BLANK" and emlf <> "" then
		print "activated by " + emlf + " - thank YOU!"
	end if
end sub
'********************************************************

dim shared endflg as string
endflg = "no"

' let's see if we are on linux or windows
dim shared CC1 as string
#IFDEF __FB_WIN32__
   CONST OS = "windows"
   CC1 = "..\" + C1
#ELSE
   CONST OS = "linux"
   CC1 = "../" + C1
#ENDIF

print C4 + " FOR: " ; OS
sleep 1000

'dim shared tmpplayrootfolder as string
'dim shared decryptexename as string
dim shared tmpplayfolder as string

#IFDEF __FB_WIN32__
	const decryptexename = "ccrypt-win\ccrypt.exe"
	const tmpplayrootfolder as string = ".ksge\"
	tmpplayfolder = ".ksge\"
	shell "rd /s /q .ksge"
	shell "md .ksge"
	shell "attrib +H .ksge"
#ELSE
	const decryptexename = "./ccrypt/ccrypt"
	const tmpplayrootfolder as string = "/dev/shm/.ksge/"
	shell "rm -f -r -d /dev/shm/.ksge"
	mkdir "/dev/shm/.ksge"
	tmpplayfolder = "/dev/shm/.ksge/"
#ENDIF

'set right working folder (where are clips and action file); strip game must use the same action file
'mkdir tmpplayrootfolder

sub actiondone (acted as string)
   open tmpplayrootfolder + "action" + C1 FOR OUTPUT AS #8 LEN = 3
   print #8, acted
   CLOSE #8
End sub


sub chkbin 'chk if the bin(s) are genuine
	dim cmdshl as string
	dim cmdshl2 as string
	dim cmdshl3 as string
	
	#IFDEF __FB_WIN32__
		cmdshl = ("md5\md5.exe " + decryptexename)
		cmdshl2 = ("dir *.cpt /b /os | md5\md5.exe")
		cmdshl3 = ("md5\md5.exe kspc.exe")
	#ELSE
		cmdshl = ("md5sum " + decryptexename)
		cmdshl2 = ("du --apparent-size -k *.cpt | md5sum")
		cmdshl3 = ("md5sum kspc")
	#ENDIF
	
	Open Pipe cmdshl For Input As #1

	Dim As String ln
	Do Until EOF(1)
		Line Input #1, ln
		if ln <> "1d2c1d17b7b0951608bac0baa03b3081  ./ccrypt/ccrypt" and ln <> "1870E29D6261841058B8F73F4E3FE0D2  ccrypt-win\ccrypt.exe" then
			action = "qui"
			print ln
			print "ERROR: WRONG CCRYPT CHECKSUM!"
			sleep 3000,1
			Close #1
			end
		end if
	Loop
	Close #1
	
	Open Pipe cmdshl2 For Input As #1
	'Do Until EOF(1)
		Line Input #1, ln
		Close #1
		if ln <> shash and ln <> shashw then
			action = "qui"
			print ln
			print "ERROR: WRONG CLIPS CHECKSUM!"
			sleep 3000,1
			'Close #1
			end
		end if
	'Loop
	
	Open Pipe cmdshl3 For Input As #1
	'Do Until EOF(1)
		Line Input #1, ln
		Close #1
		if ln <> kspchaw and ln <> kspcha then 
			action = "qui" '********* DEBUG ***************
			print ln
			print "ERROR: WRONG KSPC CHECKSUM!"
			sleep 3000,1
			'Close #1
			'end 'debug ************************************************************** 
		end if
	'Loop
	
	
	#IFDEF __FB_WIN32__
		cmdshl = ("md5\md5.exe libvlc.dll")
		Open Pipe cmdshl For Input As #1
		'Dim As String ln
		Do Until EOF(1)
		Line Input #1, ln
		if ln <> "3C48D31C6FE86762B9EC8CE129444A12  libvlc.dll" then
			action = "qui"
			print ln
			print "ERROR: WRONG LIBVLC CHECKSUM!"
			sleep 3000,1
			Close #1
			end
		end if
		Loop
		Close #1
	#ENDIF
	
	
end sub

sub chkhw
	'check if hw is ok
	dim cmd2 as string
	chkbin
	'open pipe ("echo " + K1 + " | " + decryptexename + " -c -k - " + CC1 + "-key") for Input as #3
	open pipe ("echo " + K1 + "| " + decryptexename + " -c -k - " + CC1 + "-key") for Input as #3	
		line input #3, EML
		line input #3, HW1
		'print "HW1: " 'debug
		'print HW1 'debug
		'print "K1: " 'debug
		'print K1 'debug
	close #3
	'Dim As String lin
	
	#IFDEF __FB_WIN32__
		Open Pipe "getmac /fo csv /nh" For Input As #2
	#ELSE
		Open Pipe "ip addr | grep ether" For Input As #2
	#ENDIF
	dim looflg as integer
	looflg = 0
	Do Until EOF(2) '6.2
		Line Input #2, lin
		'Close #2 '6.2
		'print "lin:" 'debug
		'print lin 'debug
		if lin = HW1 or HW1 = K1 then
			'Close #2
			'print
			print
			'print "Thank YOU for supporting this game!!"
			'print "game activated by:"
			'print EML
			artwork
			'------------------------------------------print EML
			'-----------------------------------------shell "echo " + EML + " thank YOU for supporting this game!"
			if lin = HW1 then 
				print "please note that this game will work only on this PC"
			else 
				print "your game key has no limits"
			end if
			print
			print
			sleep 500,1
			looflg = 1 '6.2
			'goto rungame: '6.2
		end if
	Loop '6.2
	Close #2 '6.2
	if looflg = 1 then '6.2
		goto rungame:
	endif
	artwork
	print "this game is a demo; "
	'-------------------------------------------------print "if you like and want to finish undress the opponent, "
	'------------------------------------------------print "please support it... thank you"
	sleep 5000
	action = "qui"
	actiondone ("qui")
	
	#IFDEF __FB_WIN32__
			shell "start kspc.exe"
	#ELSE
			shell "xterm -fa 'Monospace' -fs 14 -e ./kspc"
	#ENDIF
	
	end
	'libvlc_media_player_release(pPlayer)
	'libvlc_release(pInstance)
	'kill tmpmediaFileName
	'kill tmpplayrootfolder + "action" + C1
	'end
	rungame:
end sub


'run game
'rungame:



if C5 < "1" then C5 = C5bis
'print "./ksbj " + C5 + " " + """" + C4 + """" + " " + """" + C1 + """" + " " + C2 + " &" 'debug

actiondone ("car") '6.3
sleep 1000,1 '6.3
#IFDEF __FB_WIN32__
	'shell "start ksbj.exe " + C5 + " " + """" + C4 + """" + " " + """" + C1 + """" + " " + C2
	shell "start PokerView.exe"
#ELSE
	'shell "./ksbj " + C5 + " " + """" + C4 + """" + " " + """" + C1 + """" + " " + C2 + " &"
	shell "./PokerView &"
#ENDIF

color 15,1
'cls
print C4
'print "this is free/opensource software"
'print "model name: " + C1

#include once "vlc/vlc.bi"

'name of clips (wich must be then build by ksge adding only numbers)
'const ncliptype as string = ".mkv" 'type of clips.. avi, mkv, mpg, mp4 ecc..
#IFDEF __FB_WIN32__
	const nclipstage as string = "stage" 'part of clip name
	const nclipenter as string = "enter" 'part of clip name
	const nclipend as string = "end" 'part of clip name
#ELSE
	const nclipstage as string = "./stage" 'part of clip name
	const nclipenter as string = "./enter" 'part of clip name
	const nclipend as string = "./end" 'part of clip name
#ENDIF

const nclipcar as string = "car" 'part of clip name
const nclipact as string = "act" 'part of clip name
const nclipwin as string = "win" 'part of clip name
const ncliplos as string = "los" 'part of clip name
const nclipris as string = "ris" 'part of clip name
const nclipoff as string = "off" 'part of clip name



'
dim cmdline as string
	
'encryptd file type
const ncliptypeencrypted as string = ".cpt"
'opponents folder
'const opponentsfolder as string = "opponents"
'temp playing folder/file


dim shared tmpplayfile as string

dim shared clipcount as integer = 0
dim shared currentstage as integer = 0
dim shared cliptoplay as string
dim shared lastclipplayed as string
dim shared totalstages as integer
dim shared ncliptype as string

'set correct clip file extension
ncliptype = "." & C3



if c2 = "1" then print C1
'chdir opponentsfolder
'chdir C1
shell "dir"

Function rnd_range (first As Double, last As Double) As Double 'random number inrage for play random clip
    Function = Rnd * (last - first) + first
End Function

Function clipcounter (cliptosearch as string) as string
	dim filename as string
	clipcount = 0
	cliptosearch = cliptosearch + "*"
	filename = Dir(cliptosearch)
	Do While Len( filename ) > 0
		clipcount = clipcount + 1
		'if C2 = "1" then Print filename 'debug
		filename = Dir( )
	Loop

if C2 = "1" then
	print "clipsearched: " , cliptosearch 'debug
	print "counter: " , clipcount 'debug
endif

Function = str (clipcount)
'Sleep
End Function

sub stagescounter
	dim flname as string
	dim stcount as integer
	totalstages = 1
	flname = Dir("stage" + str (totalstages) + "*")
	do while len (flname) > 0
	 totalstages = totalstages +1
	 flname = Dir("stage" + str (totalstages) + "*")
	loop
	totalstages = totalstages - 1
	if C2 = "1" then print flname 'debug
	if C2 = "1" then print "TOTAL STAGES: " , totalstages 'debug
	if C2 = "1" then print totalstages 'debug
	'sleep 'debug
end sub


sub avoidduplicate
	do while clipcount > 1 and cliptoplay = lastclipplayed 
		if action <> "end" then
		cliptoplay = nclipstage + str (currentstage) + action + str(Int(rnd_range(1, clipcount+1))) + ncliptype
		else
		cliptoplay = action + str(Int(rnd_range(1, clipcount+1))) + ncliptype
		end if
		if C2 = "1" then print "duplicate avoided" 'debug
	loop
end sub

sub chkpop '6.1
dim kc1 as string 
	dim cmd2 as string
	'dim emlf as string
	dim hwrf as string 
	dim hwr as string
	dim popf as string
	dim kc1f as string
	dim pop as string
	'#IFDEF __FB_WIN32__
	'open pipe ("echo " + Kh + "| ccrypt-win\ccrypt.exe -c -k - " + CC1 + "-pop-key.cpt") for Input as #3
	'#ELSE
	'open pipe ("echo " + Kh + "| ./ccrypt/ccrypt -c -k - " + CC1 + "-pop-key.cpt") for Input as #3
	'#ENDIF
	'	line input #3, pop
	'	line input #3, kc1
		'print pop 'debug
		'print kc1 'debug
	'	print
	'close #3
	'sleep 100,1
	
	#IFDEF __FB_WIN32__
	open pipe ("echo " + K1 + "| ccrypt-win\ccrypt.exe -c -k - " + CC1 + "-key.cpt") for Input as #3
	#ELSE
	open pipe ("echo " + K1 + "| ./ccrypt/ccrypt -c -k - " + CC1 + "-key.cpt") for Input as #3
	#ENDIF
		line input #3, emlf
		line input #3, hwrf
		line input #3, kc1f 
	close #3
	if emlf <> "" and emlf <> "BLANK" then
		color 15,1
		cls
		print
		print "Game activated by: " + emlf
		print
		sleep 2000,1
	end if
	'sleep 100,1 *************
	
	#IFDEF __FB_WIN32__
	Open Pipe "getmac /fo csv /nh" For Input As #2
	#ELSE
	Open Pipe "ip addr | grep ether" For Input As #2
	#ENDIF
	dim popch1 as integer
	dim popch2 as integer
	popch1 = 0
	popch2 = 0
	Do Until EOF(2) '6.2
	Line Input #2, hwr
	'Close #2 '6.2
	sleep 100,1
	
	if kc1f = c1 and hwr = hwrf then
		'print "goto nocheck" 'debug
		'sleep 'debug
		'#IFDEF __FB_WIN32__
		'shell "start kspc.exe"
		'#ELSE
		'shell "xterm -fa 'Monospace' -fs 14 -e ./kspc"
		'#ENDIF
		goto nocheck
	endif
	
	if kc1f = c1 and hwr <> hwrf then
			'#IFDEF __FB_WIN32__
			'shell "start kspc.exe"
			'#ELSE
			'shell "xterm -fa 'Monospace' -fs 14 -e ./kspc"
			'#ENDIF
			popch1 = 1
			'end 6.2
	endif
	
	if kc1f = c1 and hwrf = "BLANK" then ' pending activation
		popch1 = 1
	end if
	
	'if kc1 = C1 and __DATE_ISO__ < pop then
			'#IFDEF __FB_WIN32__
			'shell "start kspc.exe"
			'#ELSE
			'shell "xterm -fa 'Monospace' -fs 14 -e ./kspc"
			'#ENDIF
	'		popch2 = 1
			'end 6.2
	'endif 
	loop '6.2
	Close #2 '6.2
	if popch1 =1 then
		#IFDEF __FB_WIN32__
		shell "start kspc.exe"
		#ELSE
		shell "xterm -fa 'Monospace' -fs 14 -e ./kspc"
		#ENDIF
		Close #2 '6.2
		end
	endif
	if popch2 = 1 then
		#IFDEF __FB_WIN32__
		shell "start kspc.exe"
		#ELSE
		shell "xterm -fa 'Monospace' -fs 14 -e ./kspc"
		#ENDIF
		Close #2 '6.2
		end
	endif
	nocheck:
	Close #2 '6.2
end sub




function play(fileName as string, pInstance as libvlc_instance_t ptr, pPlayer as libvlc_media_player_t ptr) as integer
   var pMedia = libvlc_media_new_path (pInstance, fileName) 'libvlc_media_t ptr
   libvlc_media_player_set_media(pPlayer, pMedia)
   libvlc_media_player_play(pPlayer)
   dim as long w, h, l, timeout = 5000 'ms
   if C2 = "1" then print "wait on start ..."
   while w = 0 andalso h = 0 andalso l = 0 andalso timeout >= 0
      w = libvlc_video_get_width(pPlayer)
      h = libvlc_video_get_height(pPlayer)
      l = libvlc_media_player_get_length(pPlayer)
      sleep 100 : timeout -= 100
   wend
   if timeout < 0 then
      print "Error: playback not started !"
      return -1
   end if
   'print "size: " & w & " x " & h & " length: " & l \ 1000 'debug
   while libvlc_media_get_state(pMedia) <> libvlc_ended
      sleep 100, 1
   wend
   'XXX libvlc_media_player_stop(pPlayer)
   'sleep
   return 0
end function

var pInstance = libvlc_new(0, NULL) 'libvlc_instance_t ptr
var pPlayer = libvlc_media_player_new(pInstance) 'libvlc_media_player_t ptr

#IFDEF __FB_WIN32__
	var mediaFileName = "enter1.mkv"
#ELSE
	var mediaFileName = "./enter1.mkv"
#ENDIF

' MAIN
chkbin
chkpop '6.1
Randomize Timer
' set random tmp file/folder
'tmpplayfolder = tmpplayrootfolder + str(Int(rnd_range(1, 999999))) + "/" '(random folder... deprecated)

'#IFDEF __FB_WIN32__
'	tmpplayfolder = tmpplayrootfolder + "\" 
'#ELSE
'	tmpplayfolder = tmpplayrootfolder + "/"
'#ENDIF

tmpplayfile = str(Int(rnd_range(1, 999999)))
var tmpMediaFileName = tmpplayfolder + tmpplayfile

'first of all I reset the action file
actiondone ("car")
stagescounter

' deprecated launch of game thread
'#IFDEF __FB_WIN32__
'   CONST OS = "windows"
'   shell "start game.bat"
'#ELSE
'   CONST OS = "linux"
'   shell "./game.sh &"
'#ENDIF
'print OS


while action <> "qui"
print C4
print "this is free/opensource software, source code avaible at:"
print scode
artwork
'print
'print "model name: " + C1
'print
'if emlf <> "" then
'	print "activated by: " + emlf
'end if
'print
print

if currentstage > 0 then
	if endflg = "yes" then
		action = "end"
	end if
	select case action
	case "car"
		clipcounter (nclipstage + str (currentstage) + action)
		cliptoplay = nclipstage + str (currentstage) + action + str(Int(rnd_range(1, clipcount+1))) + ncliptype
		actiondone ("act") 'after car... model should act...
	case "los"
		clipcounter (nclipstage + str (currentstage) + action)
		cliptoplay = nclipstage + str (currentstage) + action + str(Int(rnd_range(1, clipcount+1))) + ncliptype
		actiondone ("car") 'after win or loss... model should take cards...	
	case "win"
		clipcounter (nclipstage + str (currentstage) + action)
		cliptoplay = nclipstage + str (currentstage) + action + str(Int(rnd_range(1, clipcount+1))) + ncliptype
		actiondone ("car") 'after win or loss... model should take cards...	
	case "ris","act"
		clipcounter (nclipstage + str (currentstage) + action)
		cliptoplay = nclipstage + str (currentstage) + action + str(Int(rnd_range(1, clipcount+1))) + ncliptype
		avoidduplicate
	case "off"
		clipcounter (nclipstage + str (currentstage) + action)
		cliptoplay = nclipstage + str (currentstage) + action + str(Int(rnd_range(1, clipcount+1))) + ncliptype
		if currentstage > totalstages then 
		clipcounter (nclipend)
		cliptoplay = nclipend + str(Int(rnd_range(1, clipcount+1))) + ncliptype 
		actiondone ("end") 'after off everything... go to end scenes...
		endflg = "yes"
		'*************6.0
		#IFDEF __FB_WIN32__
		shell "start poker-end.exe"
		#ELSE
		shell "./poker-end &"
		#ENDIF
		'*************
		elseif currentstage < totalstages then
			actiondone ("car") 'after off... model should take cards...
		end if
		currentstage = currentstage + 1
		if currentstage > C6 then chkhw 'checks if game is in demo mode
	case "end"
		clipcounter (nclipend)
		cliptoplay = nclipend + str(Int(rnd_range(1, clipcount+1))) + ncliptype 
		avoidduplicate
		'print emlf
		'print "Thank YOU for supporting this game!"
		'print emlf
		artwork
		actiondone ("end")
	case "qui"
		print "quitting from ksge, no key?"
		sleep 10000,1
		actiondone ("qui")
	case else
		action = "act"
		clipcounter (nclipstage + str (currentstage) + action)
		cliptoplay = nclipstage + str (currentstage) + action + str(Int(rnd_range(1, clipcount+1))) + ncliptype
		avoidduplicate
		actiondone ("act") 'after car... model should act...
	end select
	
	
	
	
	if clipcount = 0 and currentstage <= totalstages then
		if C2 = "1" then print "ERROR CLIP NOT FOUND!!!!"
		if C2 = "1" then print cliptoplay
		'sleep
	end if
	
	mediaFileName = cliptoplay
	lastclipplayed =cliptoplay
	
	
	
	
end if

' entering scene 
if currentstage = 0 then
	clipcounter (nclipenter) 'let's check how many entering clips on filesystem
	cliptoplay = nclipenter + str(Int(rnd_range(1, clipcount+1))) + ncliptype 'let's play a random entering clip
	mediaFileName = cliptoplay
	currentstage = 1
	action = "car"
end if
	
   'if C2 = "1" then print mediaFileName 'debug
   print mediaFileName
   ' check decrypter checksum
   'chkbin
   ' decrypt content
   chkbin
   'cmdline = "echo " + K1 + " | " + decryptexename + " -c -k - " + mediaFileName +  " > " + tmpmediaFileName
   cmdline = "echo " + K1 + "| " + decryptexename + " -c -k - " + mediaFileName +  " > " + tmpmediaFileName
   
	if C2 = "1" then print cmdline 'debug
		
	Dim result As Integer
	chkbin
	result = Shell (cmdline) 
	If result = -1 Then
		Print "Error running "; mediaFileName
	Else
		if C2 = "1" then Print "Exit code:"; result 'debug
	End If
	'return 0
   'if play(mediaFileName, pInstance, pPlayer) < 0 then exit while ' <------- HERE STARTS PLAY CLIP
   'print "playing: " ; tmpMediaFileName 'debug
   if play(tmpmediaFileName, pInstance, pPlayer) < 0 then print mediaFileName, "MAYBE NOT FOUND???" ' <------- HERE STARTS PLAY CLIP
   kill tmpmediaFileName 'after played tmp uncrypted file is deleted
   open tmpplayrootfolder + "action" + C1 FOR INPUT AS #8 LEN = 3
   if action <> "qui" then input #8, action
   CLOSE #8
   'print 'debug
   chkbin
wend



libvlc_media_player_release(pPlayer)
libvlc_release(pInstance)

kill tmpmediaFileName
kill tmpplayrootfolder + "action" + C1

print "bye bye"

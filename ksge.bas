' KSGE K.I.S.S. STRIP GAME ENGINE
' A STRIP GAME ENGINE BUILD WITH FREEBASIC AND BASED ON LIBVLC, CCRYPT, HASHDEEP AND OTHER OPENSOURCE PROJECTS 
' CAN PLAY UNCRYPTED OR ENCRYPTED VIDEOCLIPS, IN CASE OF ENCRYPTED ALSO CHECKS FOR THE RIGHT ACTIVATION KEY AND MD5SUM OF ENCRYPTED CLIPS AND BINARIES
' COMPILE WITH FREEBASIC COMPILER (FBC) TESTET WITH VERSION 1.10.1 ON LINUX (DEBIAN 12 AND ABOVE), WINDOWS 10 AND ABOVE 
' TO COMPILE ON DEBIAN/UBUNTU: gcc , libvlc-dev , libncurses5 , libncurses5-dev are needed
' sudo apt install -y gcc libncurses-dev libgpm-dev libx11-dev libxext-dev libxpm-dev libxrandr-dev libxrender-dev libgl1-mesa-dev libffi-dev libtinfo5 libvlc-dev 
' ON LINUX VLC , XTERM and HASHDEEP ARE NEEDED TO PLAY THE GAME; ON DEBIAN/UBUNTU INSTALL WITH: sudo apt install vlc xterm hashdeep
' the right ccrypt version must be placed in game folder with folder name ccrypt (for windows folder must be named ccrypt-win)
' ON WINDOWS libvlc.dll libvlccore.dll and plugin folder must be placed in the game folder (all components can be found in vlc package, on windows vlc version 2.2.8 is reccomended)
' 
' CHANGELOG:
' VERSION 1.0 20181129 First working version
' VERSION 1.1 20181216 if a clip isn't found the game tries to go further
' VERSION 3.0 20181230 added play encrypted videoclips 
' VERSION 3.1 20190107 fixed video path/extension bug and slimmed the vlc command line (no single instance and other fixes)
' VERSION 4.0 20190120 vlc replaced by mpv
' VERSION 5.0 20190217 mpv replaced again by libvlc
' VERSION 5.1          checksum of ccrypt bin, on linux every file write during game into memory
' VERSION 5.2 20190823 various bugfixes
' VERSION 5.3 20190827 various bugfixes + testend on Ubuntu 18.04.3
' VERSION 5.4 20190828 various bugfixes + tested on Windows 10 1903
' VERSION 5.5 20190922 bugfixes for key file reading
' VERSION 5.6 20191027 added checksum on clips, bugfix for abnormal quit on end
' VERSION 5.7 20200220 changed colors/messages in console window
' VERSION 5.8 20200918 fixed key read bug
' VERSION 5.9 20201001 fixed md5 *.cpt checksum bug on linux
' VERSION 6.0 20201017 support for PokerView.py added popup when opponent lost game
' VERSION 6.1 20210310 support for kspc-url v2, will launch it when game start if a valid activation file is present
' VERSION 6.2 20210311 artwork on terminal window
' VERSION 6.3 20210601 small bugfixes on game startup on win
' VERSION 6.4FREE 20240106 multi-opponent feature - improve clip not found handle
' VERSION 6.5FREE+NONFREE 20240219 added flag to switch between Unencrypted or Encrypted content
' VERSION 20240331 code optimizations, md5deep replaces md5sum for better multiplatform compatibility
' 20240308 code optimizations
' 20240427 bugfix with key check
dim shared K1 as string*64
dim shared action as string
dim shared shash as string
dim shared shashc as string
dim shared emlf as string
dim shared EML as string
dim shared rown as string
dim shared rurl as string
dim shared kspcha as string
dim shared kspchaw as string
dim shared kspcbmp as string
'dim shared kspcbmpw as string
dim shared kspeha as string
dim shared kspehaw as string
dim shared kspebmp as string
dim shared scode as string

'***************signature+settings*START***********************************
const KSGEVER as string = "20240427" 'ksge version
const C1 as string = "KSP" 'costant name after 2024 re-engineered
const C4 as string = "KISS STRIP POKER" 'game name
K1 = "stripgamesarecool" 'key used to encrypt media content and activation file
const ccryptha as string = "1d2c1d17b7b0951608bac0baa03b3081  " 'ccrypt hash
const ccrypthaw as string = "1870e29d6261841058b8f73f4e3fe0d2  " 'ccrypt.exe hash
const livlchaw as string = "3c48d31c6fe86762b9ec8ce129444a12  " 'libvlc.dll hash
kspcha = "8a6c6bface2dd2b485e72bdc0b5c69f3  " ' hash for kspc (linux)
kspchaw= "9b2cbc9e7ef6ee7a389b4bd7e01b1273  " ' hash for kspc.exe (windows)
kspcbmp= "6f8ed7428ba09d521a70c5b883afaf78  " ' hash for kspc.bmp
kspeha = "05a4d039b8d62ee94a619fcb86beeb40  " ' hash for poker-end (linux)
kspehaw= "400ed274c8e024f6d713e34080c6ab90  " ' hash for poker-end.exe (windows)
kspebmp= "9090c3f41e6d885a6cc2a57eaf326706  " ' hash for poker-end.bmp
rown = "ksge@tutanota.com , https://kissstrippoker.wordpress.com" 'info about game author (mail, website, social, etc)
scode = "https://github.com/ksge" 'ksge github page, you can add yours if needed
const C3 as string = "mkv" 'clip file format
const C2 as string = "0" 'debug 0=no 1=yes
dim KSGEENC as string = Command(1) 'type of media content: u=uncrypted e=encrytped
dim KSGEKNM as string = Command(2) 'model name = folder name - used for build activation file name only in encrypted mode
const C5bis as string = "3" 'number of winning rows required by removing opponent piece of cloth
const C6 as integer = 2 'number of stages allowed for demo
rurl = "KISS STRIP GAME ENGINE" 'please do not touch this line
sub artwork 'this ascii artwork will appear in terminal window
	cls '6.3
	print "                   .:+!++:::.  .:u+::.     " + C4
	print "                 !!!X:!X<!!!<!#%?!!~XX!!!!:   "
	print "             :<!!X!!!!:!!>?~!~:<!~!!!?!!!X!!!:  "
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
	print "                 `~~~~~~!<!~~!<!!~~!::~~~~~" + rurl
	print "                         ~~~~~~~~~~~~!    ver" + KSGEVER
	if emlf <> "DEMO" and emlf <> "demo" then
		print "activated by " + emlf + " - thank YOU!"
	else
		print "Demo mode"
	end if
end sub
'***************signature+settings*END***********************************

	dim shared tmpplayfolder as string
	dim shared ln as string
	dim shared cmdshl as string
	dim shared cmdshl2 as string
	dim shared cmdshl3 as string
	dim shared cmdshl4 as string
	dim shared cmdshl5 as string
	dim shared cmdshl6 as string
	dim shared cmdshlv as string
	
	#IFDEF __FB_WIN32__
		const decryptexename = "..\..\core\ccrypt-win\ccrypt.exe" '6.4
		const tmpplayrootfolder as string = "act\" '6.4
		tmpplayfolder = ".ksge\" '6.4
		shell "rd /s /q .ksge" '6.4
		shell "md .ksge" '6.4
		shell "attrib +H .ksge" '6.4
	#ELSE
		const decryptexename = "../../core/ccrypt/ccrypt" '6.4
		const tmpplayrootfolder as string = "act/" '6.4
		shell "rm -f -r -d /dev/shm/.ksge" '6.4
		mkdir "/dev/shm/.ksge" '6.4
		tmpplayfolder = "/dev/shm/.ksge/" '6.4
	#ENDIF

	
	#IFDEF __FB_WIN32__
		cmdshl = ("..\..\core\md5deep\md5deep64.exe -q " + decryptexename) '6.4
		cmdshl2 = ("dir *.cpt /b /os | ..\..\core\md5deep\md5deep64.exe -q") '6.4
		cmdshl3 = ("..\..\core\md5deep\md5deep64.exe -q ..\..\core\kspc.exe") '6.4
		cmdshl4 = ("..\..\core\md5deep\md5deep64.exe -q ..\..\core\kspc.bmp")
		cmdshl5 = ("..\..\core\md5deep\md5deep64.exe -q ..\..\core\poker-end.exe")
		cmdshl6 = ("..\..\core\md5deep\md5deep64.exe -q ..\..\core\poker-end.bmp")
		cmdshlv = ("..\..\core\md5deep\md5deep64.exe -q ..\..\core\libvlc.dll")
	#ELSE
		cmdshl = ("md5deep -q " + decryptexename)
		cmdshl2 = ("ls -1hSr *.cpt | md5deep -q")
		cmdshl3 = ("md5deep -q ../../core/kspc") '6.4
		cmdshl4 = ("md5deep -q ../../core/kspc.bmp")
		cmdshl5 = ("md5deep -q ../../core/poker-end")
		cmdshl6 = ("md5deep -q ../../core/poker-end.bmp")
	#ENDIF

dim shared endflg as string
endflg = "no"

' let's see if we are on linux or windows
dim shared CC1 as string
dim shared CCHSH as string
dim shared CCHS2 as string
#IFDEF __FB_WIN32__
   CONST OS = "windows"
   'CC1 = "key\" + C1 
   CC1 = "key\" + KSGEKNM + "-key.cpt"
   CCHSH = "key\" + KSGEKNM + "-kwin.cpt"
   CCHS2 = "key\" + KSGEKNM + "-klin.cpt"
#ELSE
   CONST OS = "linux"
   'CC1 = "key/" + C1 
   CC1 = "key/" + KSGEKNM + "-key.cpt"
   CCHSH = "key/" + KSGEKNM + "-kwin.cpt"
   CCHS2 = "key/" + KSGEKNM + "-klin.cpt"
#ENDIF

print C4 + " FOR: " ; OS
if KSGEENC = "u" then
	print "Uncrypted content mode"
elseif KSGEENC = "e" then
	print "Encrypted content mode"
else
	print "error check parameters"
	sleep 5000
	end
end if
'print "mode: " + KSGEENC
#IFDEF __FB_WIN32__
	print
	print "PLEASE WAIT.... LOADING Kiss Strip Game Engine "
	'sleep 2000
	print
#ELSE
	print
	print "PLEASE WAIT.... LOADING Kiss Strip Game Engine "
#ENDIF
sleep 2000

sub actiondone (acted as string)
   open tmpplayrootfolder + "action" + C1 FOR OUTPUT AS #8 LEN = 3
   print #8, acted
   CLOSE #8
End sub

sub chkbin 'chk if the bin(s) are genuine
	print ":" 'dbg
	Open Pipe cmdshl For Input As #1
	Do Until EOF(1)
		Line Input #1, ln
		if ln <> ccryptha and ln <> ccrypthaw then
			action = "qui"
			print ln
			print "ERROR: WRONG CCRYPT CHECKSUM!"
			sleep 10000,1
			Close #1
			end
		end if
	Loop
	Close #1
	
	Open Pipe cmdshl2 For Input As #1
		Line Input #1, ln
	Close #1
	open pipe ("echo " + K1 + "| " + decryptexename + " -c -k - " + CC1) for Input as #4
		line input #4, shash
	close #4
	open pipe ("echo " + K1 + "| " + decryptexename + " -c -k - " + CCHSH) for Input as #9
		line input #9, shashc
	close #9
		if ln <> shash and ln <> shashc then
			action = "qui"
			print ln
			print "ERROR: WRONG CLIPS CHECKSUM! YOU NEED A VALID KEY FILE TO PLAY"
			sleep 10000,1
			end
		end if
		'if shash <> shashc then
		'	action = "qui"
		'	print "ERROR: CLIPS KEYS DOESN'T MATCH!"
		'	sleep 10000,1
		'	end
		'end if
	
	Open Pipe cmdshl3 For Input As #1
		Line Input #1, ln
		Close #1
		if ln <> kspchaw and ln <> kspcha then 
			action = "qui" '********* DEBUG ***************
			print ln
			print "ERROR: WRONG KSPC CHECKSUM!"
			sleep 6000,1
		end if
	
	Open Pipe cmdshl4 For Input As #1
		Line Input #1, ln
		Close #1
		if ln <> kspcbmp then 
			action = "qui" '********* DEBUG ***************
			print ln
			print "ERROR: WRONG KSPC.BMP CHECKSUM!"
			sleep 6000,1
		end if
	
	Open Pipe cmdshl5 For Input As #1
		Line Input #1, ln
		Close #1
		if ln <> kspehaw and ln <> kspeha then 
			action = "qui" '********* DEBUG ***************
			print ln
			print "ERROR: WRONG poker-end CHECKSUM!"
			sleep 6000,1 
		end if
		
		Open Pipe cmdshl6 For Input As #1
		Line Input #1, ln
		Close #1
		if ln <> kspebmp then 
			action = "qui" '********* DEBUG ***************
			print ln
			print "ERROR: WRONG poker-end.bmp CHECKSUM!"
			sleep 6000,1 
		end if
	
	#IFDEF __FB_WIN32__
		Open Pipe cmdshlv For Input As #1
		Do Until EOF(1)
		Line Input #1, ln
		if ln <> livlchaw then
			action = "qui"
			print ln
			print "ERROR: WRONG LIBVLC CHECKSUM!"
			sleep 6000,1
			Close #1
			end
		end if
		Loop
		Close #1
	#ENDIF
	
	
end sub

sub chkkey
	print "." 'dbg
	dim KSGEKEY as string
	dim shash2 as string
	chkbin
	open pipe ("echo " + K1 + "| " + decryptexename + " -c -k - " + CC1) for Input as #5
		line input #5, KSGEKEY
		line input #5, EML
		'print "HW1: " 'debug
		'print HW1 'debug
		'print "K1: " 'debug
		'print K1 'debug
	close #5
	
	open pipe ("echo " + K1 + "| " + decryptexename + " -c -k - " + CCHSH) for Input as #7
		line input #7, shashc
	close #7
	
	open pipe ("echo " + K1 + "| " + decryptexename + " -c -k - " + CCHS2) for Input as #2
		line input #2, shash2
	close #2
	
	Open Pipe cmdshl2 For Input As #6
		Line Input #6, ln
	Close #6
	
	if shashc <> KSGEKEY and shash2 <> KSGEKEY then
		print "ERROR PLEASE CHECK KEY FILES!"
		sleep 6000,1
		end
		kill tmpplayrootfolder + "action" + C1
		end
	end if
	
	if (shashc = ln or shash2 = ln) and EML <> "demo" and EML <> "DEMO" then
		'print
		print "game activated by:"
		print EML
		print "Thank YOU for supporting this game!!"
		'artwork
		print "game activated by:" + EML
	else
		artwork
		print "this is a demo, "
		print "if you want to continue, "
		print "please support this game. thank you"
		'print "ksgekey: " + KSGEKEY 'debug
		'print "ln: " + ln 'debug
		sleep 6000,1
		action = "qui"
		actiondone ("qui")
		
		#IFDEF __FB_WIN32__
			shell "start ..\..\core\kspc.exe"
		#ELSE
			shell "xterm -fa 'Monospace' -fs 14 -e ../../core/./kspc"
		#ENDIF
		
		end
		kill tmpplayrootfolder + "action" + C1
		end
	end if
end sub

actiondone ("car") '6.3
sleep 1000,1 '6.3
#IFDEF __FB_WIN32__
	shell "start ..\..\core\PokerView.exe"
#ELSE
	shell "../../core/./PokerView &"
#ENDIF

color 15,1
'cls
print C4
'print "this is free/opensource software"
'print "model name: " + C1

#include once "vlc/vlc.bi"

'name of clips
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

print cliptosearch , " counter: " , clipcount '6.4

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
	print "stages: " , totalstages
	if C2 = "1" then print totalstages 'debug
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
	dim hwrf as string 
	dim hwr as string
	dim popf as string
	dim kc1f as string
	dim pop as string
	dim tmpkkey as string
	
	#IFDEF __FB_WIN32__
		open pipe ("echo " + K1 + "| ..\..\core\ccrypt-win\ccrypt.exe -c -k - " + CC1) for Input as #3 '6.4
	#ELSE
		open pipe ("echo " + K1 + "| ../../core/ccrypt/./ccrypt -c -k - " + CC1) for Input as #3 '6.4
	#ENDIF
		line input #3, tmpkkey 
		line input #3, emlf
	close #3
	if emlf <> "" and emlf <> "DEMO" and emlf <> "demo" then
		color 15,1
		cls
		print
		print "Game activated by: " + emlf
		print
		sleep 1000,1 '****** 2000,1
	end if

	nocheck:

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
if KSGEENC = "e" then
	chkbin
	chkpop '6.1
end if
Randomize Timer

tmpplayfile = str(Int(rnd_range(1, 999999)))
var tmpMediaFileName = tmpplayfolder + tmpplayfile

'first of all I reset the action file
actiondone ("car")
stagescounter

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
		shell "start ..\..\core\poker-end.exe"
		#ELSE
		shell "../../core/./poker-end &"
		#ENDIF
		'*************
		elseif currentstage < totalstages then
			actiondone ("car") 'after off... model should take cards...
		end if
		currentstage = currentstage + 1
		if currentstage > C6 and KSGEENC = "e" then chkkey '6.3FREE if currentstage > C6 then chkhw 'checks if game is in demo mode
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
		'6.4 if C2 = "1" then 
		print "missing clip: " , cliptoplay '6.4
		'6.4 if C2 = "1" then print cliptoplay
		'sleep
		clipcounter (nclipstage + str (currentstage) + "act") '6.4 improve clip not found
		cliptoplay = nclipstage + str (currentstage) + "act" + str(Int(rnd_range(1, clipcount+1))) + ncliptype '6.4 improve clip not found
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
	
   print mediaFileName
   if KSGEENC = "e" then 
	chkbin
	cmdline = "echo " + K1 + "| " + decryptexename + " -c -k - " + mediaFileName +  " > " + tmpmediaFileName
   end if
   	
	Dim result As Integer
	if KSGEENC = "e" then
		'chkbin
		result = Shell (cmdline) 
		If result = -1 Then
			Print "Error running "; mediaFileName
			Else
			if C2 = "1" then Print "Exit code:"; result 'debug
		End If
	end if
   if KSGEENC = "e" then
		if play(tmpmediaFileName, pInstance, pPlayer) < 0 then print mediaFileName, "MAYBE NOT FOUND???" ' <------- HERE STARTS PLAY CLIP 'nonfree
		kill tmpmediaFileName 'after played tmp uncrypted file is deleted 'nonfree
   else
		if play(mediaFileName, pInstance, pPlayer) < 0 then print mediaFileName
   end if
   open tmpplayrootfolder + "action" + C1 FOR INPUT AS #8 LEN = 3
   if action <> "qui" then input #8, action
   CLOSE #8
   'print 'debug
   '''if KSGEENC = "e" then chkbin
wend

libvlc_media_player_release(pPlayer)
libvlc_release(pInstance)

if KSGEENC = "e" then kill tmpmediaFileName
kill tmpplayrootfolder + "action" + C1

print "bye bye"

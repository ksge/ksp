'UTILITIES FOR KSGE

dim totaladdr as integer
dim shared K1 as string*64
dim shared action as string
dim shared shash as string
dim shared shashw as string
dim shared rurl as string
dim shared rown as string
dim shared kspcha as string
dim shared kspchaw as string
dim shared scode as string
dim shared emlf as string
dim shared kspcbmp as string
dim fname as string
dim kspeha as string
dim kspehaw as string
dim kspebmp as string
'***************signature+settings*START***********************************
const KSGEVER as string = "20240408" 'ksge version
const C1 as string = "KSP" 'costant name after 2024 re-engineered
const C4 as string = "KISS STRIP POKER" 'game name
K1 = "stripgamesarecool" 'key used to encrypt media content and activation file
const ccryptha as string = "1d2c1d17b7b0951608bac0baa03b3081  " 'ccrypt hash
const ccrypthaw as string = "1870e29d6261841058b8f73f4e3fe0d2  " 'ccrypt.exe hash
const livlchaw as string = "3c48d31c6fe86762b9ec8ce129444a12  " 'libvlc.dll hash
kspcha = "8a6c6bface2dd2b485e72bdc0b5c69f3  " ' hash for kspc (linux)
kspchaw= "9b2cbc9e7ef6ee7a389b4bd7e01b1273  " ' hash for kspc.exe (windows)
kspcbmp= "6f8ed7428ba09d521a70c5b883afaf78  " ' hash for kspc.bmp
kspeha = "72964c196caeea86c25512ae7a922f40  " ' hash for poker-end (linux)
kspehaw= "6ef31114f0d2e44645fd6752828ab3b6  " ' hash for poker-end.exe (windows)
kspebmp= "496ba6834b137ca88db192d04f33421b  " ' hash for poker-end.bmp
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
end sub'***************signature+settings*END***********************************
dim choice as integer
dim CFNAME as string
dim CC1 as string

#IFDEF __FB_WIN32__
	const nclipstage as string = "stage" 'part of clip name
	const nclipenter as string = "enter" 'part of clip name
	const nclipend as string = "end" 'part of clip name
#ELSE
	const nclipstage as string = "./stage" 'part of clip name
	const nclipenter as string = "./enter" 'part of clip name
	const nclipend as string = "./end" 'part of clip name
#ENDIF

dim HW1 as string 
dim cmd2 as string
dim EML as string
dim popf as string
dim C1F as string
dim satf as string
dim walf as string
dim txf as string
dim shared totalstages as integer
dim shared currentstage as integer = 0
dim shared clipcount as integer = 0
dim ffname as string

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
	print flname 
	print "TOTAL STAGES: " + str (totalstages)
	print "press ENTER to continue" 
	sleep
end sub

Function clipcounter (cliptosearch as string) as string
	dim filename as string
	clipcount = 0
	cliptosearch = cliptosearch + "*"
	filename = Dir(cliptosearch)
	Do While Len( filename ) > 0
		clipcount = clipcount + 1
		Print filename 'debug
		filename = Dir( )
	Loop
	'print "clipsearched: " + cliptosearch 'debug
	print "total " + cliptosearch + " clips: " + str (clipcount)
Function = str (clipcount)
print "press ENTER to continue"
print
Sleep
End Function

'screen 21
color 14,2
cls
print "KSGE ACTIVATOR/ENCRYPTER version " + KSGEVER
print 

#IFDEF __FB_WIN32__
		shell "dir ..\opponents  /ad /b"
	#ELSE
		shell "dir ../opponents"
#ENDIF

print
input "please enter opponent folder/name -> " ; fname
#IFDEF __FB_WIN32__
		ffname = "..\opponents\" + fname
	#ELSE
		ffname = "../opponents/" + fname
#ENDIF
chdir ffname

#IFDEF __FB_WIN32__
	CC1 = "key\" + C1
	CFNAME = "key\" + fname
#ELSE
	CC1 = "key/" + C1
	CFNAME = "key/" + fname
#ENDIF

cls
print "KSGE ACTIVATOR/ENCRYPTER version " + KSGEVER
print C4
print "working folder:" 
print CurDir
print
print "1- video file encrypter"
print "2- video file decrypter"
print "3- clips key file generation"
print "4- activation file generation"
print "5- activation file & clips key viewer"
print "6- print single md5sum hash of encrypted *.cpt clips files"
print "7- print md5sum hashs of kspc and poker-end binaries and bmps"
print "8- print md5sum hashs of ccrypt and libvlc binaries"
print "9- clips counter"
print
print "0- quit"
input "-> " ; choice
print

if choice = 1 then 'video file encrypter
	print "ARE YOU SURE? press enter to continue"
	sleep
	'print "input video file format (example mkv)"
	'input "-> " ; extens
	'print
	#IFDEF __FB_WIN32__
	shell "echo " + K1 + "| ..\..\core\ccrypt-win\ccrypt.exe -e -k - *." + C3
	#ELSE
	shell "echo " + K1 + "| ../../core/ccrypt/ccrypt -e -k - *." + C3
	#ENDIF
	print "DONE!"
	sleep
	print
end if


if choice = 2 then 'video file decrypter
	print "ARE YOU SURE? press enter to continue"
	sleep
	'print "input video file format (example mkv)"
	'input "-> " ; extens
	'print
	#IFDEF __FB_WIN32__
	shell "echo " + K1 + "| ..\..\core\ccrypt-win\ccrypt.exe -d -k - *." + C3 + ".cpt"
	#ELSE
	shell "echo " + K1 + "| ../../core/ccrypt/ccrypt -d -k - *." + C3 + ".cpt"
	#ENDIF
	print "DONE!"
	sleep
	print
end if

if choice = 3 then 'clips key file generation
	dim HW1 as string 
	dim cmd2 as string
	dim EML as string
	print
	print "PLEAST NOTE THAT THIS TOOL SHOULD BE RUN ONCE BOTH IN WINDOWS AND LINUX, OF COURSE ONLY IF YOU WANT THAT THE GAME WILL WORK ON BOTH PLATFORMS"
	PRINT 
	print "PLEASE NOTE THAT THE CLIPS KEY FILE WILL BE OVERWRITTEN IF EXISTS"
	print "clips key file is required to play with encrypted content"
	print
	print "press enter to create clips key file"
	sleep
	'kill CFNAME + "-kwin"
	'kill CFNAME + "-kwin.cpt"
	'kill CFNAME + "-klin"
	'kill CFNAME + "-klin.cpt"
	sleep 100, 1
	
	#IFDEF __FB_WIN32__
		open CFNAME + "-kwin" FOR OUTPUT AS #4
		dim cmdshl as string
		'cmdshl = "dir *.cpt /b /os | ..\..\core\md5deep\md5deep64.exe -q"
		cmdshl = "dir *.cpt /b /os | ..\..\core\md5deep\md5deep64.exe -q"
		Open Pipe cmdshl For Input As #1
			Dim As String ln
			Line Input #1, ln
		close #1
		print curdir
		shell "dir *.cpt /b /os"
		print
		print "single md5sum for *.cpt clips for Windows platform:"
		print ln
		print #4, ln
		close #4
	#ELSE
		open CFNAME + "-klin" FOR OUTPUT AS #4
		dim cmdshl as string
		'cmdshl = "du --apparent-size -k *.cpt | md5sum -z"
		cmdshl = "ls -1hSr *.cpt | md5deep -q"
		Open Pipe cmdshl For Input As #1
			Dim As String ln
			Line Input #1, ln
		close #1
		print curdir
		shell "ls -1hSr *.cpt"
		print
		print "single md5sum for *.cpt clips for Linux platform:"
		print ln
		print #4, ln
		close #4
	#ENDIF
	sleep 100, 1
	print
	#IFDEF __FB_WIN32__
		shell "echo " + K1 + "| ..\..\core\ccrypt-win\ccrypt.exe -e -k - " + CFNAME + "-kwin"
		print "CLIPS KEYFILE FOR WINDOWS PLATFORM CREATED!"
	#ELSE
		shell "echo " + K1 + "| ../../core/ccrypt/ccrypt -e -k - " + CFNAME + "-klin"
		print "CLIPS KEYFILE FOR LINUX PLATFORM CREATED!"
	#ENDIF
	sleep
	print
end if

if choice = 4 then 'activation file generation
	dim HW1 as string 
	dim cmd2 as string
	dim EML as string
	print
	print "PLEASE NOTE THAT THE ACTIVATION FILE WILL BE OVERWRITTEN IF EXISTS"
	print "activation file is required to play with encrypted content"
	print "to generate an activation file for demo purpose just type DEMO"
	print "to generate an activation file for playing full game type supporter mail address"
	print
	print "please enter supporter mail address (type DEMO for 2 stages only demo mode):"
	input EML
	'kill CFNAME + "-key"
	'kill CFNAME + "-key.cpt"
	sleep 100, 1
	open CFNAME + "-key" FOR OUTPUT AS #4
	#IFDEF __FB_WIN32__
		dim cmdshl as string
		'cmdshl = "dir *.cpt /b /os | ..\..\core\md5deep\md5deep64.exe -q"
		cmdshl = "dir *.cpt /b /os | ..\..\core\md5deep\md5deep64.exe -q"
		Open Pipe cmdshl For Input As #1
			Dim As String ln
			Line Input #1, ln
		close #1
		print curdir
		shell "dir *.cpt /b /os"
		print
		print "single hash for *.cpt clips is:"
		print ln
		print #4, ln
	#ELSE
		dim cmdshl as string
		'cmdshl = "du --apparent-size -k *.cpt | md5sum -z"
		cmdshl = "ls -1hSr *.cpt | md5deep -q"
		Open Pipe cmdshl For Input As #1
			Dim As String ln
			Line Input #1, ln
		close #1
		print curdir
		shell "ls -1hSr *.cpt"
		print
		print "single md5sum for .cpt clips is:"
		print ln
		print #4, ln
		print
	#ENDIF
		print #4, EML
    CLOSE #4
	sleep 100, 1
	
	#IFDEF __FB_WIN32__
		shell "echo " + K1 + "| ..\..\core\ccrypt-win\ccrypt.exe -e -k - " + CFNAME + "-key"
	#ELSE
		shell "echo " + K1 + "| ../../core/ccrypt/ccrypt -e -k - " + CFNAME + "-key"
	#ENDIF
	print "ACTIVATION FILE CREATED! YOU CAN SEND IT TO YOUR SUPPORTER"
	sleep
	print
end if

if choice = 5 then 'activation file & clips key file viewer	
	#IFDEF __FB_WIN32__
		open pipe ("echo " + K1 + "| ..\..\core\ccrypt-win\ccrypt.exe -c -k - " + CFNAME + "-key.cpt") for Input as #3
		open pipe ("echo " + K1 + "| ..\..\core\ccrypt-win\ccrypt.exe -c -k - " + CFNAME + "-kwin.cpt") for Input as #4
		open pipe ("echo " + K1 + "| ..\..\core\ccrypt-win\ccrypt.exe -c -k - " + CFNAME + "-klin.cpt") for Input as #5
	#ELSE
		open pipe ("echo " + K1 + "| ../../core/ccrypt/ccrypt -c -k - " + CFNAME + "-key.cpt") for Input as #3
		open pipe ("echo " + K1 + "| ../../core/ccrypt/ccrypt -c -k - " + CFNAME + "-kwin.cpt") for Input as #4
		open pipe ("echo " + K1 + "| ../../core/ccrypt/ccrypt -c -k - " + CFNAME + "-klin.cpt") for Input as #5
	#ENDIF
	line input #3, HW1
	line input #3, EML
	print CFNAME + "-key.cpt"
	print "*.cpt clips md5sum: "
	print HW1
	print "supporter mail: " 
	print EML
	print
	if EML = "DEMO" or EML = "demo" then
		print "this is a demo mode key"
	else
		print "this is a full game key"
	end if
	print
	close #3
	line input #4, shashw
	print CFNAME + "-kwin.cpt"
	print "*.cpt clips md5sum: "
	print shashw
	close #4
	line input #5, shash
	print CFNAME + "-klin.cpt"
	print "*.cpt clips md5sum: "
	print shash
	close #5
	print
	if shashw = HW1 or shash = HW1 then
		print "KEYS MATCH: OK"
	else
		print "ERROR: KEYS DOESN'T MATCH!"
	end if
	sleep
end if

if choice = 6 then 'print single md5sum hash of encrypted *.cpt clips files
	#IFDEF __FB_WIN32__
	dim cmdshl as string
	'cmdshl = "..\..\core\md5deep\md5deep64.exe -b *.cpt | sort -u | ..\..\core\md5deep\md5deep64.exe -b"
	'cmdshl = "dir *.cpt /b /os | md5\md5.exe"
	cmdshl = "dir *.cpt /b /os | ..\..\core\md5deep\md5deep64.exe -q"
	Open Pipe cmdshl For Input As #1
	Dim As String ln
		Line Input #1, ln
		close #1
		print curdir
			Dim filename As String
			filename = Dir("*.cpt")
			Do While Len( filename ) > 0
				Print filename + " ";
				filename = Dir( )
			Loop
		print
		print "this result is valid only for Windows platform, you need to launch this tool on Linux too if you want that key also works on the Linux platform"
		print "single md5sum for *.cpt for Linux platform clips is:"
		print ln
	#ELSE
	dim cmdshl as string
	'cmdshl = "md5deep -b *.cpt | sort /u | md5deep -b"
	'cmdshl = "du --apparent-size -k *.cpt | md5sum"
	cmdshl = "ls -1hSr *.cpt | md5deep -q"
	Open Pipe cmdshl For Input As #1
	Dim As String ln
		Line Input #1, ln
		close #1
		print curdir
			Dim filename As String
			filename = Dir("*.cpt")
			Do While Len( filename ) > 0
				Print filename + " ";
				filename = Dir( )
			Loop
		print
		print "this result is valid only for Linux platform, you need to launch this tool on Windows too if you want that key also works on the Windows platform"
		print "single md5sum for *.cpt for Windows platform clips is:"
		print ln
		print
	#ENDIF
	sleep
end if

if choice = 7 then 'generate md5sum hashs of kspc and poker-end binaries and bmps
	dim cmdshl3 as string
	dim cmdshl3a as string
	dim cmdshl3b as string
	dim cmdshl1 as string
	dim cmdshl1a as string
	dim cmdshl1b as string
	Dim As String ln
	#IFDEF __FB_WIN32__
		cmdshl3 = ("..\..\core\md5deep\md5deep64.exe -q ..\..\core\kspc.exe")
		cmdshl3a = ("..\..\core\md5deep\md5deep64.exe -q ..\..\core\kspc")
		cmdshl3b = ("..\..\core\md5deep\md5deep64.exe -q ..\..\core\kspc.bmp")
		cmdshl1 = ("..\..\core\md5deep\md5deep64.exe -q ..\..\core\poker-end.exe")
		cmdshl1a = ("..\..\core\md5deep\md5deep64.exe -q ..\..\core\poker-end")
		cmdshl1b = ("..\..\core\md5deep\md5deep64.exe -q ..\..\core\poker-end.bmp")
	#ELSE
		cmdshl3 = ("md5deep -q ../../core/kspc.exe")
		cmdshl3a = ("md5deep -q ../../core/kspc")
		cmdshl3b = ("md5deep -q ../../core/kspc.bmp")
		cmdshl1 = ("md5deep -q ../../core/poker-end.exe")
		cmdshl1a = ("md5deep -q ../../core/poker-end")
		cmdshl1b = ("md5deep -q ../../core/poker-end.bmp")

	#ENDIF
	Open Pipe cmdshl3 For Input As #1
		Line Input #1, ln
		print "kspc.exe binary md5sum:"
		print ln
		Close #1
	'
	Open Pipe cmdshl3a For Input As #1
		Line Input #1, ln
		print "kspc binary md5sum:"
		print ln
		Close #1
	'
	Open Pipe cmdshl3b For Input As #1
		Line Input #1, ln
		print "kspc.bmp binary md5sum:"
		print ln
		Close #1
	'	
	print
	Open Pipe cmdshl1 For Input As #1
	Line Input #1, ln
	print "poker-end.exe binary md5sum:"
	print ln
	Close #1
	'
	Open Pipe cmdshl1a For Input As #1
		Line Input #1, ln
		print "poker-end binary md5sum:"
		print ln
		Close #1
	'
	Open Pipe cmdshl1b For Input As #1
		Line Input #1, ln
		print "poker-end.bmp binary md5sum:"
		print ln
		Close #1

	sleep
end if

if choice = 8 then 'generate md5sum hashs of ccrypt and libvlc binaries
	dim cmdshl4 as string
	dim cmdsh14a as string
	dim cmdshl4b as string
	Dim As String ln
	#IFDEF __FB_WIN32__
		cmdshl4 = ("..\..\core\md5deep\md5deep64.exe -q ..\..\core\ccrypt\ccrypt")
		cmdsh14a = ("..\..\core\md5deep\md5deep64.exe -q ..\..\core\ccrypt-win\ccrypt.exe")
		cmdshl4b = ("..\..\core\md5deep\md5deep64.exe -q ..\..\core\libvlc.dll")
	#ELSE
		cmdshl4 = ("md5deep -q ../../core/ccrypt/ccrypt")
		cmdsh14a = ("md5deep -q ../../core/ccrypt-win/ccrypt.exe")
		cmdshl4b = ("md5deep -q ../../core/libvlc.dll")
	#ENDIF
	Open Pipe cmdshl4 For Input As #1
		Line Input #1, ln
		print "ccrypt binary md5sum:"
		print ln
		Close #1
	'
	Open Pipe cmdsh14a For Input As #1
		Line Input #1, ln
		print "ccrypt.exe binary md5sum:"
		print ln
		Close #1
	'
	Open Pipe cmdshl4b For Input As #1
		Line Input #1, ln
		print "libvlc.dll binary md5sum:"
		print ln
		Close #1
	'	
	sleep
end if

if choice = 9 then 'clips counter
	stagescounter
	print 
	'print "ENTER CLIPS:"
	clipcounter ("enter")
	'sleep
	print
	'print "END CLIPS:"
	clipcounter ("end")
	'sleep
	'dim a as integer
	currentstage = 1
	do while currentstage <= totalstages
		'print "STAGE" + str (currentstage) + "act" + " CLIPS:"
		clipcounter (nclipstage + str (currentstage) + "act")
		
		'print "STAGE" + str (currentstage) + "car" + " CLIPS:"
		clipcounter (nclipstage + str (currentstage) + "car")
		
		'print "STAGE" + str (currentstage) + "los" + " CLIPS:"
		clipcounter (nclipstage + str (currentstage) + "los")
		
		'print "STAGE" + str (currentstage) + "off" + " CLIPS:"
		clipcounter (nclipstage + str (currentstage) + "off")
		
		'print "STAGE" + str (currentstage) + "ris" + " CLIPS:"
		clipcounter (nclipstage + str (currentstage) + "ris")
		
		'print "STAGE" + str (currentstage) + "win" + " CLIPS:"
		clipcounter (nclipstage + str (currentstage) + "win")
		
		currentstage = currentstage + 1
	loop
end if

end

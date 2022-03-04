'UTILITIES FOR KSGE
' v0.2 20191105
' v0.3 20201001
' v1.0 20210303 - utilities for kspc v2

dim totaladdr as integer
dim shared K1 as string*64
dim Kh as string*64
dim raddress(1 to 20) as string
dim usdprice as integer
dim randomizeprice as double
dim shared action as string
dim shared shash as string
dim shared shashw as string
dim popenc as integer
dim shared rurl as string
dim pop as string
dim shared rown as string
dim shared kspcha as string
dim shared kspchaw as string
dim shared scode as string
dim shared emlf as string

'***************signature+settings*START***********************************
const C1 as string = "X" 'model name wich should be equal to folder name
K1 = "kissstrippokerkissstrippokerkissstrippokerkissst" 'key used to encrypt media content and activation file
Kh = "kissstripgameenginekissstripgameenginekissstripg" ' key used to temporary activation file (helpme manual procedure)
shash = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  -" 'single hash for all clip *.cpt files
shashw = "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy  -" 'single hash for all clip *.cpt files for windows platform
kspcha = "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz  kspc" ' hash for kspc
kspchaw= "kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk  kspc.exe" ' hash for kspc.exe for windows
usdprice = 50 'target price in USD (intended more or less because of volatility and randomization), please insert integer number example: 50
randomizeprice = 0.00009999 'randomize price in satoshi
raddress(1) = "bc1qzemkkmvmpqfxua6segdd9d75jk4t3gvws3cld8" 'address to check transaction for (where monetize)
totaladdr = 1 ' number of btc addresses inserted above (change only if you want to use more then one btc address)
rurl = "KISS STRIP GAME ENGINE" 'please do not touch this line
rown = "my-mail@gmail.com , www.mysite.com , etc" 'info about game author (mail, website, social, etc)
const C3 as string = "mkv" 'clip file format
const C2 as string = "0" 'debug 0=no 1=yes
const C4 as string = "KISS STRIP POKER" 'game name
dim C5 as string = Command(1)  'number of winning rows passed by command line (to be tested may not work)
const C5bis as string = "3" 'number of winning rows required by removing opponent pice of cloth
const C6 as integer = 4 'number of stages allowed for demo. if you don't want to monetize just type a value = to total number of stages or above
scode = "https://github.com/ksge" 'ksge github page, you can add yours if needed
sub artwork 'this ascii artwork will appear in terminal window
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
'***************signature+settings*END***********************************

dim choice as integer
'dim extens as string

dim CC1 as string
	#IFDEF __FB_WIN32__
		CC1 = "..\" + C1
	#ELSE
		CC1 = "../" + C1
	#ENDIF

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

print "KSGE ACTIVATOR/ENCRYPTER"
print C4 + " with " + C1
print
print "LAUNCH THIS PROGRAM INSIDE THE GAME FOLDER!"
print
print "1- video file encrypter"
print "2- activation file re-encryption"
print "3- video file decrypter"
print "4- activation file re-encryption 4 no hw limits"
print "41- activation file generation 4 no hw limits"
print "5- look activation .key for debug purpose"
print "6- generate single md5sum hash of encrypted *.cpt clips files and kspc (do it both on linux+windows)"
print "7- (DEPRECATED) create activation file (proof of payment-pop) for payment gateways"
print "8- (DEPRECATED) look tmp pop activation key for debug purpose"
print "9- count clips"
print
print "0- quit"
input "-> " ; choice
print

if choice = 1 then
	'print "input video file format (example mkv)"
	'input "-> " ; extens
	'print
	#IFDEF __FB_WIN32__
	shell "echo " + K1 + "| ccrypt-win\ccrypt.exe -e -k - *." + C3
	#ELSE
	shell "echo " + K1 + "| ./ccrypt/ccrypt -e -k - *." + C3
	#ENDIF
	print "DONE!"
	sleep
	print
end if

if choice = 2 then
	
	dim HW1 as string 
	dim cmd2 as string
	dim EML as string
	#IFDEF __FB_WIN32__
	open pipe ("echo " + Kh + "| ccrypt-win\ccrypt.exe -c -k - " + CC1 + "-key.cpt") for Input as #3
	#ELSE
	open pipe ("echo " + Kh + "| ./ccrypt/ccrypt -c -k - " + CC1 + "-key.cpt") for Input as #3
	#ENDIF
		line input #3, EML
		line input #3, HW1
		line input #3, C1F
		line input #3, pop
		line input #3, satf
		line input #3, walf
		line input #3, txf
		print "mail: " + EML
		print "hw: " + HW1
		print "model: " + C1F
		print "date: " + pop
		print "satoshi: " + satf
		print "wallet: " + walf
		print "tx: " + txf
		print
	close #3
	print "ATTENTION: if key don't match, maybe the user is trying to do something bad"
	if txf = "helpme" or txf = "BLANK" then
		print "enter transaction number:"
		txf = ""
		input txf
		kill CC1 + "-key"
		kill CC1 + "-key.cpt"
		sleep 100, 1
		open CC1 + "-key" FOR OUTPUT AS #4
		print #4, EML
		print #4, HW1
		print #4, C1F
		print #4, pop
		print #4, satf
		print #4, walf
		print #4, txf
    CLOSE #4
	sleep 100, 1
	#IFDEF __FB_WIN32__
	shell "echo " + Kh + "| ccrypt-win\ccrypt.exe -e -k - " + CC1 + "-key"
	#ELSE
	shell "echo " + Kh + "| ./ccrypt/ccrypt -e -k - " + CC1 + "-key"
	#ENDIF
	sleep 100,1
	end if
	print "press enter to re-encryption"
	sleep
	
	#IFDEF __FB_WIN32__
	shell "echo " + Kh + "| ccrypt-win\ccrypt.exe -d -k - " + CC1 + "-key.cpt"
	#ELSE
	shell "echo " + Kh + "| ./ccrypt/ccrypt -d -k - " + CC1 + "-key.cpt"
	#ENDIF
	sleep 500,1
	#IFDEF __FB_WIN32__
	shell "echo " + K1 + "| ccrypt-win\ccrypt.exe -e -k - " + CC1 + "-key"
	#ELSE
	shell "echo " + K1 + "| ./ccrypt/ccrypt -e -k - " + CC1 + "-key"
	#ENDIF
	print "DONE!"
	sleep
	print
end if

if choice = 3 then
	'print "input video file format (example mkv)"
	'input "-> " ; extens
	'print
	#IFDEF __FB_WIN32__
	shell "echo " + K1 + "| ccrypt-win\ccrypt.exe -d -k - *." + C3 + ".cpt"
	#ELSE
	shell "echo " + K1 + "| ./ccrypt/ccrypt -d -k - *." + C3 + ".cpt"
	#ENDIF
	print "DONE!"
	sleep
	print
end if

if choice = 4 then
	
	dim HW1 as string 
	dim cmd2 as string
	dim EML as string
	#IFDEF __FB_WIN32__
	open pipe ("echo " + Kh + "| ccrypt-win\ccrypt.exe -c -k - " + CC1 + "-key.cpt") for Input as #3
	#ELSE
	open pipe ("echo " + Kh + "| ./ccrypt/ccrypt -c -k - " + CC1 + "-key.cpt") for Input as #3
	#ENDIF
		line input #3, EML
		line input #3, HW1
		print HW1
		print EML
	close #3
	print "ATTENTION: if key don't match, maybe the user is trying to do something bad"
	print "press enter to re-encryption for NO HW LIMIT DEPLOY"
	sleep
	
	'shell "echo " + Kh + "| ./ccrypt/ccrypt -d -k - " + CC1 + "-key.cpt"
	'sleep 500,1
	kill CC1 + "-key"
	kill CC1 + "-key.cpt"
	sleep 100, 1
	open CC1 + "-key" FOR OUTPUT AS #4
		print #4, EML
		'print #4, HW2
		print #4, K1
    CLOSE #4
	sleep 100, 1
	
	#IFDEF __FB_WIN32__
	shell "echo " + K1 + "| ccrypt-win\ccrypt.exe -e -k - " + CC1 + "-key"
	#ELSE
	shell "echo " + K1 + "| ./ccrypt/ccrypt -e -k - " + CC1 + "-key"
	#ENDIF
	print "DONE!"
	sleep
	print
end if

if choice = 41 then
	
	dim HW1 as string 
	dim cmd2 as string
	dim EML as string
	print
	print "PLEASE NOTE THAT THE ACTIVATION FILE WILL BE OVERWRITTEN IF EXISTS"
	'#IFDEF __FB_WIN32__
	'open pipe ("echo " + Kh + "| ccrypt-win\ccrypt.exe -c -k - " + CC1 + "-key.cpt") for Input as #3
	'#ELSE
	'open pipe ("echo " + Kh + "| ./ccrypt/ccrypt -c -k - " + CC1 + "-key.cpt") for Input as #3
	'#ENDIF
	'	line input #3, EML
	input "please enter customer email address: ", EML
	'	line input #3, HW1
	'	print HW1
	'	print EML
	'close #3
	'print "ATTENTION: if key don't match, maybe the user is trying to do something bad"
	'print "press enter to re-encryption for NO HW LIMIT DEPLOY"
	'sleep
	
	'shell "echo " + Kh + "| ./ccrypt/ccrypt -d -k - " + CC1 + "-key.cpt"
	'sleep 500,1
	kill CC1 + "-key"
	kill CC1 + "-key.cpt"
	sleep 100, 1
	open CC1 + "-key" FOR OUTPUT AS #4
		print #4, EML
		'print #4, HW2
		print #4, K1
    CLOSE #4
	sleep 100, 1
	
	#IFDEF __FB_WIN32__
	shell "echo " + K1 + "| ccrypt-win\ccrypt.exe -e -k - " + CC1 + "-key"
	#ELSE
	shell "echo " + K1 + "| ./ccrypt/ccrypt -e -k - " + CC1 + "-key"
	#ENDIF
	print "DONE!"
	sleep
	print
end if

if choice = 5 then	
	print "let's try to open key with K1...."
	#IFDEF __FB_WIN32__
	open pipe ("echo " + K1 + "| ccrypt-win\ccrypt.exe -c -k - " + CC1 + "-key.cpt") for Input as #3
	#ELSE
	open pipe ("echo " + K1 + "| ./ccrypt/ccrypt -c -k - " + CC1 + "-key.cpt") for Input as #3
	#ENDIF
		line input #3, EML
		line input #3, HW1
		line input #3, C1F
		line input #3, pop
		line input #3, satf
		line input #3, walf
		line input #3, txf
		print "mail: " + EML
		print "hw: " + HW1
		print "model: " + C1F
		print "date: " + pop
		print "satoshi: " + satf
		print "wallet: " + walf
		print "tx: " + txf
		print
	close #3
	print "let's try to open key with Kh...."
	#IFDEF __FB_WIN32__
	open pipe ("echo " + Kh + "| ccrypt-win\ccrypt.exe -c -k - " + CC1 + "-key.cpt") for Input as #3
	#ELSE
	open pipe ("echo " + Kh + "| ./ccrypt/ccrypt -c -k - " + CC1 + "-key.cpt") for Input as #3
	#ENDIF
		line input #3, EML
		line input #3, HW1
		line input #3, C1F
		line input #3, pop
		line input #3, satf
		line input #3, walf
		line input #3, txf
		print "mail: " + EML
		print "hw: " + HW1
		print "model: " + C1F
		print "date: " + pop
		print "satoshi: " + satf
		print "wallet: " + walf
		print "tx: " + txf
		print
	close #3
	print "ATTENTION: if key don't match, maybe the user is trying to do something bad"
	sleep
end if

if choice = 6 then
	#IFDEF __FB_WIN32__
	dim cmdshl as string
	cmdshl = "dir *.cpt /b /os | md5\md5.exe"
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
		print "single hash for .cpt clips for Windows platform is:"
		print ln
	#ELSE
	dim cmdshl as string
	cmdshl = "du --apparent-size -k *.cpt | md5sum"
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
		print "single hash for .cpt clips for linux platform is:"
		print ln
		print
	#ENDIF
	
	'kspc hash
	dim cmdshl3 as string
	#IFDEF __FB_WIN32__
		cmdshl3 = ("md5\md5.exe kspc.exe")
	#ELSE
		cmdshl3 = ("md5sum kspc")
	#ENDIF
	Open Pipe cmdshl3 For Input As #1
	'Do Until EOF(1)
		Line Input #1, ln
		print "kspc binary hash:"
		print ln
		Close #1
	'Loop
	
	sleep
end if

if choice = 7 then
	
	dim HW1 as string 
	dim cmd2 as string
	dim EML as string
	
	print "Please enter the tmp activation key expiring date"
	print "the right format is YYYY-MM-DD"
	input pop
	kill CC1 + "-key"
	kill CC1 + "-key.cpt"
	kill CC1 + "-pop-key.cpt"
	kill CC1 + "-pop-key"
	sleep 100, 1
	open CC1 + "-pop-key" FOR OUTPUT AS #4
		print #4, pop
		print #4, C1
    CLOSE #4
	sleep 100, 1
	
	#IFDEF __FB_WIN32__
	shell "echo " + Kh + "| ccrypt-win\ccrypt.exe -e -k - " + CC1 + "-pop-key"
	#ELSE
	shell "echo " + Kh + "| ./ccrypt/ccrypt -e -k - " + CC1 + "-pop-key"
	#ENDIF
	print "DONE! publish the -pop-key.cpt on the payment gateway or where needed!"
	sleep
	print
end if


if choice = 8 then	
	dim khh as string 
	dim cmd2 as string
	dim EML as string
	print "let's try to open key with Kh...."
	#IFDEF __FB_WIN32__
	open pipe ("echo " + Kh + "| ccrypt-win\ccrypt.exe -c -k - " + CC1 + "-pop-key.cpt") for Input as #3
	#ELSE
	open pipe ("echo " + Kh + "| ./ccrypt/ccrypt -c -k - " + CC1 + "-pop-key.cpt") for Input as #3
	#ENDIF
		line input #3, pop
		line input #3, khh
		print "pop: " + pop
		print "model: " + khh
		print
	close #3
	print "ATTENTION: if key don't match or date is invalid game won't activate!"
	sleep
end if

if choice = 9 then	
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

' KSPC - K.I.S.S. BITCOIN PAYMENT CHECKER VERSION 1.8 20210525
' bitcoin payment checker for KISS STRIP GAME ENGINE (KSGE) based on price and address randomization
' it will ask to send a random (well not totally random) amount of bitcoin to an address selected randomly form one or a given group of addresses
' it will ask for the transaction ID and:
' search if for the in-code-gived btc address exists this transaction with the in-code-gived-randomized amount in satoshi. it will check about (more or less) last 24 transactions on the gived address
' if payment ok (found correct amount in the correct wallet) it will ask for an email address and write the encrypted name-key file inside the opponent folder
' if transaction number = helpme ;  an activation file is written with a different encryption key, so it can be sended to the game provider for manual activation
'
' this application, wich of course cannot be perfect, tries to resolve all the privacy issues involved when using a 3rd party payment gateway
' no personal data is sended anywhere, of course the btc blockchain explorer may track something (for example ip address), but this can easily avoided using a vpn)

#include "string.bi"

dim scode as string
dim address as string
dim raddress(1 to 20) as string
dim totaladdr as integer
dim K1 as string*64
dim Kh as string*64
dim shared amount as string*10
dim shared btcto1usdstrl as string*8
dim transaction as string
dim btcto1usdcmd as string
dim btcto1usdstr as string
dim btcto1usd as double
dim usdprice as integer
dim randomizeprice as double
dim satoshiprice as double
dim eml as string
dim shared shash as string
dim CC1 as string
dim shared emlf as string
dim hwrf as string
dim kc1f as string
dim datf as string
dim satf as string
dim walf as string
dim txf as string
dim hwr as string
dim cdate as string
dim shared rown as string
dim cmdline as string
Dim result As Integer
cdate = __DATE_ISO__
dim paychk as integer 'if paycheck = 2 then paycheck is ok, otherwise no
paychk = 0

#IFDEF __FB_WIN32__
const decryptexename = "ccrypt-win\ccrypt.exe "
#ELSE
const decryptexename = "ccrypt/ccrypt "
#ENDIF

dim shared blockexplorer as string
dim shared curlreply as string
dim i as integer
dim value as string'
dim target as string
dim utime as string
dim shared kspcha as string
dim shared kspchaw as string
dim shared rurl as string
'dim shared txlenghtlimited as string * 32768
dim shared txlenghtlimited as string
' string * 32768 is string lenght... 32768 will check for about 24 last transactions for the gived address
dim shared shashw as string
randomize timer

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


Function rnd_range (first As double, last As double) As double 
    Function = Rnd * (last - first) + first
End Function

sub chkbin 'chk if the bin(s) are genuine
	
	#IFDEF __FB_WIN32__
		dim cmdshl as string
		cmdshl = ("md5\md5.exe wget-win\wget.exe")
		Open Pipe cmdshl For Input As #1
		Dim As String ln
		Do Until EOF(1)
			Line Input #1, ln
			'if ln <> "838C3982C8F34C3BD7ABAE429C4B3380  wget-win\wget.exe" then
			if ln <> "922A1E6FA7DB860CEA6047B6A2DB7814  wget-win\wget.exe" then
				print ln
				print "ERROR: WRONG WGET CHECKSUM!"
				sleep 1500,1
				end
			end if
		Loop
		Close #1
	#ENDIF
end sub


'print "K1: "; K1 'debug
'sleep 'debug

address = raddress (rnd_range(1, totaladdr))

const hlpusr as string = "helpme"

'address = raddress (7) '************************ debug

#IFDEF __FB_WIN32__
btcto1usdcmd = "wget-win\wget.exe -qO- --timeout=10 --tries=2 ""https://blockchain.info/tobtc?currency=USD&value=1"""
'blockexplorer = "wget-win\wget.exe -qO- --timeout=10 --tries=2 https://chain.api.btc.com/v3/address/" + address + "/tx"
blockexplorer = "wget-win\wget.exe -qO- --timeout=10 --tries=2 https://www.blockchain.com/btc/address/" + address
#ELSE
btcto1usdcmd = "wget -qO- --timeout=10 --tries=2 ""https://blockchain.info/tobtc?currency=USD&value=1"""
'blockexplorer = "wget -qO- --timeout=10 --tries=2 https://chain.api.btc.com/v3/address/" + address + "/tx"
blockexplorer = "wget -qO- --timeout=10 --tries=2 https://www.blockchain.com/btc/address/" + address

#ENDIF

sub transread
	open pipe blockexplorer for input as #1
		dim as string ln
		do until eof(1)
			line input #1, ln
			'print ln 'debug
			curlreply=curlreply+ln
			'*** check if TIME TERM exceded
			'***
		loop
	close #1
	txlenghtlimited = curlreply
	'print txlenghtlimited 'debug
	'sleep 'debug
end sub

color 15,1
cls
artwork
print "*** GAME ACTIVATION REQUIRED ***"
print "TO CONTINUE YOU NEED TO ACTIVATE THE GAME"
print "PRESS ENTER IF YOU WANT TO USE THE AUTOMATIC BITCOIN BASED PROCEDURE"
print "OTHERWISE CONTACT THE VIDEOGAME MANUFACTURER AT:"
print rown
sleep
getkey

cls
artwork
'print C4 + " with " + C1
print "......PLEASE WAIT....."
SLEEP 1500,1
chkbin

'if dir(CC1 + "-key.cpt") <> "" then 
#IFDEF __FB_WIN32__
CC1 = "..\" + C1
open pipe ("echo " + K1 + "| ccrypt-win\ccrypt.exe -c -k - " + CC1 + "-key.cpt") for Input as #3
#ELSE
CC1 = "../" + C1
open pipe ("echo " + K1 + "| ./ccrypt/ccrypt -c -k - " + CC1 + "-key.cpt") for Input as #3
#ENDIF
line input #3, emlf
line input #3, hwrf
line input #3, kc1f
line input #3, datf
line input #3, satf
line input #3, walf
line input #3, txf
close #3
sleep 100,1
'end if
	
	#IFDEF __FB_WIN32__
	Open Pipe "getmac /fo csv /nh" For Input As #2
	#ELSE
	Open Pipe "ip addr | grep ether" For Input As #2
	#ENDIF
	Line Input #2, hwr
	Close #2
	sleep 100,1
	
	if hwrf = hwr and kc1f = C1 then 'activation alreay done
		color 15,1
		'cls
		artwork
		print
		print "transaction id:"
		print txf
		print
		print "thank you and enjoy!!"
		sleep 4000,1
		end
	endif
	
	' activation already done but hw changed
	if hwrf <> hwr and hwrf <> "BLANK" and kc1f = C1 and satf <> "BLANK" and walf <> "BLANK" and txf <> "BLANK" and emlf <> "BLANK" and emlf <> "" then
		print "**********************************"
		print C4
		print "**********************************"
		print "with: " ; C1
		print "**********************************"
		print
		print "ATTENTION: HARDWARE CHANGE DETECTED"
		print "seems like that this game was activated on another computer"
		print "if you changed your computer you can activate on the new one"
		print "but you cannot activate the game on more then one computer at the same time"
		print
		
		dim emlval as integer
		'dim EMLF as string
		dim HW1FF as string
		dim popfF as string
		dim C1FF as string
		dim emlcc as string
		dim txcc as string
		emlval = 0
		do
			line input "PLEASE ENTER THE EMAIL ADDRESS USED FOR FIRST ACTIVATION: "; emlcc
			print
			line input "PLEASE ENTER THE TRANSACTION ID USED FOR FIRST ACTIVATION: "; txcc
			sleep 100,1
			if emlcc = EMLF and C1 = kc1f and txcc = txf then
				emlval = 1
			endif
			if emlval = 0 then
				print 
				print "INVALID E-MAIL ADDRESS AND/OR TRANSACTION"
				print 
				'print EMLF 'debug
				'print txf 'debug
				'sleep 'debug
			endif
		loop until emlval = 1
		
		#IFDEF __FB_WIN32__
		Open Pipe "getmac /fo csv /nh" For Input As #2
		#ELSE
		Open Pipe "ip addr | grep ether" For Input As #2
		#ENDIF
		'Do Until EOF(2)
		Line Input #2, hwr
		Close #2
		#IFDEF __FB_WIN32__
		kill "..\" + C1 + "-key"
		kill "..\" + C1 + "-key.cpt"
		CC1 = "..\" + C1
		#ELSE
		kill "../" + C1 + "-key"
		kill "../" + C1 + "-key.cpt"
		CC1 = "../" + C1
		#ENDIF
		sleep 100, 1
		open CC1 + "-key" FOR OUTPUT AS #4
		print #4, emlf
		print #4, hwr
		print #4, kc1f
		print #4, datf
		print #4, satf
		print #4, walf
		print #4, txf
		CLOSE #4
		sleep 100, 1
		#IFDEF __FB_WIN32__
		shell "echo " + K1 + "| ccrypt-win\ccrypt.exe -e -k - " + CC1 + "-key"
		#ELSE
		shell "echo " + K1 + "| ./ccrypt/ccrypt -e -k - " + CC1 + "-key"
		#ENDIF
		sleep 100, 1
		print
		print "GAME ACTIVATED THANK YOU!"
		print "GAME ACTIVATED FOR: " + eml
		print "THE ACTIVATION IS FOR THIS PC ONLY"
		print "PLEASE CLOSE THIS WINDOW AND RESTART THE GAME TO PLAY"
		sleep
		end
	endif
	
' check for pending activation (done about 24 hours before)
'dim datedif as integer
'datedif = __DATE_ISO__ - val(cdate)
'print "datedif: " + val(datedif)
sleep 1000
dim shared pendingchk as integer
pendingchk = 0
if kc1f = C1 and datf <> "BLANK" and satf <> "BLANK" and walf <> "BLANK" and __DATE_ISO__ = datf then
	satoshiprice = val(satf)
	amount = satf
	address = walf
	cdate = datf
	pendingchk = 1
	print "pending transaction found"
	'print datf 'debug
	'print __DATE_ISO__ 'debug
	sleep 1000,1
	'goto wait4trans ***************************************************************************************************************************
	'end
endif

' first game activation:
if pendingchk = 0 then 'peningchk
open pipe btcto1usdcmd for input as #2
	dim as string ln2
	do until eof(2)
		artwork
		print "......PLEASE WAIT....."
		line input #2, ln2
		btcto1usdstr=btcto1usdstr+ln2
		print "1USD = " + ln2
		sleep 1000,1
	loop
close #2



btcto1usd = val(btcto1usdstr)

if btcto1usd > 0.00011111 then
	btcto1usd = 0.00011111 + (rnd_range(0.00000000, randomizeprice))
	print "BTC to 1 USD value > 11111"
	print btcto1usd
	print "......PLEASE WAIT....."
	sleep 1000,1
	'sleep 'debug
end if

satoshiprice = (btcto1usd * usdprice) + (rnd_range(0.00000000, randomizeprice))

transread


'print "satoshiprice: " , satoshiprice 'debug
'sleep 'debug
dim stramount as string*8 'amount in satoshi, only satoshi, no comma
stramount = str(satoshiprice)
'amount = FORMAT(satoshiprice, "00000000") 'amount in satoshi to search for
amount = str(satoshiprice) 
'print "right amount: ", amount 'debug
'sleep  'debug

do 'check if randomized price alredy exsists on blockchain
	
	i = instr(txlenghtlimited, amount)
	if i > 0 then
		'print "found duplicated value: " & i 'debug
		'sleep 1000 'debug
		satoshiprice = satoshiprice + 0.00000001
		'amount = FORMAT(satoshiprice, "00000000") 'amount in satoshi to search for
		amount = str(satoshiprice) 
		'print satoshiprice 'debug
		'print amount 'debug
		'sleep 1000'debug
	else
		exit do
	end if	
loop 


'print "randomized price in Satoshi: " ; satoshiprice 'debug
'sleep 'debug
endif 'pendingchk
wait4trans:

color 15,1
'cls

artwork
print "...PLEASE WAIT..."
sleep 1000,1

color 15,1

cls
artwork
print "AUTOMATIC BITCOIN BASED ACTIVATION"
print "IF YOU WANT TO CONTINUE PLEASE SEND " ; amount ; " BITCOIN TO THIS ADDRESS:"
print
print address
print 
print "THEN PASTE THE TRANSACTION ID IN THIS WINDOW AND PRESS ENTER."
print "if you need help just type helpme and press enter"
#IFDEF __FB_WIN32__
'print "TO COPY/PASTE FROM THIS WINDOW USE CTRL+C (COPY) AND CTRL+V (PASTE)"
#ELSE
print "TO COPY/PASTE FROM THIS WINDOW USE THE MIDDLE MOUSE BUTTON"
#ENDIF

'sleep 2000,1 'qr code 
'#IFDEF __FB_WIN32__
'shell "start kspc-qr.exe " + address + " " + amount
'#ELSE
'shell "xterm -fa 'Monospace' -fs 14 -e ./kspc-qr " + address + " " + amount + " &"
'#ENDIF

'dim shared rurlcmd as string
'#IFDEF __FB_WIN32__
'rurlcmd = "start """" " + """https://www.blockchain.com/btc/payment_request?address="+address+"&amount="+amount+""""
'print rurlcmd 'debug
'sleep 'debug
'#ELSE
'rurlcmd = "xdg-open " + """https://www.blockchain.com/btc/payment_request?address="+address+"&amount="+amount+""""
'#ENDIF
'shell rurlcmd
'print

print "TRANSACTION ID: --> " ;
transaction = ""
Dim As Long kk
Do
    kk = GetKey
    Print chr (kk);
    if kk <> 13 then
		transaction = transaction + chr (kk)
	end if
Loop Until kk = 13 'keep reading key pressend until enter is pressed
'print transaction 'debug
print "PLEASE WAIT....."
sleep 1000,1

'if transaction = hlpusr then
'rem**********************************************************************************
'end if


transread 


'search for transaction (but not care for now...)
i = instr(txlenghtlimited, transaction)
if i > 0 then
	'paychk = paychk + 1
    print "OK - found right transaction"
end if

'clean amount removing 0.0s (zeros on left) ; new variable amountnoz will be used
Dim idx As Integer
dim idx2 as integer
idx2 = 0
dim amountnoz as string
idx = instr(amount, Any "0.")
Do While idx > 0 'if not found loop will be skipped
	idx2 = idx2 + 1
    idx = idx + 1
    idx = InStr(idx, amount, Any "0.")
    
Loop
' !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! amountnoz must be checked if even or odd to avoid zeros on end!
amountnoz = Mid(amount, (idx2 + 1))

' ************************************************************************************************* DBG
'amountnoz = "65100" ' debug
' ************************************************************************************************* DBG
'&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

'print "amountnoz = " ; amountnoz 'debug
'sleep 3000
'print "txlenghtlimted: " + txlenghtlimited 'debug
'sleep 'debug





'search for transaction value
i = instr(txlenghtlimited, amountnoz)
if i > 0 then
	paychk = paychk + 1
    print "OK - found right value"
end if

'if paychk = 2 then
if paychk = 1 or transaction = hlpusr then
	'GetKey 'clear the keyboard buffer
	dim emlval as integer
	emlval = 0
	do
		line input "PLEASE ENTER YOUR E-MAIL ADDRESS: "; eml
		if InStr (eml, "@gmail") then emlval=1
		if InStr (eml, "@yahoo") then emlval=1
		if InStr (eml, "@outlook") then emlval=1
		if InStr (eml, "@hotmail") then emlval=1
		if InStr (eml, "@yandex") then emlval=1
		if InStr (eml, "@aol") then emlval=1
		if InStr (eml, "@sohu") then emlval=1
		if emlval = 0 then
			print 
			print "INVALID E-MAIL ADDRESS"
			print "a known mail provider like gmail, outlook, yahoo etc... is recommended"
		endif
	loop until emlval = 1
	dim HW1 as string 
	'dim HW2 as string
	dim cmd2 as string
	Dim As String lin
	
	#IFDEF __FB_WIN32__
		Open Pipe "getmac /fo csv /nh" For Input As #3
	#ELSE
		Open Pipe "ip addr | grep ether" For Input As #3
	#ENDIF
	
	'Do Until EOF(2)
		Line Input #3, HW1
		'print lin 'debug
		'HW1 = HW1 + lin
	'Loop
	Close #3
	
	sleep 100, 1
	
	'Open Pipe "host name" For Input As #5
	'Do Until EOF(2)
	'	Line Input #2, lin
		'print lin 'debug
	'	HW2 = HW2 + lin
	'Loop
	'Close #5
	dim CC1 as string
	#IFDEF __FB_WIN32__
		kill "..\" + C1 + "-key"
		kill "..\" + C1 + "-key.cpt"
		CC1 = "..\" + C1
	#ELSE
		kill "../" + C1 + "-key"
		kill "../" + C1 + "-key.cpt"
		CC1 = "../" + C1
	#ENDIF
	sleep 100, 1
	open CC1 + "-key" FOR OUTPUT AS #4
		print #4, eml
		print #4, HW1
		print #4, C1
		print #4, cdate
		print #4, amount
		print #4, address
		print #4, transaction
    CLOSE #4
	sleep 100, 1
	
	dim cmdline as string
	
	
	if transaction = hlpusr then
		cmdline = "echo " + Kh + "| " + decryptexename + " -e -k - " + CC1 + "-key"
		result = Shell (cmdline) 
		If result = -1 Then
			Print "Error creating key"
		end if
	color 15,1
	'cls
	print
	print "KEY FILE FOR MANUAL ACTIVATION PRODUCED"
	print "PLEASE SEND MAIL ATTACHING " + C1 + "-key.cpt FILE TO " + rown
	print "THE FILE IS LOCATED IN THE GAME FOLDER"
	print "PLEASE WRITE ALSO THE BITCOIN TRANSACTION ID IN THE MAIL BODY"
	print "THEN WAIT FOR INSTRUCTIONS; THANK YOU IN ADVICE"
	print "PRESS ENTER TO CONTINUE"
	sleep 
	GetKey 'clear the keyboard buffer
	endif
	
	if paychk = 1 then
		cmdline = "echo " + K1 + "| " + decryptexename + " -e -k - " + CC1 + "-key"
		result = Shell (cmdline) 
		If result = -1 Then
			Print "Error creating key"
		end if
	color 15,1
	'cls
	print
	print
	print "GAME ACTIVATED THANK YOU!"
	print "GAME ACTIVATED FOR: " + eml
	print "THE ACTIVATION IS FOR THIS PC ONLY"
	print "please remember the transaction ID and email address you used fo activation,"
	print "you may need them in the future. thank you"
	print "PLEASE CLOSE THIS WINDOW AND RESTART THE GAME TO PLAY"
	sleep 
	GetKey 'clear the keyboard buffer
	endif
	
	
	
else 'payment not found.... write tmp key for pending transaction
	dim CC1 as string
	#IFDEF __FB_WIN32__
		kill "..\" + C1 + "-key"
		kill "..\" + C1 + "-key.cpt"
		CC1 = "..\" + C1
	#ELSE
		kill "../" + C1 + "-key"
		kill "../" + C1 + "-key.cpt"
		CC1 = "../" + C1
	#ENDIF
	sleep 100, 1
	open CC1 + "-key" FOR OUTPUT AS #4
		print #4, "BLANK"
		print #4, "BLANK"
		print #4, C1
		print #4, cdate
		print #4, amount
		print #4, address
		print #4, "BLANK"
    CLOSE #4
	sleep 100, 1
	cmdline = "echo " + K1 + "| " + decryptexename + " -e -k - " + CC1 + "-key"
		result = Shell (cmdline) 
		If result = -1 Then
			Print "Error creating key"
		end if
	
	color 15,1
	'cls
	print
	print
	print "SORRY TRANSACTION NOT FOUND"
	print "PLEASE WAIT SOME MINUTES AND TRY AGAIN"
	print "ALSO MAKE SURE TO HAVE SENDED THE RIGHT AMOUNT OF BITCOIN TO THE RIGHT ADDRESS"
	print "IF PROBLEM PERSISTS AFTER 1 HOUR OR MORE PLEASE CONTACT THE AUTHOR: "
	print rurl
	print rown
	print "PRESS ENTER TO TRY AGAIN"
	sleep 
	GetKey 'clear the keyboard buffer
	goto wait4trans
end if


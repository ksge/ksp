' CAROUSEL MODE FOR KSGE K.I.S.S. STRIP GAME ENGINE
' Created for lazy people who prefer just enjoy clips rather then playing ;)
' launch with carousel %ofwinninchances chances (example carousel 85)
' COMPILE WITH FREEBASIC COMPILER (FBC) TESTET WITH VERSION 1.10.1 ON LINUX (DEBIAN 12 AND ABOVE), WINDOWS 10 AND ABOVE 
' TO COMPILE ON DEBIAN/UBUNTU: gcc , libvlc-dev , libncurses5 , libncurses5-dev are needed
' sudo apt install -y gcc libncurses-dev libgpm-dev libx11-dev libxext-dev libxpm-dev libxrandr-dev libxrender-dev libgl1-mesa-dev libffi-dev libtinfo5 libvlc-dev 
'********************************************************************
dim winchances as string = Command(1) ' chances of winning each hand in %; value should be between 1 and 100
'********************************************************************
dim shared actionread as string
dim shared randlowi as integer
dim shared wrow as integer
const C1 as string = "KSP" 'constant name after 2024 re-engineered
const C5bis as integer = 3 'constant winning in a row
#IFDEF __FB_WIN32__
	const tmpplayrootfolder as string = "act\" '6.4
#ELSE
	const tmpplayrootfolder as string = "act/" '6.4
#ENDIF

Function rnd_range (first As Double, last As Double) As Double 'random number in range
    Function = Rnd * (last - first) + first
End Function

sub actiondo (acted as string)
   open tmpplayrootfolder + "action" + C1 FOR OUTPUT AS #8 LEN = 3
   print #8, acted
   CLOSE #8
   'wait for done
   do
		'wait for act/actionKSP=act or ris
		print "in-actiondo-wait" 'debug
		'sleep Int(rnd_range(1000, 7000+1))
		sleep 1000,1
		open tmpplayrootfolder + "action" + C1 FOR INPUT AS #8 LEN = 3
		input #8, actionread
		CLOSE #8
	'loop until (actionread<>acted or actionread="act" or actionread="ris" or actionread="end") 
	loop until (actionread="act" or actionread="ris" or actionread="end")
	if acted = "off" then
		open tmpplayrootfolder + "action" + C1 FOR OUTPUT AS #8 LEN = 3
		print #8, acted
		CLOSE #8
		do
			sleep 1000,1
			open tmpplayrootfolder + "action" + C1 FOR INPUT AS #8 LEN = 3
			input #8, actionread
			CLOSE #8
		loop until (actionread<>"off")
	end if
End sub

sub waitdo '(wacted as string)
	do
		'wait for act/actionKSP=act or ris
		print "****in-waitdo " ',wacted 'debug
		'sleep Int(rnd_range(1000, 7000+1))
		sleep 1000,1
		open tmpplayrootfolder + "action" + C1 FOR INPUT AS #8 LEN = 3
		input #8, actionread
		CLOSE #8
	loop until (actionread="act" or actionread="ris" or actionread ="end" or actionread="off")  
	'loop until (actionread<>wacted or actionread="ris")
End sub

' MAIN
Randomize Timer
wrow = 0
do until actionread = "end"
	print "wrow: ",wrow 'debug
	sleep Int(rnd_range(1000, 7000+1))
	print "in-main-rnd range" 'debug
	waitdo '("car")
	'write los or win (win chances in %)
	randlowi=Int(rnd_range(1, 100+1))
	if randlowi < VAL(winchances) then
		actiondo ("los")
		wrow = wrow + 1
		'sleep Int(rnd_range(5000, 10000+1))
		print "in-writed los randlowi ",randlowi 'debug
	else
		actiondo ("win")
		wrow = 0
		'sleep Int(rnd_range(5000, 10000+1))
		print "in-writed win randlowi ",randlowi 'debug
	end if
	'if los row = 2 times wait for car and write ris
	if wrow = 2 then
		waitdo '("los")
		print "in-writed ris" 'debug
		'sleep Int(rnd_range(3000, 5000+1))
		'if actionread = "car" then actiondo ("ris")
		actiondo ("ris")
	end if
	'if los row =+ 3 times write off
	if wrow >= 3 then
		actiondo ("off")
		wrow = 0
		print "in-writed off" 'debug
		'sleep Int(rnd_range(15000, 30000+1))
	end if	
loop

print "Goodbye! See you next time, thank you!!"
end

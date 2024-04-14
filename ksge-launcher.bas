' KSGE LAUNCHER
' a simple launcher for kiss strip game engine based games

#include "fbgfx.bi"
#include "dir.bi" 'provides constants to use for the attrib_mask parameter
dim wintitl as string
dim shared ksgelver as string
'*****************************
wintitl = "KISS STRIP POKER"
ksgelver = "20240308" 'ksge launcher version
'*****************************

#IFDEF __FB_WIN32__
	print
#ELSE
	screen 17
	color 15,1
	cls
	print wintitl
	print
	print "On Linux this game requires the following packages installed: "
	print
	print "VLC , XTERM and HASHDEEP"
	print
	print "on Debian based distros you can install them with:"
	print
	print "sudo apt install xterm vlc hashdeep"
	print
	print "This game is tested on last Debian stable,"
	print "may work also on Ubuntu and other distros."
	print
	print "press ENTER to start the game"
	sleep
#ENDIF 

Const LEFTBUTTON   = 1
Const MIDDLEBUTTON = 4  
Const RIGHTBUTTON  = 2   
Const SHOWMOUSE    = 1
Const HIDEMOUSE    = 0

Dim shared CurrentX     As Integer
Dim shared CurrentY     As Integer
Dim shared MouseButtons As Integer
Dim shared CanExit      As Integer

Dim shared target as string

#IFDEF __FB_WIN32__
	declare function hide alias "FreeConsole"() as long
	declare function show alias "AllocConsole" () as long
#ENDIF

function load_bmp(file_name as string) as fb.image ptr
	dim as long file_num = freefile()
	dim as ulong image_width, image_height
	dim as fb.image ptr pImage
	if open(file_name, for binary, access read, as file_num) = 0 then
		get #file_num, 18+1, image_width
		get #file_num, 22+1, image_height
		close #file_num
		pImage = imagecreate(image_width, image_height) 'allocate image memory
		bload(file_name, pImage) 'bitmap into memory
		return pImage
	else
		return 0
	end if
end function

sub displaybmp(file_name as string)
	cls
	dim as string bmp_file_name = file_name
	dim as fb.image ptr pImage = load_bmp(bmp_file_name)
	if pImage <> 0 then
		put(0, 0), pImage, pset
		imagedestroy(pImage)
	else
			print "Error. No such file?: " & bmp_file_name
			sleep 2000
	end if
end sub

sub catchmouse
	dim pth as string
	dim cmmd as string
	dim winquitbutton as string
	Dim As UInteger out_attr
	Dim filename as string

	#IFDEF __FB_WIN32__
		filename = Dir ("*", fbDirectory or fbArchive, out_attr)
		filename = Dir (out_attr)
	#ENDIF

	do
		linuxloop:
		#IFDEF __FB_WIN32__
			filename = Dir ()
			if (out_attr and fbDirectory) > 0 then
				if filename <> "." and filename <> ".." and filename <> "" then 
					displaybmp(filename + "\" + filename + ".bmp")
					print filename '+ "                       version:" + ksgelver
				end if
			else
				print "error no opponents found"
				sleep 3000
				end
			end if
		'end if	
		#ELSE
			filename = Dir ("*", fbDirectory)
			if Len(filename) > 0 and filename <> "." and filename <> ".." then 
				displaybmp(filename + "/" + filename + ".bmp")
				print filename '+ "                       version:" + ksgelver
			else
				print "error no opponents found"
				sleep 3000
				end
			end if
		#ENDIF
	
		mouseinput:
		GetMouse CurrentX, CurrentY, , MouseButtons
		winquitbutton = inkey
		if winquitbutton = chr(255) + "k" then end 'window quit button monitoring
		sleep 10
		If MouseButtons = LEFTBUTTON and CurrentX >= 1507 and CurrentY >= 624 and CurrentY <= 670 Then 'opponent choosed
			print "opponent choosed: " + filename
			'sleep 1000
			#IFDEF __FB_WIN32__
				cmmd = filename + ".bat"
				chdir filename
				'print curdir 'dbg
				'print cmmd 'dbg
				'sleep 5000 'dbg
				run cmmd
			#ELSE
				cmmd = "./" + filename + ".sh"
				'print pth 'dbg
				'print cmmd 'dbg
				'sleep 10000 'dbg
				chdir filename
				'print curdir 'dbg
				'sleep 1000
				run cmmd
			#ENDIF
			end
      	End If
    
		If MouseButtons = LEFTBUTTON and CurrentX >= 1566 and CurrentY >= 558 and CurrentY <= 604 Then 'next opponent
			sleep 200
			#IFDEF __FB_WIN32__
				filename = Dir()
				if Len(filename) > 0 then
					displaybmp(filename + "\" + filename + ".bmp")
					print filename '+ "                       version:" + ksgelver
					'sleep 200
					goto mouseinput
				else
					filename = Dir ("*", fbDirectory or fbArchive, out_attr)
					filename = Dir (out_attr)
					goto linuxloop
				end if
			#ELSE
				filename = Dir() ' Search for (and get) the next item matching the initially specified filespec/attrib.
				if Len(filename) > 0 then
					displaybmp(filename + "/" + filename + ".bmp")
					print filename '+ "                       version:" + ksgelver 'dbg
					'sleep 200
					goto mouseinput
				else
					goto linuxloop
					'	print "error no opponents found"
					'	sleep 3000
					'	end
				end if
			#ENDIF
		end if
				
		If MouseButtons = LEFTBUTTON and CurrentX >= 1582 and CurrentY >= 717 and CurrentY <= 768 Then end
		goto mouseinput
	Loop 
End sub


screenres 1680,768,32
width 40,12
WindowTitle wintitl
#IFDEF __FB_WIN32__
	hide
#ENDIF
target = "opponents"
chdir target
'print curdir 'dbg
'sleep 3000 'dbg
catchmouse

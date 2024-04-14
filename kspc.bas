' KSPC - K.I.S.S. PAYMENT CONTACT VERSION 20240308
' this application shows a .bmp image file with the contact of the game author so that gamer would be able to ask for an activation key
' it's intended to be launched when playing with ksge encrypted content mode after demo stages

#include "fbgfx.bi"

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
		put(20, 20), pImage, pset
		imagedestroy(pImage)
	else
		print "Error. file not found " & bmp_file_name
	end if
end sub


screenres 1024,960,32
width 40,12
WindowTitle "Activation key needed"
#IFDEF __FB_WIN32__
	hide
#ENDIF
displaybmp("../../core/kspc.bmp")
getkey()


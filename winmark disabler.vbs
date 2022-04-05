'▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
'
' Name: winmark-disabler.vbs
'
' Author: Ömer Doğan
' Version: 1.1.0
' Github: https://github.com/owerdogan
'
' Description: Basic Windows watermark remover.
'
'▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁

set wshell = createobject("wscript.Shell")
set fso=createobject("scripting.filesystemobject")

title    = "Winmark Disbaler v1.1.0"
abortmsg = "Watermarks will be removed at next boot. (Restart aborted)"
temp = wshell.expandenvironmentstrings("%TEMP%")
winmark = temp+"\winmark.bat"

set wmbat = fso.createtextfile(winmark,true)

function regvalueexists (key)
      on error resume next
      regvalueexists = true
      err.clear
      wshell.regread(key)
      if err <> 0 then regvalueexists = false
      err.clear
end function

if wscript.arguments.length = 0 then
	set shellapp = createobject("shell.application")
	shellapp.shellexecute "wscript.exe", chr(34) & _
    wscript.scriptfullName & chr(34) & " uac", "", "runas", 1
else
    msgbox "Welcome to Winmark!" & vbcrlf & vbcrlf & _ 
	"If your system has a ""Activate Windows"" or ""System does not meet requirements"" watermark, it will be removed. Also this action can help remove other watermarks." & vbcrlf & vbcrlf & _
	"You can star the project on github to support it." & vbcrlf & _
	"Github: https://github.com/owerdogan/winmark-disabler", 0+vbinformation, title

		wmbat.write "Reg.exe add ""HKLM\SYSTEM\CurrentControlset\Services\svsvc"" /v ""Start"" /t REG_DWoRD /d ""4"" /f" & vbcrlf
		if regvalueexists("HKCU\Control Panel\UnsupportedHardwareNotificationCache\") then
			wmbat.write "Reg.exe add ""HKCU\Control Panel\UnsupportedHardwareNotificationCache"" /v ""SV2"" /t REG_DWoRD /d ""0"" /f" '& vbcrlf
		end if
		wmbat.close
		wshell.run chr(34) & temp + "\winmark.bat" & chr(34), 0
		wscript.sleep 100
		fso.deletefile temp + "\winmark.bat"
	
	choice = _
    msgbox("Your system must be restarted for the watermark removal to take effect.. Would you like to restart now?", 4+VBQuestion, title)
	
	if choice = vbyes then
		wshell.run "%comspec% /c shutdown /r /t 0", , true
	else
    	msgbox abortmsg, 48, title
	end if

end if

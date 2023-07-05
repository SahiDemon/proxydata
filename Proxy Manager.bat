::#region Start of Script

@echo off
call proxyintro.bat
@setlocal enableextensions
@cd /d "%~dp0"
set "original_dir=%cd%"
SET /a "St=0"
set soundConfigFile=sound.config
SET /a "passfail=0"
Set "DownSpeed=Download: 0.00 MB/s"
set "Latecy=Latency: 00.00 ms"
Color 3F & MODE con:cols=80 lines=7
title Proxy Manager
set message=Initializing Proxy
call :loading
timeout 2 >nul
if exist config.sahi goto loadtrue
if not exist config.sahi goto loadfail

::#endregion
::#region Config Check
:loadfail
cls
echo Hmm. Looks like It's a Fresh Start. Hang Tight We got this!
timeout 3 >nul
goto :smartscan

:loadtrue
findstr "v2rayN.exe proxifier" config.sahi > nul

if %errorlevel%==0 (
cls
echo Config Loaded Successfully!

timeout 3 >nul
goto :resume
) else (
Color 4F & MODE con:cols=80 lines=10
echo Uhh ERROR:404 Lets make this right!
timeout 3 >nul
goto :reset
)
::#endregion
::#region SmartScan file locations
:smartscan
cls
Color 4F & MODE con:cols=80 lines=10
set message=Auto Deteminding File Locations..
call :loading
timeout 1 >nul

set files="%HOMEDRIVE%\Program Files (x86)\Proxifier\Proxifier.exe" "%USERPROFILE%\ProxyManager\proxydata-main\httping.exe" "%USERPROFILE%\ProxyManager\proxydata-main\ERRORproxy.mp3" "%USERPROFILE%\ProxyManager\proxydata-main\proxySuccess.mp3" "%USERPROFILE%\ProxyManager\v2rayN-Core\v2rayN.exe"

set missing=

for %%f in (%files%) do (
  if not exist "%%f" (
    set missing=%missing% "%%f"
  )
)

if defined missing (
  echo script Can't proceed because these files are missing: %missing%
  echo Redirecting to mannual selection
  set message=Automatic Detection failed! Redirecting...
  call :loading
  goto :setdir
)

:autofilesetup
@cd /d "%~dp0"
( echo Set Sound = CreateObject("WMPlayer.OCX.7"^)
  echo Sound.URL = "%USERPROFILE%\ProxyManager\proxydata-main\proxySuccess.mp3"
  echo Sound.Controls.play
  echo do while Sound.currentmedia.duration = 0
  echo wscript.sleep 100
  echo loop
  echo wscript.sleep (int(Sound.currentmedia.duration^)+1^)*1000) >soundpass.vbs
)

( echo Set Sound = CreateObject("WMPlayer.OCX.7"^)
  echo Sound.URL = "%USERPROFILE%\ProxyManager\proxydata-main\ERRORproxy.mp3"
  echo Sound.Controls.play
  echo do while Sound.currentmedia.duration = 0
  echo wscript.sleep 100
  echo loop
  echo wscript.sleep (int(Sound.currentmedia.duration^)+1^)*1000) >soundfail.vbs
)
echo Config Saved Successfully!
timeout 2 >nul
(
echo "%USERPROFILE%\ProxyManager\v2rayN-Core\v2rayN.exe"_"%HOMEDRIVE%\Program Files (x86)\Proxifier\Proxifier.exe"_"%USERPROFILE%\ProxyManager\proxydata-main\Gecho.exe"_"%USERPROFILE%\ProxyManager\proxydata-main\httping.exe"_"%USERPROFILE%\ProxyManager\proxydata-main\speedtest.exe"
)>config.sahi
goto :create

::#endregion
::#region manual selection
:setdir
cls
:setv
cls
echo We Recommended Automatic selection!
timeout 2 >nul
Echo Select v2rayN.exe Here!
set cmd=Add-Type -AssemblyName System.Windows.Forms;$f=new-object                 Windows.Forms.OpenFileDialog;$f.InitialDirectory=        [environment]::GetFolderPath('Desktop');$f.Filter='v2rayN(*.exe)^|*.exe^|All         Files(*.*)^|*.*';$f.Multiselect=$true;[void]$f.ShowDialog();if($f.Multiselect)        {$f.FileNames}else{$f.FileName}
set pwshcmd=powershell -noprofile -command "&{%cmd%}"
for /f "tokens=* delims=" %%I in ('%pwshcmd%') do call :sum1 "%%I" ret
pause
:sum1 
echo File Selected: "%~1"
set File1=%File1% "%~1"
set ret=%File1%

set /P o=   Do you want to proceed (Y/N)?
if /I "%o%" EQU "Y" goto :setp
if /I "%o%" EQU "N" goto :setv

:setp
cls 
Echo Select Proxifer.exe Here!
set cmd=Add-Type -AssemblyName System.Windows.Forms;$f=new-object                 Windows.Forms.OpenFileDialog;$f.InitialDirectory=        [environment]::GetFolderPath('Desktop');$f.Filter='Proxifer(*.exe)^|*.exe^|All         Files(*.*)^|*.*';$f.Multiselect=$true;[void]$f.ShowDialog();if($f.Multiselect)        {$f.FileNames}else{$f.FileName}
set pwshcmd=powershell -noprofile -command "&{%cmd%}"
for /f "tokens=* delims=" %%I in ('%pwshcmd%') do call :sum2 "%%I" ret

:sum2 
echo File Selected: "%~1"
set File2=%File2% "%~1"
set ret=%File2%
set /P o=   Do you want to proceed (Y/N)?
if /I "%o%" EQU "Y" goto :next
if /I "%o%" EQU "N" goto :setp


:next
cls
timeout 2 >nul
echo Select Proxy Manager folder directory here:

:: Run the code to select a folder
for /f "delims=" %%I in ('powershell -Command "Add-Type -AssemblyName System.Windows.Forms;$f=new-object Windows.Forms.FolderBrowserDialog;$f.SelectedPath = [Environment]::GetFolderPath('Desktop');[void]$f.ShowDialog();$f.SelectedPath"') do set "selectedFolder=%%I"

:: Specify the filenames to check
set "filesToCheck=effectfail.mp3 effectpass.mp3"

:: Check if all files exist in the selected folder
set "allFilesExist=true"
for %%F in (%filesToCheck%) do (
    if not exist "%selectedFolder%\%%F" (
        set "allFilesExist=false"
    )
)

:: Display the result
if %allFilesExist%==true (
    echo Requirements Satisfied! Folder Accepted.
    goto :finaldone
) else (
    echo Folder Rejected. Does not meet Requirements 
    goto  :next
)



:finaldone
@cd /d "%~dp0"
( echo Set Sound = CreateObject("WMPlayer.OCX.7"^)
  echo Sound.URL = "%selectedFolder%\effectpass.mp3"
  echo Sound.Controls.play
  echo do while Sound.currentmedia.duration = 0
  echo wscript.sleep 100
  echo loop
  echo wscript.sleep (int(Sound.currentmedia.duration^)+1^)*1000) >soundpass.vbs
)

( echo Set Sound = CreateObject("WMPlayer.OCX.7"^)
  echo Sound.URL = "%selectedFolder%\effectfail.mp3"
  echo Sound.Controls.play
  echo do while Sound.currentmedia.duration = 0
  echo wscript.sleep 100
  echo loop
  echo wscript.sleep (int(Sound.currentmedia.duration^)+1^)*1000) >soundfail.vbs
)
echo Config Saved Successfully!
timeout 2 >nul
(
echo %file1%_%file2%
)>config.sahi

::#endregion
::#region create extra files

:create
( echo Set WshShell = CreateObject^("WScript.Shell"^) 
  echo WshShell.Run chr^(34^) ^& "sptest.bat" ^& Chr^(34^), 0
  echo Set WshShell = Nothing) >sptest.vbs


(echo speedtest.exe -u MB/s  ^> restultspeed.sahi)>sptest.bat

@cd /d "%~dp0"
(
 echo set WshShell = WScript.CreateObject("WScript.Shell"^)
 echo strDesktop = WshShell.SpecialFolders("Desktop"^)
 echo wscript.echo(strDesktop^)
)>findDesktop.vbs



FOR /F "usebackq delims=" %%i in (`cscript findDesktop.vbs`) DO SET DESKTOPDIR=%%i
set TARGET='%USERPROFILE%\ProxyManager\proxydata-main\Proxy Manager.bat'
set SHORTCUT='%DESKTOPDIR%\ProxyManager.lnk'
set "ICONPATH=%USERPROFILE%\ProxyManager\proxydata-main\vpn.ico"
set PWS=powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile

%PWS% -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut(%SHORTCUT%); $S.TargetPath = %TARGET%; $S.IconLocation = '%ICONPATH%'; $S.WorkingDirectory = '%USERPROFILE%\ProxyManager\proxydata-main\'; $S.Save()"


::#endregion
::#region Find Existing applications
:resume
cls
tasklist /FI "IMAGENAME eq Proxifier.exe" 2>NUL | find /I /N "Proxifier.exe">NUL
if "%ERRORLEVEL%"=="1" goto start
set message=Searching For Applications
call :loading
timeout 2 >nul
goto :detected1

:detected1
cls
tasklist /FI "IMAGENAME eq v2rayN.exe" 2>NUL | find /I /N "v2rayN.exe">NUL
if "%ERRORLEVEL%"=="1" goto start
goto detectedfull

:detectedfull
cls
Echo Detected Existing Applications.
set message=Redirecting
call :loading
:choice
cls
:stopcome
:speedtestout
FOR /F "tokens=1-4 USEBACKQ" %%a IN (`findstr "Latency" restultspeed.sahi`) DO (
SET Latency=%%b %%c %%d
)
FOR /F "tokens=1-4 USEBACKQ" %%A IN (`findstr "Download" restultspeed.sahi`) DO (
SET DownSpeed=%%B %%C %%D
)

::#endregion
::#region MainMenu
color 07 & mode con:cols=98 lines=34
echo.  
echo.                                           
echo                   _______________________________________________________________
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|             	   	                                         ^|
if /I "%passfail%" == "0" call :nochoice
if /I "%passfail%" == "1" call :passchoice
if /I "%passfail%" == "2" call :failchoice  
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
call gecho "                 |      <Cyan>%Latency%               <Cyan>%DownSpeed%</>     |"
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^| 
call gecho "                 |      <%sbutton%>[1]<%start%> Activate Proxy (Recommended)        - SmartMode </>     |      "
echo                  ^|                                                               ^|
call gecho "                 |      <%rbutton%>[2]<%restart%> Activate Proxy (FORCED)           - Forced Mode </>     |   "
echo                  ^|                                                               ^|
call gecho "                 |      <%kbutton%>[3]<%kill%> Deactivate Proxy                - Make inactive  </>    |    "
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
call gecho "                 |      <Cyan>[4]</> Re-Check Proxy               <Cyan>[9]</> Re-Fresh Proxy      |"
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
call gecho "                 |      <Cyan>[5]</> Extras                              <Cyan>[7]</> Refresh      |"
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
call gecho "                 |      <Cyan>[6]</> Credits                                <Cyan>[8]</> Exit      |"
echo                  ^|                                                               ^|
echo                  ^|_______________________________________________________________^|
echo.          
choice /C:12345678 /N /t 10 /D 7 /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6,7,8] : "    


if errorlevel  8 goto :exit
if errorlevel  7 goto :choice
if errorlevel  6 goto :Credits
if errorlevel  5 goto :Extras
if errorlevel  4 goto :check
if errorlevel  3 goto :kill
if errorlevel  2 goto :forced
if errorlevel  1 goto :start
::#endregion
::#region SubMenu
:Extras
cls 
color 07 & mode con:cols=98 lines=34
echo:  
echo:                                           
echo                   _______________________________________________________________
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|             	   	                                         ^|
if /I "%passfail%" == "0" call :nochoice
if /I "%passfail%" == "1" call :passchoice
if /I "%passfail%" == "2" call :failchoice  
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^| 
call gecho "                 |     <yellow> Extras                                  <Cyan>[5] Go Back </>     |"
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^| 
call gecho "                 |      <Cyan>[1]</> Add a proxy Server                                   |"
echo                  ^|                                                               ^|
call gecho "                 |      <Cyan>[2]</> Check Download Speed                                 |"
echo                  ^|                                                               ^|
call gecho "                 |      <Cyan>[3]</> Mute Sounds                                          |"
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
call gecho "                 |      <red>[4]</> Re-Set Config                       <Cyan>[7]</> Refresh      |"
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
call gecho "                 |      <Cyan>[5]</> Home                     <Cyan>[8]</> Reset Sound config      |"
echo                  ^|      ___________________________________________________      ^| 
echo                  ^|                                                               ^|
call gecho "                 |      <Cyan>[6]</> Credits                                <Cyan>[9]</> Exit      |"
echo                  ^|                                                               ^|
echo                  ^|_______________________________________________________________^|
echo:          
choice /C:123456789 /N /t 5 /D 7 /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6,7,8,9] : "    

if errorlevel  9 goto :exit
if errorlevel  8 goto :soundy
if errorlevel  7 goto :Extras
if errorlevel  6 goto :Credits
if errorlevel  5 goto :choice
if errorlevel  4 goto :reset
if errorlevel  3 goto :Mute
if errorlevel  2 goto :DownSpeed
if errorlevel  1 goto :add


::#endregion
::#region WIP
:manualspeed
if  exist "speedtest.exe" (
  start sptest.vbs
 ) else (
Color 4F & MODE con:cols=80 lines=10
echo Files are missing to start the speedtest! Please download the files and place them in the same folder as this script.
timeout 3 >nul
goto :choice

:devmode
color 70  & mode con:cols=100 lines=15
echo Devmode
echo.
if /I "%d%" EQU "A" goto :devmode
cls
goto :devmode




:forced
cls
Color 3F & MODE con:cols=80 lines=7
echo Make sure to kill the proxy before exiting the script! 
timeout 2 >nul
set message=Initializing Proxy Applications
call :loading
timeout 1 >nul
TASKKILL /F /IM Proxifier.exe
TASKKILL /F /IM v2rayN.exe
call :startv
cd /d "%original_dir%"
call :regrun
cls
echo Deteminding the proxy state..
timeout 2 >nul
goto :networkcheck





::#endregion
::#region StartProxyApps
:Start
Color 3F & MODE con:cols=80 lines=7
TASKKILL /F /IM Proxifier.exe
TASKKILL /F /IM v2rayN.exe
cls
set message=Initializing Proxy Applications
call :loading
timeout 3 >nul
call :startall
:check
Color 3F & MODE con:cols=80 lines=7
cls
echo Deteminding the proxy state..
timeout 2 >nul
:retry
tasklist /FI "IMAGENAME eq v2rayN.exe" 2>NUL | find /I /N "v2rayN.exe">NUL
if "%ERRORLEVEL%"=="1" goto noded
goto :networkcheck

:noded
set MAX_ATTEMPTS=3
set CURRENT_ATTEMPT=0

:input_attempt
set /A CURRENT_ATTEMPT+=1


if %CURRENT_ATTEMPT% EQU %MAX_ATTEMPTS% (
     goto :start
     timeout 5 >nul
) else (
     echo Applications Launch timeout. Try Resetting the config.
     timeout 3 >nul
)






::#endregion
::#region NetworkCheck
:networkcheck
if exist "sptest.bat" (
    if exist "sptest.vbs" (
        goto :ok
    ) else goto :create
) else goto :create


:ok
if  exist "speedtest.exe" (
  start sptest.vbs
 ) else (
Color 4F & MODE con:cols=80 lines=10
echo Files are missing to start the speedtest! Please download the files and place them in the same folder as this script.
timeout 3 >nul

)
set "pass=^|"
if /I "%St%" == "0" set "count=3"
if /I "%St%" == "1" set "count=5"
if /I "%St%" == "2" set "count=3"
FOR /F "tokens=* USEBACKQ" %%F IN (`httping.exe -count %count% -url https://github.com`) DO (
SET var=%%F
SET "new=All probes failed"
)
if /I "%var%" == "%new%"  goto :failcheck
goto pass



:ping

cls
set /P c= type out a typo do like to ping?
color 0f & MODE con:cols=120 lines=25
@echo on
httping.exe -count 5 -url %c%
@echo off
pause
set "pass=^|"
C:
FOR /F "tokens=* USEBACKQ" %%F IN (`httping.exe -count 2 -url %c%`) DO (
SET var=%%F
SET "new=All probes failed"
)
if /I "%var%" == "%new%"  goto :failping
goto done

:done
@echo off
color 70  & mode con:cols=80 lines=10
cls
Echo Ping Sucuess! Redirecting to main menu..
timeout 3 >nul
goto :choice




:failping
@echo off
color 70  & mode con:cols=80 lines=10
cls
Echo Ping Failed or type a correct typo! Redirecting to main menu..
timeout 3 >nul
goto :choice

::#endregion
::#region Fails and Debugging

:failcheck
cls
echo Proxy Failed! Debugging In Progress!
Echo Requesting To Restarting The Proxy...
timeout 3 >nul
if /I "%St%" == "1" (
    cls
    echo Checking for problems with windows time
    net stop w32time
    w32tm /unregister
    w32tm /register
    net start w32time
    w32tm /resync
)
if /I "%St%" == "2"  goto :stop
TASKKILL /F /IM Proxifier.exe
TASKKILL /F /IM v2rayN.exe
call :startall
cls
echo Troubleshooting in progress..
timeout 3 >nul
SET /a "St+=1"
goto retry





:pass
color B0
cls
set /a "passfail=1"
call :soundscucess
echo Proxy Success! Redirecting to Menu
timeout 4 >nul
goto stopcome

::#endregion
::#region Extra Calls/Colors 

:passchoice
call gecho "                 |      <Green>PROXY MANAGER                        <blue>Status:<green> Active </>     |  "
SET "display=Active"
SET "color=green"

SET "start=White"
SET "kill=white"
SET "restart=White"
SET "kbutton=red"
SET "rbutton=Cyan"
SET "sbutton=DarkGray"



exit /B 0


:failchoice
call gecho "                 |      <Magenta>PROXY MANAGER                      <blue>Status:<red> Offline</>       |  "
SET "display=Offline"
SET "color=DarkRed"

SET "start=White"
SET "kill=White"
SET "restart=White"
SET "kbutton=DarkGray"
SET "rbutton=DarkGray"
SET "sbutton=Green"




exit /B 0


:nochoice
call gecho "                 |      <Magenta>PROXY MANAGER                          <blue>Status:<darkyellow> Idle </>     |"
SET "display=Not Detected"
SET "color=red"

SET "start=White"
SET "kill=White"
SET "restart=White"
SET "kbutton=DarkGray"
SET "rbutton=DarkGray"
SET "sbutton=Green"


exit /B 0






:Restart
cls
Color 4F & MODE con:cols=80 lines=10
Echo Requesting To Restarting The Proxy...
timeout 3 >nul
TASKKILL /F /IM Proxifier.exe
TASKKILL /F /IM v2rayN.exe
call :regkill
call :startall
Echo Success! Redirecting...
timeout 3 >nul
cls
goto :choice

:Kill
set /a "passfail=2"
cls
Color 4F & MODE con:cols=80 lines=10
Echo Requesting To Kill The Proxy...
timeout 3 >nul
call :regkill
TASKKILL /F /IM Proxifier.exe
TASKKILL /F /IM v2rayN.exe
cls
Echo Success! Redirecting...
timeout 3 >nul
cls
goto choice

:Exit
cls
Color 4F & MODE con:cols=80 lines=10
call :regkill
Echo Exiting The Script..
timeout 3 >nul
Exit

:add
cls
Color 4F & MODE con:cols=80 lines=10
call :startv
TASKKILL /F /IM Proxifier.exe
start "" "https://www.racevpn.com/free-vmesswebsocket-server"
echo Redirecting to weblink using your browser
timeout 3 >nul
cls
goto :loopstart



:loopstart
cls
echo Wating For A New Proxy Server.
echo Press any key after adding the server to V2ray..

    call :controlTimeout 5
    if errorlevel 1 ( 
		goto :loopstart
		
    ) else (
		goto :loopend
    )
	
	exit /b 
:controlTimeout 
    setlocal
    start "" /belownormal /b cmd /q /d /c "timeout.exe %~1 /nobreak > nul"
    timeout.exe %~1 & tasklist | find "timeout" >nul 
    if errorlevel 1 ( set "exitCode=0" ) else ( 
        set "exitCode=1"
        taskkill /f /im timeout.exe 2>nul >nul
    )
    endlocal 
endlocal & exit /b %exitCode%.
:loopend
cls
call :Restart
goto :check








:stop
set /a "passfail=2"
Color 4F & MODE con:cols=80 lines=10
Echo All Debugging Attemps Failed! 
Echo Try adding a new server to your Proxy
call :soundfail
timeout 5 >nul
cls
start "" "https://www.racevpn.com/free-vmesswebsocket-server"
TASKKILL /F /IM Proxifier.exe
goto :loopstart

:Restart
TASKKILL /F /IM Proxifier.exe
TASKKILL /F /IM v2rayN.exe
call :startall
exit /B 0


::#endregion
::#region config Vars

:startall
@cd /d "%~dp0"
for /f "tokens=1,2 delims=_" %%a in (config.sahi) do (
start "" %%a
start "" %%b
)
exit /B 0


:startv
@cd /d "%~dp0"
for /f "tokens=1,2 delims=_" %%a in (config.sahi) do (
start "" %%a
)
exit /B 0

:gecho
@cd /d "%~dp0"
for /f "tokens=1,2,3,4 delims=_" %%a in (config.sahi) do (
start "" %%c
)
exit /B 0


:soundscucess
@cd /d "%~dp0"
if not exist "%soundConfigFile%" (
    start /min soundpass.vbs
)
exit /B 0

:soundfail
@cd /d "%~dp0"
if not exist "%soundConfigFile%" (
start /min soundfail.vbs
)
exit /B 0

 
:reset
cls
Color 4F & MODE con:cols=80 lines=10
echo Resetting the configuration..
del config.sahi
timeout 5 >nul
goto :smartscan



:DownSpeed
cls
color 07 & mode con:cols=98 lines=34
@echo off
call speedtest.exe
pause
cls && goto :choice






:regrun
cls
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /t REG_SZ /d "localhost;127.*;10.*;172.16.*;172.17.*;172.18.*;172.19.*;172.20.*;172.21.*;172.22.*;172.23.*;172.24.*;172.25.*;172.26.*;172.27.*;172.28.*;172.29.*;172.30.*;172.31.*;192.168.*" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "127.0.0.1:10809" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f
exit /B 0


:regkill
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f
exit /B 0



:Mute
cls
Color 4F & MODE con:cols=80 lines=10
set /P e=   Do you want to Mute Sounds (Y/N)?
if /I "%e%" EQU "Y" goto :truesound
if /I "%e%" EQU "N" goto :falsesound

:truesound
cls
echo Sounds Muted..
timeout 2 >nul
(echo sound muted)>sound.config
goto :choice

:falsesound
cls
echo Sounds Unmuted..
timeout 2 >nul
del sound.config
goto :choice




:loading
rem Set the counter variable
set counter=0

:loopforload
set delay=200
set ms1counter=0
set ms2counter=0
set ms3counter=0
set ms4counter=0

:ms1
cls
echo (^>'-')^> ^| %message%.
ping 127.0.0.1 -n 1 -w %delay% > nul
set /a ms1counter = %ms1counter%+1
if %ms1counter% EQU 10  goto ms2

goto :ms1

:ms2
cls
echo ^<('-'^<) / %message%..
ping 127.0.0.1 -n 1 -w %delay% > nul
set /a ms2counter = %ms2counter%+1
if %ms2counter% EQU 10  goto ms3

goto :ms2

:ms3
cls
echo (^>'-')^> - %message%...
ping 127.0.0.1 -n 1 -w %delay% > nul
set /a ms3counter = %ms3counter%+1
if %ms3counter% EQU 10  goto ms4

goto :ms3

:ms4 
cls 
echo ^<('-'^<) \ %message%.... 
ping 127.0.0.1 -n 1 -w %delay% > nul 
set /a ms4counter = %ms4counter%+1 
if %ms4counter% EQU  10 goto :rest 

goto :ms4 

:rest 
cls 
rem Increment the counter 
set /a counter=%counter%+1 

rem Check if the counter has reached 20 
if %counter% LSS 5 goto loopforload 

exit /B 0 

::#endregion
::#region Credits
:Credits
cls
@for /f %%i in ('^<"%~f0" find/c /v ""') do @(
  for /f "delims=:" %%j in ('findstr/enc:"& :::::" "%~f0"') do @<"%~f0" (
   for /f %%k in ('forfiles /m "%~nx0" /c "cmd /c echo 0x08"') do @(
    for /l %%l in (1 1 %%i) do @(
     set x=& set/p x=&if %%l gtr %%j (
      if not defined x (echo.) else (
       if defined * (echo.) else (set *=*)
       for /f "delims=" %%m in ('cmd/u/v/c echo.!x!^| more^| findstr/n "^"') do @set y=%%m& (
        for /f "delims=" %%n in ('cmd/v/c echo."!y:*:=!"') do @<nul (
         if %%n neq " " (if %%n neq "=" (set/p=%%n) else (set/p=.%%k=)) else (set/p=.%%k %)
         >nul ping -n 1 -w 100 ""
        )
       )
      )
     )
    )
   )
  )
 )
@pause>nul& goto :choice& :::::

                                          PROXY MANAGER V2.12

                THIS IS AN ADVANCED SCRIPT THAT I WROTE TO AUTOMATE THE SETUP OF PROXY.
                IT MAY CONTAIN FAULTS SINCE IT IS STILL IN THE DEVELOPMENT STAGE.

                Support: gsahindu@gmail.com (Paypal/Email)
                Contact: https://discord.gg/h9DTvDM  (Discord Server)
                

                                            SAHINDU GAYANUKA
                                      ========================
                                              SAHIDEMON
                                          END OF CREDITS.
::#endregion
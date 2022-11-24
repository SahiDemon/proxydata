@echo off
@setlocal enableextensions
@cd /d "%~dp0"
SET /a "St=0"
SET /a "passfail=0"
Color 3F & MODE con:cols=80 lines=7
title Proxy Manager
echo Configuring The Proxy..
cd var
if exist config.sahi goto loadtrue
if not exist config.sahi goto loadfail

:loadfail
cls
echo Folder does not exist the configuration. Redirecting To Selection
timeout 3 >nul
goto :setdir

:loadtrue
cls
for /f "tokens=1,2,3,4 delims=_" %%a in (config.sahi) do (
echo Config Loaded Successfully!
)
goto :resume

:setdir
cls
:setv
cls 
Echo Drag ^& Drop v2rayN.exe Here!
set /p file1="Enter the file path for v2rayN : "
cls
echo v2rayN.exe="%file1%"
set /P o=   Do you want to proceed (Y/N)?
if /I "%o%" EQU "Y" goto :setp
if /I "%o%" EQU "N" goto :setv

:setp
cls 
Echo Drag ^& Drop Proxifier.exe Here!
set /p file2="Enter the file path Proxifier: "
cls
echo Proxifier.exe="%file2%"
set /P o=   Do you want to proceed (Y/N)?
if /I "%o%" EQU "Y" goto :soundy
if /I "%o%" EQU "N" goto :setp


:soundy
cls 
Echo Drag ^& Drop "Success" Sound Effect Here!
set /p file3="Enter the file path for Success Sound : "
cls 
Echo Drag ^& Drop "Failed" Sound Effect Here!
set /p file4="Enter the file path for Failed Sound : "
cls
echo "Success" Sound Effect="%file3%"
echo "Failed" Sound Effect="%file4%"
set /P o=   Do you want to proceed (Y/N)?
if /I "%o%" EQU "Y" goto :finaldone
if /I "%o%" EQU "N" goto :soundy



:finaldone
@cd /d "%~dp0"
( echo Set Sound = CreateObject("WMPlayer.OCX.7"^)
  echo Sound.URL =%file3%
  echo Sound.Controls.play
  echo do while Sound.currentmedia.duration = 0
  echo wscript.sleep 100
  echo loop
  echo wscript.sleep (int(Sound.currentmedia.duration^)+1^)*1000) >soundpass.vbs
)

( echo Set Sound = CreateObject("WMPlayer.OCX.7"^)
  echo Sound.URL =%file4%
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



:resume
timeout 3 >nul
cls
tasklist /FI "IMAGENAME eq Proxifier.exe" 2>NUL | find /I /N "Proxifier.exe">NUL
if "%ERRORLEVEL%"=="1" goto start
Echo Searching For Applications..
timeout 2 >nul
goto :detected1

:detected1
cls
tasklist /FI "IMAGENAME eq v2rayN.exe" 2>NUL | find /I /N "v2rayN.exe">NUL
if "%ERRORLEVEL%"=="1" goto start
goto detectedfull

:detectedfull
cls
Echo Detected Existing Applications. Redirecting...
timeout 3 >nul
color 70  & mode con:cols=80 lines=12
:choice
color 70  & mode con:cols=100 lines=12
cls
:stopcome
color 70  & mode con:cols=100 lines=15
if /I "%passfail%" == "0" call :nochoice
if /I "%passfail%" == "1" call :passchoice
if /I "%passfail%" == "2" call :failchoice
echo.
call :setESC
echo %ESC%[7mEnter Following As You Prefered%ESC%[0m
echo %ESC%.%ESC%[0m
echo %ESC%[7mStart The Proxy            = S%ESC%[0m
echo %ESC%[7mAdd A Proxy Server         = A%ESC%[0m
echo %ESC%[7mCheck the Proxy            = C%ESC%[0m
echo %ESC%[7mCheck the Ping             = P%ESC%[0m
echo %ESC%[7mRestart The Proxy          = R%ESC%[0m
echo %ESC%[7mKill The Proxy             = K%ESC%[0m
echo %ESC%[7mReset The Config File      = X%ESC%[0m
echo %ESC%[7mReset The Sound effects    = XS%ESC%[0m
echo %ESC%[7mExit The Script            = E%ESC%[0m
echo.
set /P c=         %ESC%[7mWhat Do You Want To Execute [S/A/C/P/R/K/X/XS/E]?%ESC%[0m
if /I "%c%" EQU "S" goto :Start
if /I "%c%" EQU "C" goto :check
if /I "%c%" EQU "P" goto :ping
if /I "%c%" EQU "R" goto :Restart
if /I "%c%" EQU "K" goto :Kill
if /I "%c%" EQU "E" goto :Exit
if /I "%c%" EQU "X" goto :reset
if /I "%c%" EQU "XS" goto :soundy
if /I "%c%" EQU "A" goto :add
echo Try Again Using  [Start/Check/Ping/Restart/Kill/Exit]type = [S/R/C/P/K/E]
goto :choice


:Start
Color 3F & MODE con:cols=80 lines=7
TASKKILL /F /IM Proxifier.exe
TASKKILL /F /IM v2rayN.exe
cls
Echo Requesting The Applications To Initiate The Proxy..
timeout 3 >nul
call :startall
timeout 3 >nul
:check
Color 3F & MODE con:cols=80 lines=7
cls
Echo Checking Proxy State..
timeout 2 >nul
:retry
tasklist /FI "IMAGENAME eq Proxifier.exe" 2>NUL | find /I /N "Proxifier.exe">NUL
if "%ERRORLEVEL%"=="1" goto noded
goto :networkcheck

:noded
cls
echo Applications Not Detected! holding
timeout 5 >nul
goto start


:networkcheck
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

:passchoice
call :setESC
echo %ESC%[46mProxy Status%ESC% %ESC%[30m :%ESC%[0m%ESC%[42mActive%ESC%[0m
:setESC
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
  exit /B 0
)

:failchoice
call :setESC
echo %ESC%[46mProxy Status%ESC% %ESC%[30m :%ESC% %ESC%[101;93m Offline %ESC%[0m
:setESC
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
  exit /B 0
)

:nochoice
call :setESC
echo %ESC%[46mProxy Status%ESC% %ESC%[30m :%ESC% %ESC%[97m Not defined%ESC%[0m
:setESC 
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
  exit /B 0
)




:Restart
cls
Color 4F & MODE con:cols=80 lines=10
Echo Requesting To Restarting The Proxy...
timeout 3 >nul
TASKKILL /F /IM Proxifier.exe
TASKKILL /F /IM v2rayN.exe
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
TASKKILL /F /IM Proxifier.exe
TASKKILL /F /IM v2rayN.exe
Echo Success! Redirecting...
timeout 3 >nul
cls
goto choice

:Exit
cls
Color 4F & MODE con:cols=80 lines=10
Echo Exiting The Script. GG!
timeout 3 >nul
Exit

:add
cls
Color 4F & MODE con:cols=80 lines=10
call :startv
TASKKILL /F /IM Proxifier.exe
start "" "https://www.fastssh.com/page/create-v2ray-account/server/676739/v2ray-singapore-amp/"
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
start "" "https://www.fastssh.com/page/create-v2ray-account/server/676739/v2ray-singapore-amp/"
TASKKILL /F /IM Proxifier.exe
goto :loopstart

:Restart
TASKKILL /F /IM Proxifier.exe
TASKKILL /F /IM v2rayN.exe
call :startall
exit /B 0





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


:soundscucess
@cd /d "%~dp0"
start /min soundpass.vbs
exit /B 0

:soundfail
@cd /d "%~dp0"
start /min soundfail.vbs
exit /B 0

 

:reset
cls
Color 4F & MODE con:cols=80 lines=10
echo Resetting the configuration..
del config.sahi
timeout 5 >nul
goto :setdir
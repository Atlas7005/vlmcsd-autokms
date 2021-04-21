@ECHO OFF
 
CD %~dp0
 
ECHO [vlmscd: Windows Activator]
ECHO:
 
:: Check admin privileges
NET SESSION >nul 2>&1
IF NOT %ERRORLEVEL% EQU 0 (
    ECHO You must run the installer as an admin!
    PAUSE > nul
    EXIT
)
 
IF NOT EXIST "%ProgramFiles%\TAP-Windows" (
	ECHO Installing TAP Driver...
	bin\tap-windows-installer.exe
)
 
ECHO Installing the KMS (Key Management Service) service
bin\vlmcsd.exe -s -U /n -O .=192.168.123.1/24
 
ECHO Adding firewall exception
NETSH advfirewall firewall add rule name="vlmcsd" dir=in action=allow program=%~dp0bin\vlmcsd.exe enable=yes
 
ECHO Starting vlmcsd service
NET START vlmcsd
 
START notepad Keys.txt
SET /p kmsKey=Enter a valid key for your Windows edition:
ECHO Installing key...
slmgr /ipk %kmsKey%
ECHO Setting up KMS address...
slmgr /skms 192.168.123.2
ECHO Sending activation request...
slmgr /ato
ECHO All done! Press enter to exit.
PAUSE > nul
 
EXIT
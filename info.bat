@echo off
color 1f
chcp 65001 >nul

:menu
cls
echo Script shows important pc information
echo 1. System
echo 2. Network
echo 3. Save Report
echo 4. Exit

set /p choice=Enter your choice: 

if "%choice%"=="1" ( call :system )
if "%choice%"=="2" ( call :network_submenu )
if "%choice%"=="3" ( call :save_report )
if "%choice%"=="4" ( exit && msg * stay focused )

:system
cls
echo System Information:
wmic computersystem get manufacturer,model,name,systemtype,username /format:table || echo Error: Unable to retrieve system information.

echo.
echo BIOS Information:
wmic bios get manufacturer,name,serialnumber,version /format:table || echo Error: Unable to retrieve BIOS information.

echo.
echo Processor Information:
wmic cpu get description,manufacturer,name,maxclockspeed /format:table || echo Error: Unable to retrieve processor information.

echo.
echo Memory Information:
wmic memorychip get capacity,manufacturer,partnumber,speed /format:table || echo Error: Unable to retrieve memory information.

echo.
echo Disk Information:
wmic diskdrive get model,size /format:table || echo Error: Unable to retrieve disk information.

pause
goto menu

:network_submenu
cls
echo.
echo 1. Network Information
echo 2. Show Saved Passwords
echo 3. Back to Network Menu

set /p network_choice=Enter your choice: 

if "%network_choice%"=="1" (
    cls
    echo Network Information:
    ipconfig /all || echo Error: Unable to retrieve network information.
    pause
    goto network_submenu
)
if "%network_choice%"=="2" (
    cls
    netsh wlan show profiles
    set /p profile_name=Enter profile name: 
    netsh wlan show profile name="%profile_name%" key=clear || cls && echo Error: Unable to retrieve password for the specified profile.
    pause
    goto network_submenu
)
if "%network_choice%"=="3" goto menu

:save_report
cls
echo Saving report to PC_INFO.txt...
echo System Information: >> PC_INFO.txt
wmic computersystem get manufacturer,model,name,systemtype,username /format:table >> PC_INFO.txt
echo. >> PC_INFO.txt
echo BIOS Information: >> PC_INFO.txt
wmic bios get manufacturer,name,serialnumber,version /format:table >> PC_INFO.txt
echo. >> PC_INFO.txt
echo Processor Information: >> PC_INFO.txt
wmic cpu get description,manufacturer,name,maxclockspeed /format:table >> PC_INFO.txt
echo. >> PC_INFO.txt
echo Memory Information: >> PC_INFO.txt
wmic memorychip get capacity,manufacturer,partnumber,speed /format:table >> PC_INFO.txt
echo. >> PC_INFO.txt
echo Disk Information: >> PC_INFO.txt
wmic diskdrive get model,size /format:table >> PC_INFO.txt
echo. >> PC_INFO.txt
echo Network Information: >> PC_INFO.txt
ipconfig /all >> PC_INFO.txt
echo. >> PC_INFO.txt
echo Firewall Information: >> PC_INFO.txt
powershell -Command "Get-NetFirewallProfile | Select Name,Enabled" >> PC_INFO.txt
echo.
netsh wlan show profile * key=clear >> PC_INFO.txt
echo Report saved to PC_INFO.txt.
pause
goto menu

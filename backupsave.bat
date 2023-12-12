@echo off

echo Changing directory
cd /d %~dp0

echo Setting variables

:: The directory of your honour mode save game 
set "backupDir=SAVE DIRECTORY HERE"
echo 	backupDir = %backupDir%

:: The path to WinRAR, if you have 7zip instead ignore this
set "rarPath=C:\Program Files\WinRAR\Rar.exe"
echo 	rarPath = %rarPath%

:: The path to 7zip
set "szPath=C:\Program Files\7-Zip\7z.exe"
echo 	szPath = %szPath%

:: Set this variable to true if you want to use WinRAR
set useWinRAR=false

:: The filename you wish to use for backup, you don't need to change this
if %useWinRAR%==true set "fileName=%cd%HonourMode.rar"
if %useWinRAR%==false set "fileName=%cd%HonourMode.7z"
echo 	fileName = %fileName%

:MENU
set input=false
set "backupOrRestore=3"

echo +===============================================+
echo . BATCH SCRIPT - USER MENU                      .
echo +===============================================+
echo .                                               .
echo .  1) BACKUP                                    .
echo .  2) RESTORE                                   .
echo .  3) EXIT                                      .
echo .                                               .
echo +===============================================+

set /P "backupOrRestore=>"

if %backupOrRestore%==1 goto BACKUP
if %backupOrRestore%==2 goto RESTORE
if %backupOrRestore%==3 exit /b
if %input%==false exit /b

:BACKUP

cls
echo Deleting %fileName% if it exists
if exist %fileName% del %fileName%

echo Compressing %backupDir% to %fileName%
if %useWinRAR%==true (
	start "" "%rarPath%" a -r -ep "%fileName%" "%backupDir%"
) else (
	start "" "%szPath%" a -t7z "%fileName%" "%backupDir%"/*
)

goto MENU

:RESTORE

cls
if not exist %fileName% (
	echo %fileName% does not exist, exiting
	exit /b
	)
	
echo Extracting %fileName% to %backupDir% and overwriting
if %useWinRAR%==true (
	start "" "%rarPath%" x -o+ "%fileName%" "%backupDir%"
) else (
	start "" "%szPath%" e "%fileName%" -y -o"%backupDir%"
)

goto MENU
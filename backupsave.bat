@echo off

echo Changing directory
cd /d %~dp0

echo Setting variables

:: The directory of your honour mode save game
:: Default save directoroy location is %LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\Savegames\Story
:: The one you're looking for is probably the most recently modified
set "backupDir=PUT SAVE DIRECTORY HERE"
echo 	backupDir = %backupDir%

:: Set this to true if you don't want to use compression
set useCompression=true
echo 	useCompression = %useCompression%

:: If you disabled compression above, feel free to ignore the rest of the settings

:: The path to WinRAR "Rar.exe", if you have 7zip ignore this
set "rarPath=C:\Program Files\WinRAR\Rar.exe"
echo 	rarPath = %rarPath%

:: The path to 7zip "7z.exe"
set "szPath=C:\Program Files\7-Zip\7z.exe"
echo 	szPath = %szPath%

:: Set this variable to true if you want to use WinRA
set useWinRAR=false

:: The filename you wish to use for backup, you don't need to change this unless you want to
if %useWinRAR%==true (
	set "fileName=%cd%HonourMode.rar"
	set "fileBackup=%cd%HonourMode_PreviousSave.rar"
) else (
	set "fileName=%cd%HonourMode.7z"
	set "fileBackup=%cd%HonourMode_PreviousSave.7z"
)
echo 	fileName = %fileName%
echo 	fileBackup = %fileBackup%

:MENU
set input=false
set "backupOrRestore=3"

echo +===============================================+
echo . Quick Save Backup Script                      .
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

if %useCompression%==false (
	echo Compression disabled, copying HonourMode.lsv and HonourMode.WebP to %cd%
	copy "%backupDir%\HonourMode.lsv" "HonourMode.lsv"
	copy "%backupDir%\HonourMode.WebP" "HonourMode.WebP"
	goto MENU
)

if exist %fileName% (
	echo Copying %fileName% to %fileBackup%
	copy "%fileName%" "%fileBackup%"
	del "%fileName%"
)

echo Compressing %backupDir% to %fileName%
if %useWinRAR%==true (
	start "" "%rarPath%" a -r -ep "%fileName%" "%backupDir%"
) else (
	start "" "%szPath%" a -t7z "%fileName%" "%backupDir%"/*
)

goto MENU

:RESTORE

cls

if %useCompression%==false (
	echo Compression disabled, copying HonourMode.lsv and HonourMode.WebP to %backupDir%
	copy "HonourMode.lsv" "%backupDir%\HonourMode.lsv"
	copy "HonourMode.WebP" "%backupDir%\HonourMode.WebP"
	goto MENU
)

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
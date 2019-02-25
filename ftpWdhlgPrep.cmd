::
:: This Windows Batch script can scan a specific folder by isoweek and prepare the files with ID3 tag and mp3gain for playout.
::
:: @package     
:: @license     http://www.gnu.org/licenses/agpl.html AGPL Version 3
:: @author      Malte Schroeder <post@malte-schroeder.de>
:: @copyright   Copyright (c) 2011-2019 Malte Schroeder (http://www.malte-schroeder.de)
::

@echo off
setlocal enabledelayedexpansion
:setting
set _ver=1.0.0
set _offset=100-100
set _houroffset=0
if not "%1"=="" set _offset=%1
if not "%2"=="" set _houroffset=%2
::set _wdharchiv=S:\m\MP3\Archiv\Wiederholungen
set _id3set=%~dp0WdhlgID3Parser.cmd
set _gainer=%~dp0gain.cmd
set _gainlog=S:\log\MP3Gain
title %~nx0 Version %_ver%

call .\GetAllDateTimeInfos.cmd /s /q
if %DoW%==1 set _offset=%_offset%-1
set /a _kw=1%kw%+%_offset%-100
set /a _year=%YY%
set "_day=%cDoW%"
echo title %~nx0 Version %_ver% %_year% KW%_kw% %_day%

call .\GetAllDateTimeInfos.cmd /u /q

set _mp3path=S:\ftp\AufgenommeneSendungen\%_year%

if [%_mp3path%] == [] title %~nx0 Version %_ver% mp3path ERROR && goto error

:start
echo on
for /R %_mp3path% %%i IN (\KW%kw%\*.mp3) do call :parse "%%~ni" "%%~di%%~pi%%~ni"

call %_id3set% %_mp3path%\KW%_kw%
call %_gainer% %_mp3path%\KW%_kw%\ >> %_gainlog%\%_date%.log


goto ende
:error

echo Fehler: siehe Titel, Malte fragen.
pause


:ende

endlocal


ping 127.0.0.1 > NUL
pause
exit

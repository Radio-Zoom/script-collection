::
:: This Windows Batch script can pass files to mp3gain command line utility.
::
:: @package     
:: @license     http://www.gnu.org/licenses/agpl.html AGPL Version 3
:: @author      Malte Schroeder <post@malte-schroeder.de>
:: @copyright   Copyright (c) 2011-2019 Malte Schroeder (http://www.malte-schroeder.de)
::
@echo on & setlocal
:setting
set _gainerver=1.0.6
set _mp3gain=%~dp0..\tools\mp3gain.exe
set _GainTarget=%1
set _blat=.%~dp0..\tools\blat.exe
if "%_GainTarget%" == "" goto error

:start

for /R "%_GainTarget%" %%i IN (*.mp3) DO call :gain "%%i"
goto mailnotify

:error
echo --------------------------------------------------------------------
echo //	Radio-Zoom unattended MP3GAINr  %_gainerver%             //
echo //              (C) 2010-2017 by Malte                            //
echo //         Use like   gain   {drive:path\to\mp3\files}            //
echo //                                                                //
echo --------------------------------------------------------------------
pause
cls
goto ende

:gain
"%_mp3gain%" /r /c %1 


set _mp3gainfehler=%errorlevel%
goto :eof

:mailnotify
if [%_mp3gainfehler%] GTR [0] %_blat% -startls -authc -t my-admin-mail@best-webradio-in-the-world.de -smtp my-smtp-server.de -port 25 -user mysmtpusername -pass Supers3curep4ssw0rd -f the-email-i-sent-from@best-webradio-in-the-world.de -sub "mAirList Meldung: MP3Gain FEHLER!!" -body "Beim MP3Gain fuer %_GainTarget% ist ein Fehler aufgetreten. Fehlerlevel war: %_mp3fehler%     %date% %time% gain.cmd: %_gainver%"

:ende
endlocal
exit

::
:: This Windows Bathch script can download files via webdav from remote locations and put them into specific folders on the local computer.
::
:: @package     
:: @license     http://www.gnu.org/licenses/agpl.html AGPL Version 3
:: @author      Malte Schroeder <post@malte-schroeder.de>
:: @copyright   Copyright (c) 2011-2019 Malte Schroeder (http://www.malte-schroeder.de)
::

@echo off
:setting
set _ver=0.1.7
set _show=%1
set _robo=..\tools\robocopy.exe
set _blat=..\tools\mailsend.exe
set _gainer=%~dp0gain.cmd
set _unzipper=%~dp0unzip.cmd
set _srv=https://webdav.mydrive.ch
set _srvpath=
set _trgtdrv=m:
set _trgtdir=\Malte-TEST\ftp-test
set _dirprefix=\Mp3\Vorproduktionen
set _log=S:\log\scripts
set _auth=
call %~dp0GetAllDateTimeInfos.cmd /s /q
set _kw=%KW%
call .%~dp0GetAllDateTimeInfos.cmd /u /q
echo Aktuelle Woche KW%_kw%


:start
if "%_show%" == "" goto error
goto %_show%




:schlagerrallye
set _user=username
set _pass=G4ns-S1cher
set _srv=https://webdav.mydrive.ch
set _srvpath=Schlager Rallye Sendungen
set _trgtdir=%_dirprefix%\SchlagerRallye\
goto download



:error
echo --------------------------------------------------------------------
echo //     Radio-Zoom Webdav Downloader (C) 2014 - 2018 by Malte      //
echo //                                                                //
echo //            Use like   webdavdown {showname}                    //
echo //                                                                //
echo // Currently available shows:                                     //
echo //                                                                //
echo //   schlagerrallye                                               //
echo --------------------------------------------------------------------
pause
cls
goto ende

:download
net use z: %_srv% /user:%_user% %_pass%
echo on
"%_robo%" "z:\%_srvpath%" %_trgtdrv%%_trgtdir% /XO
call %_unzipper% %_trgtdrv%%_trgtdir% >> "%_log%\unzip%date%.log"
call %_gainer% %_trgtdrv%%_trgtdir% >> "%_log%\mp3gain%date%.log"


:mailnotify
%_blat% -startls -authc -t admin@my-rad.io -smtp mailserver-whatever.de -port 25 -user Username -pass 3Mail-P4ssw0rd -f noreply@my-rad.io -sub "mAirList Meldung: webdav Download auf %computername%" -M "webdav Download fuer %_show% KW%_kw% sollte erledigt sein. %date% %time%, Server: %computername%"

:ende
net use z: /delete
exit

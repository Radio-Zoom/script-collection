@echo off
:setting
set _Ver=0.2.9
set _show=%1
set _wget=..\tools\wget.exe
set _blat=..\tools\mailsend.exe
set _gainer=%~dp0gain.cmd
set _id3set=%~dp0WdhlgID3Parser.cmd
set _srv=ftp://ftp.radio-zoom.de
set _srvpath=
set _trgtdrv=m:
set _trgtdir=\Malte-TEST\ftp-test
set _dirprefix=\MP3\Vorproduktionen
set _log=S:\log\scripts
set _auth=
call %~dp0GetAllDateTimeInfos.cmd /s /q
set _kw=%KW%
call %~dp0GetAllDateTimeInfos.cmd /u /q
echo Aktuelle Woche KW%_kw%


:start
if "%_show%" == "" goto error
title Radio-Zoom FTP Downloaeder %_Ver%
goto %_show%
::%_wget% --help

:download1
set _srv=ftp://servername.de
set _auth=--ftp-user=yourusername --ftp-password=very-secure
set _srvpath=/download1
set _trgtdir=%_dirprefix%\download1
set _options=-l 0 -nc -r -nd -P %_trgtdrv%%_trgtdir% -a %_log%\download1%date%.log
goto download

:shownamexy
set _srv=ftp://server2name.com
set _auth=--ftp-user=anotherusername --ftp-password=S1ll-S3cure
set _srvpath=/shownamexy
set _trgtdir=%_dirprefix%\shownamexy
set _options=-l 0 -nc -r -nd -P %_trgtdrv%%_trgtdir% -a %_log%\shownamexy%date%.log
goto download


:wdh
set _dirprefix=
set _srv=ftp://ftp.radio-zoom.de
set _auth=--ftp-user=Username --ftp-password=OneM0r3-P4ssw0rd
set _srvpath=/AufgenommeneSendungen
set _trgtdir=%_dirprefix%\wdh
set _options=-l 0 -nH -nc -r -P %_trgtdrv%%_trgtdir% -a %_log%\wdh%date%.log
goto download


:error
echo --------------------------------------------------------------------
echo //       RadioZoom FTP Downloader (C) 2011-2018 by Malte          //
echo //            Version: %_ver%                                //
echo //              Use like   ftpcmd {showname}                      //
echo //                                                                //
echo // Currently available shows:                                     //
echo //                                                                //
echo //   download1                                                    //
echo //   shownamexy                                                   //
echo //   wdh                                                          //
echo --------------------------------------------------------------------
pause
cls
goto ende

:download
echo ftp_cmd Version %_ver%


%_wget% %_auth% %_options% %_srv%%_srvpath%
set _fehler=%errorlevel%
title Radio-Zoom FTP Downloaeder %_Ver%
:mailnotify
if [%_fehler%] GTR [0] %_blat% -to admin@my-rad.io -server mailserver-whatever.de -u Username -pw 3Mail-P4ssw0rd -f noreply@my-rad.io -subject "mAirList Meldung: ftp Download FEHLER!!" -body "Beim ftp Download fuer %_show% KW%_kw% ist ein Fehler aufgetreten. %date% %time%     Fehlerlevel war: %_fehler%        ftpcmd Version: %_ver%  Auf Server: %COMPUTERNAME%"
if [%_show%] == [wdh] call %_id3set% %_trgtdir%\%_srvpath%\KW%_kw%\ && title Set ID3 Tag
title MP3gaining Radio-Zoom FTP Downloaeder %_Ver% MP3GAIN
call %_gainer% %_trgtdrv%%_trgtdir% >> "%_log%\%date%.log"


:ende
exit

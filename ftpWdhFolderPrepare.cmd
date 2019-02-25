@echo off
setlocal enabledelayedexpansion
:setting
set _ver=1.1.0
set _mp3path=S:\ftp\AufgenommeneSendungen
set _offset=0
if not "%1"=="" set _offset=%1
title %~nx0 Version %_ver%
call .\GetAllDateTimeInfos.cmd /s

if not "%_offset%"=="" (
	set /a _kw=1%kw%+%_offset%-100
	) else (
	echo.
	echo Bitte Kalenderwoche eingeben, die erstellt werden soll.
	echo.
	set /p _kw=Nur Zahlen, kein vorangestelltes KW: 
	)

set /a _year=%YY%
if %_kw% LSS %OSKW% (
	echo Kalenderwoche KW%_kw% naechstes Jahr
	ping 127.0.0.1 > NUL
	set /a _year=%_year%+1
	echo Jahr auf !_year! geaendert
	)

	


call .\GetAllDateTimeInfos.cmd /s /q

:start
if not exist "%_mp3path%\%_year%\KW%_kw%" (
	title %~nx0 Version %_ver% KW%_kw%
	md "%_mp3path%\%_year%\KW%_kw%"
	if not %errorlevel%==0 goto error
	for %%D IN (MO,DI,MI,DO,FR,SA,SO) DO (
		title %~nx0 Version %_ver% KW%_kw% %%D
		md "%_mp3path%\%_year%\KW%_kw%\%%D"
		if not %errorlevel%==0 goto error
		for %%H IN (07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23) DO (
			title %~nx0 Version %_ver% KW%_kw% %%D %%H
			md "%_mp3path%\%_year%\KW%_kw%\%%D\%%H"	
			if not %errorlevel%==0 goto error
			)
		)
	)


goto ende
:error

echo Fehler! Info muss noch ausgebaut werden, Malte fragen.
pause


:ende

endlocal


ping 127.0.0.1 > NUL
exit

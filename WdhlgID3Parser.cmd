@echo off
setlocal enabledelayedexpansion
:setting
set _taggerver=0.0.6
set _tagger=..\tools\id3.exe
set _mp3path=%1
if [%_mp3path%] == [] goto error

:start
for /R %_mp3path% %%i IN (*.mp3) do call :parse "%%~ni" "%%~di%%~pi%%~ni"


goto ende
:error

echo fehler, info muss noch ausgebaut werden, Malte fragen.
pause
goto ende

:parse

	for /f "delims=_ tokens=1-6" %%k in (%1) do ( 
		set "_datum=%%k"
		set "_time=%%l"
		set "_mod=%%m"
		set "_sendung=%%n"
		set "_marker=%%o"
		set "_jahr=!_datum:~0,4!"
		set "_monat=!_datum:~5,2!"
		set "_tag=!_datum:~8,2!"
	)

echo.	
echo Datum %_datum%
echo Jahr: %_jahr%
echo Monat: %_monat%
echo Tag: %_tag%

echo Zeit %_time%
echo Moderator %_mod%
echo Sendung %_sendung%
echo Marker %_marker%
echo file: %2
echo.


%_tagger% -1 -2 -d %2.mp3
if "%_marker%" == "VP" (
		%_tagger% -2 -a "%_mod%" -t "%_sendung% am %_tag%.%_monat%.%_jahr%" -s "100" -v %2.mp3
	) else (
		%_tagger% -2 -a "%_mod%" -t "%_sendung% vom %_tag%.%_monat%.%_jahr% Wdhlg." -s "100" -v %2.mp3
	)
	
echo errorlevel:%errorlevel%	

set "_datum="
set "_time="
set "_mod="
set "_sendung="
set "_marker="
set "_jahr="
set "_monat="
set "_tag="

goto :eof

:ende
endlocal
exit

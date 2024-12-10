@echo off
:: Skript zur Änderung des Computernamens basierend auf der Seriennummer

:: Temporäre Dateien für die Auswertung
set "tempfile=%TEMP%\currentname.txt"
set "serialfile=%TEMP%\serialnumber.txt"

:: Aktuellen Computernamen auslesen
for /f "tokens=*" %%A in ('wmic computersystem get name /value ^| find "="') do set "CurrentName=%%A"
set "CurrentName=%CurrentName:~5%"  :: Überspringt "Name=" und extrahiert den Namen

:: Präfix (z. B. "NBNRH-") extrahieren
for /f "delims=-" %%A in ("%CurrentName%") do set "Prefix=%%A"

:: Seriennummer auslesen
for /f "tokens=*" %%A in ('wmic bios get serialnumber /value ^| find "="') do set "SerialNumber=%%A"
set "SerialNumber=%SerialNumber:~13%" :: Überspringt "SerialNumber="

:: Prüfen, ob alle Informationen vorhanden sind
if "%Prefix%"=="" (
    echo Fehler: Präfix konnte nicht ausgelesen werden!
    pause
    exit /b 1
)

if "%SerialNumber%"=="" (
    echo Fehler: Seriennummer konnte nicht ausgelesen werden!
    pause
    exit /b 1
)

:: Neuer Name erstellen
set "NewName=%Prefix%-%SerialNumber%"

:: Computernamen ändern
echo Neuer Computername: %NewName%
wmic computersystem where name="%CurrentName%" call rename name="%NewName%"

if %errorlevel%==0 (
    echo Der Computername wurde erfolgreich geändert!
) else (
    echo Fehler beim Ändern des Computernamens.
)

:: Bereinigung temporärer Dateien
if exist "%tempfile%" del "%tempfile%"
if exist "%serialfile%" del "%serialfile%"

pause
exit /b 0

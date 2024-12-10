@echo off
:: Skript zur Änderung des Computernamens auf NBZGH-{SERIEN No.}

:: Seriennummer auslesen
for /f "tokens=*" %%A in ('wmic bios get serialnumber /value ^| find "="') do set "SerialNumber=%%A"
set "SerialNumber=%SerialNumber:~13%" :: Überspringt "SerialNumber="

:: Prüfen, ob die Seriennummer erfolgreich ausgelesen wurde
if "%SerialNumber%"=="" (
    echo Fehler: Seriennummer konnte nicht ausgelesen werden!
    exit /b 1
)

:: Neuen Namen generieren
set "NewName=NBZGH-%SerialNumber%"

:: Aktuellen Computernamen auslesen
for /f "tokens=*" %%A in ('wmic computersystem get name /value ^| find "="') do set "CurrentName=%%A"
set "CurrentName=%CurrentName:~5%" :: Überspringt "Name="

:: Computernamen ändern
echo Neuer Computername: %NewName%
wmic computersystem where name="%CurrentName%" call rename name="%NewName%"

:: Erfolgsmeldung prüfen
if %errorlevel%==0 (
    echo Der Computername wurde erfolgreich zu %NewName% geändert!
) else (
    echo Fehler beim Ändern des Computernamens.
)

exit /b 0

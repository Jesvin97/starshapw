@echo off
echo Opening EV Wheels Log Folder...
echo.
echo Log files are saved in your user profile:
echo %USERPROFILE%\EV-Wheels-Logs\
echo.

if exist "%USERPROFILE%\EV-Wheels-Logs" (
    start "" "%USERPROFILE%\EV-Wheels-Logs"
) else (
    echo Log folder doesn't exist yet. Run the desktop app first to create logs.
    echo.
    mkdir "%USERPROFILE%\EV-Wheels-Logs"
    echo Created log folder: %USERPROFILE%\EV-Wheels-Logs
    start "" "%USERPROFILE%\EV-Wheels-Logs"
)

pause

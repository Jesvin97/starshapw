@echo off
echo Building EV Wheels Desktop App...
echo.
echo This process will:
echo 1. Build Next.js application
echo 2. Export static files
echo 3. Package with Electron
echo 4. Create installer
echo.
echo Please wait, this may take 5-10 minutes...
echo.

npm run electron:pack

echo.
echo Build complete! Check the 'dist' folder for your installer.
echo.

if exist "dist" (
    echo Opening dist folder...
    start "" "dist"
) else (
    echo Dist folder not found. Check for errors above.
)

pause

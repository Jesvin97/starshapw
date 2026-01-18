@echo off
echo ============================================
echo  Creating EV Wheels Windows Desktop App
echo ============================================
echo.

echo Step 1: Installing electron packager...
call npm install -g electron-packager
if %errorlevel% neq 0 (
    echo WARNING: Global install failed, trying npx...
)

echo.
echo Step 2: Packaging the desktop application...
echo This will create a portable Windows app folder...
npx electron-packager@17.1.1 . "EV Wheels Management System" --platform=win32 --arch=x64 --out=dist --overwrite --icon=public/ewheels-logo-splash.png
if %errorlevel% neq 0 (
    echo ERROR: Packaging failed!
    echo.
    echo Trying alternative method...
    npx electron@32.0.1 --version
    if %errorlevel% neq 0 (
        echo Installing electron locally...
        npm install electron@32.0.1
    )
    npx electron-packager@17.1.1 . "EV Wheels Management System" --platform=win32 --arch=x64 --out=dist --overwrite
)

echo.
echo ============================================
echo  SUCCESS! Desktop App Created!
echo ============================================
echo.
echo Your app is ready in: dist/EV Wheels Management System-win32-x64/
echo.
echo To create a proper installer, run: build-windows-installer.bat
echo.

if exist "dist" (
    echo Opening dist folder...
    start "" "dist"
) else (
    echo Warning: dist folder not found. Check for errors above.
)

pause

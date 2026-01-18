@echo off
echo ============================================
echo  Building EV Wheels Windows Installer
echo ============================================
echo.

echo Step 1: Building Next.js application...
call pnpm run build
if %errorlevel% neq 0 (
    echo ERROR: Next.js build failed!
    pause
    exit /b 1
)

echo.
echo Step 2: Static files ready in 'out' folder

echo.
echo Step 3: Creating Windows installer with Electron...
echo This may take several minutes, please wait...
npx electron-builder@25.0.5 --win --publish=never
if %errorlevel% neq 0 (
    echo ERROR: Electron builder failed!
    pause
    exit /b 1
)

echo.
echo ============================================
echo  SUCCESS! Windows Installer Created!
echo ============================================
echo.
echo Your installer is ready in the 'dist' folder:
echo - EV-Wheels-Management-System Setup.exe
echo.

if exist "dist" (
    echo Opening dist folder...
    start "" "dist"
) else (
    echo Warning: dist folder not found. Check for errors above.
)

echo.
echo Installation complete! You can now distribute the .exe file.
pause

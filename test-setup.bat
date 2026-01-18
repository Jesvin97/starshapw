@echo off
echo Testing EV Wheels Desktop App Setup...
echo.

echo ✅ Checking Node.js...
node --version
if %errorlevel% neq 0 (
    echo ❌ Node.js not found!
    goto :error
)

echo ✅ Checking npm...
npm --version
if %errorlevel% neq 0 (
    echo ❌ npm not found!
    goto :error
)

echo ✅ Checking Rust...
rustc --version
if %errorlevel% neq 0 (
    echo ❌ Rust not found!
    goto :error
)

echo ✅ Checking Tauri CLI...
npx tauri --version
if %errorlevel% neq 0 (
    echo ❌ Tauri CLI not found!
    goto :error
)

echo.
echo ✅ All dependencies are ready!
echo ✅ You can now run the desktop app with: run-desktop-app.bat
echo ✅ Or build installer with: build-desktop-app.bat
echo.
goto :success

:error
echo.
echo ❌ Setup incomplete. Please check the missing dependencies above.
echo See DESKTOP_APP_SETUP.md for detailed instructions.
pause
exit /b 1

:success
pause

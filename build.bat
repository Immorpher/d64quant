@echo off
:: Builds d64quant in release mode and copies the finished program into
:: a "dist" folder next to this file, away from the cargo build clutter.
cd /d "%~dp0"

cargo build --release
if errorlevel 1 (
    echo.
    echo Build failed.
    pause
    exit /b 1
)

if not exist release mkdir release
copy /Y "target\release\d64quant.exe" "release\d64quant.exe" >nul
if errorlevel 1 (
    echo Could not copy d64quant.exe to release.
    pause
    exit /b 1
)

echo.
echo Done: %~dp0dist\d64quant.exe
pause

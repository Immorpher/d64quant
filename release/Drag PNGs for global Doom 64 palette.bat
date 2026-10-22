@echo off

set exedir=%~dp0

:: Drag one or more PNGs onto this file. All dragged images are
:: combined into ONE shared 256-color palette (--global-palette).
:: Results go into "fs8" (dithered) and "or8" (not dithered) folders
:: next to the source images, keeping the original file names.
:: The palette is saved as DOOMPAL.pal in each of those folders
:: (next to the first dragged image).

:: make the folders first so the palette files can be written into them
for %%F in (%*) do (
    if not exist "%%~dpFfs8\" mkdir "%%~dpFfs8"
    if not exist "%%~dpFor8\" mkdir "%%~dpFor8"
)

"%exedir%d64quant.exe" --force --verbose --floyd=1 --speed 1 --trans-color 000000 --global-palette 256 --doompal="%~dp1fs8\DOOMPAL.pal" %*

"%exedir%d64quant.exe" --force --verbose --floyd=0 --speed 1 --trans-color 000000 --global-palette 256 --doompal="%~dp1or8\DOOMPAL.pal" %*

:: pngquant only adds a suffix, so move each result into its folder under the original name
for %%F in (%*) do (
    if exist "%%~dpnF-fs8.png" move /Y "%%~dpnF-fs8.png" "%%~dpFfs8\%%~nxF" >nul
    if exist "%%~dpnF-or8.png" move /Y "%%~dpnF-or8.png" "%%~dpFor8\%%~nxF" >nul
)

pause

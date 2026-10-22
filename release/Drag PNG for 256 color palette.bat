@echo off

set path=%~d0%~p0

:start

"%path%d64quant.exe" --force --verbose --floyd=1 --speed 1 --trans-color 000000 --strip %1

"%path%d64quant.exe" --force --verbose --floyd=0 --speed 1 --trans-color 000000 --strip %1

shift
if NOT x%1==x goto start
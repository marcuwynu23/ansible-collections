@echo off
REM Test all collections syntax via WSL
echo Testing all collections syntax...
cd /d "%~dp0"
wsl -e bash -c "cd \"$(wslpath '%~dp0')\" && ./test-all.sh"
echo Done!

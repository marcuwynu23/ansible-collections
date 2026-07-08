@echo off
REM Publish Collection to Ansible Galaxy (runs in WSL)

echo Running in WSL...
wsl -e bash -c "cd \"$(wslpath '%~dp0')\" && ./publish-collection.sh %*"
exit /b %errorlevel%

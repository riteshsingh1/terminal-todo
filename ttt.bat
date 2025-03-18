@echo off
setlocal

REM Terminal Todo Tracker (ttt) - Windows Batch Wrapper

REM First try to find bash in its common installation paths
set BASH_PATH=

REM Check for Git Bash
if exist "C:\Program Files\Git\bin\bash.exe" (
    set BASH_PATH="C:\Program Files\Git\bin\bash.exe"
    goto found_bash
)

if exist "C:\Program Files (x86)\Git\bin\bash.exe" (
    set BASH_PATH="C:\Program Files (x86)\Git\bin\bash.exe"
    goto found_bash
)

REM Check for WSL bash
where /q wsl
if %ERRORLEVEL% EQU 0 (
    set BASH_PATH=wsl
    goto found_wsl
)

REM Check if bash is in PATH
where /q bash
if %ERRORLEVEL% EQU 0 (
    set BASH_PATH=bash
    goto found_bash
)

REM No bash implementation found
echo ERROR: Could not find bash.exe or WSL.
echo Please install Git for Windows or Windows Subsystem for Linux (WSL).
echo See README.md for more information.
exit /b 1

:found_wsl
REM For WSL, we need to use a different approach
%BASH_PATH% -c "cd '%~dp0' && ./ttt %*"
goto end

:found_bash
REM Using native bash - use the script directory
%BASH_PATH% "%~dp0ttt" %*

:end
endlocal 
@echo off
if "%PROCESSOR_ARCHITECTURE%" == "AMD64" goto :next
if "%PROCESSOR_ARCHITEW6432%" == "AMD64" goto :next
if "%PROCESSOR_ARCHITECTURE%" == "ARM64" (
  rem Check if the OS is Windows 11
  (ver | findstr /c:"Version 10.0.2") > NUL && goto :next
)
  
echo QueryCSV and QueryTSV plugins are only supported on x64 systems
goto :eof

:next
set DOWNLOAD_URL=https://github.com/harelba/q/releases/download/2.0.19/q-AMD64-Windows.exe
set Q_PATH=Commands\q\q-AMD64-Windows.exe
set MESSAGE='q command is not installed. Do you want to download it from %DOWNLOAD_URL%?'
set TITLE='CSV/TSV Data Querier Plugin'

cd "%APPDATA%\WinMerge"
if not exist %Q_PATH% (
  cd "%~dp0..\.."
  if not exist %Q_PATH% (
    mkdir "%APPDATA%\WinMerge" 2> NUL
    cd "%APPDATA%\WinMerge"
    for %%i in (%Q_PATH%) do mkdir %%~pi 2> NUL
    powershell "if ((New-Object -com WScript.Shell).Popup(%MESSAGE%,0,%TITLE%,1) -ne 1) { throw }" > NUL
    if errorlevel 1 (
      echo "download is canceled" 1>&2
    ) else (
      start "Downloading..." /WAIT powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest %DOWNLOAD_URL% -Outfile %Q_PATH%"
    )
  )
)
%Q_PATH% %*

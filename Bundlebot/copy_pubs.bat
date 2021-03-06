@echo off
set error=0
set bot_type=%1
set pdf_from=%2
set bot_host=%3

set "PUBDIR=%userprofile%\Google Drive\FDS-SMV Newest Manuals\"

set pdf_to=%userprofile%\.bundle\pubs

if NOT exist %userprofile%\.bundle mkdir %userprofile%\.bundle
if NOT exist %pdf_to% mkdir %pdf_to%

echo.
echo From directory: %pdf_from%
echo   To directory: %pdf_to%

if "x%bot_host%" == "x" goto endif0
  echo           host: %bot_host% 
:endif0

if "%bot_type%" == "firebot" (
  call :copy_file FDS_Config_Management_Plan.pdf
  call :copy_file FDS_Technical_Reference_Guide.pdf
  call :copy_file FDS_User_Guide.pdf
  call :copy_file FDS_Validation_Guide.pdf
  call :copy_file FDS_Verification_Guide.pdf
)

if "%bot_type%" == "smokebot" (
  call :copy_file SMV_Technical_Reference_Guide.pdf
  call :copy_file SMV_User_Guide.pdf
  call :copy_file SMV_Verification_Guide.pdf
)

goto eof

:: -------------------------------------------------
:copy_file
:: -------------------------------------------------
set file=%1

set "fullfile=%PUBDIR%\%file%"
if NOT exist "%fullfile%" goto getfile_if
  echo        copying: %file%
  copy "%fullfile%" %pdf_to%\%file% > Nul
  exit /b 0
:getfile_if

echo        copying: %file%
if "x%bot_host%" == "x" goto else1
  pscp -P 22 %bot_host%:%pdf_from%/%file% %pdf_to%\.
  if EXIST %pdf_to%\%file% goto endif1
  echo ***Error: unable to copy %file% from %bot_host%:%pdf_from%/%file%
  set error=1
  goto endif1
:else1
  copy %pdf_from%\%file% %pdf_to%
  if EXIST %pdf_to%\%file% goto endif1
  echo ***Error: unable to copy %file% from %pdf_from%\%file%
  set error=1
:endif1
exit /b

:eof

if "%error%" == "0" exit /b 0
exit /b 1
@echo on
setlocal

set CURDIR=%CD%
call config

cd bundles
set BUNDLEDIR=%CD%

echo ***cleaning %BUNDLEDIR%
git clean -dxf

cd %CURDIR%

set BUNDLE_BASE=%BUNDLE_FDS_TAG%_%BUNDLE_SMV_TAG%_

call :downloadfile FDS_Config_Management_Plan.pdf
call :downloadfile FDS_Technical_Reference_Guide.pdf
call :downloadfile FDS_User_Guide.pdf
call :downloadfile FDS_Validation_Guide.pdf
call :downloadfile FDS_Verification_Guide.pdf

call :downloadfile SMV_User_Guide.pdf
call :downloadfile SMV_Verification_Guide.pdf
call :downloadfile SMV_Technical_Reference_Guide.pdf

call :downloadfile %BUNDLE_BASE%lnx.sh
call :downloadfile %BUNDLE_BASE%lnx.tar.gz
call :downloadfile %BUNDLE_BASE%lnx.sha1

call :downloadfile %BUNDLE_BASE%osx.sh
call :downloadfile %BUNDLE_BASE%osx.tar.gz
call :downloadfile %BUNDLE_BASE%osx.sha1

call :downloadfile %BUNDLE_BASE%win.exe
call :downloadfile %BUNDLE_BASE%win.zip
call :downloadfile %BUNDLE_BASE%win.sha1
echo ***files downloaded to %BUNDLEDIR%
cd %CURDIR%
goto eof

::----------------------------------------------------------
:downloadfile
::----------------------------------------------------------
set ffile=%1
  echo downloading %ffile%
  gh release download FDS_TEST -p %ffile% -D %BUNDLEDIR%  -R github.com/firemodels/test_bundles
  exit /b 0

:eof

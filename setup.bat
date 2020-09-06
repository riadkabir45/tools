@setlocal
@echo off

if [%~1]==[] goto end
if [%~1]==[--list] goto list
if [%~2]==[] goto delete

set command=%*
echo %command%|find "%~1=">nul
if %errorlevel% NEQ 0 echo Invalid argements. && goto end

call runtimelib %*>%~dp0/%~1.bat

:end
@endlocal
@exit /b

:delete
if not exist %~dp0/%~1.bat echo Alias does not exist && goto end
del /f /q "%~dp0/%~1.bat" 2>nul
goto end

:list
For /R "%~dp0" %%G IN (*.bat) do call :simpleList "%%G"
goto end

:simpleList

exit /b
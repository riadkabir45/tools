@setlocal
@echo off


set dir=C:\Windows\System32\spp\tokens\skus
set evalArmed=true
set slmgrc=cscript.exe %windir%\system32\slmgr.vbs

if not exist "%dir%\csvlk-pack" set evalArmed=false
if not exist "%dir%\EnterpriseS" set evalArmed=false

if %evalArmed% equ false (
start C:\Windows\System32\spp\tokens\skus
msg * "Please extract the skus.zip to the opened folder first!!"
)

call :checkAdmin || (
msg * "Please run this as admin"
goto ender
)

ping -n 1 kms.teevee.asia > nul || (
msg * Please Check your internet connection
goto ender
)

(
 %slmgrc% /rilc && call :endCode rilc
call :getCode rilc &&  %slmgrc% /upk >nul 2>&1 && call :endCode upk
call :getCode upk &&  %slmgrc% /ckms >nul 2>&1 && call :endCode ckms
call :getCode ckms &&  %slmgrc% /cpky >nul 2>&1 && call :endCode cpky
call :getCode cpky &&  %slmgrc% /ipk M7XTQ-FN8P6-TTKYV-9D4CC-J462D >nul 2>&1 && call :endCode ipk
call :getCode ipk &&  %slmgrc% /skms kms.teevee.asia >nul 2>&1 && call :endCode skms
call :getCode skms &&  slmgr /ato && call :endCode ""
) || echo Process halted!!

:ender
@endlocal
@exit /b

:endCode
echo %1>"%tmp%\loader.log"
exit /b

:getCode
set eCode=0
set /p val=<"%tmp%\loader.log"
if [%1] neq [%val%] set eCode=1
exit /b %eCode%

:checkAdmin
set eCode=0
bcdedit >nul 2>nul || set eCode=1
exit /b %eCode%

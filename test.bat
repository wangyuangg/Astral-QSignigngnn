@echo off
chcp 65001 >nul
title QSign API Test

echo ========================================
echo   QSign API Test Script
echo ========================================
echo.

set BASE_URL=http://localhost:4848
set UIN=10000
set CMD=wtlogin.login
set SEQ=12345
set BUFFER=0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF
set GUID=0123456789ABCDEF0123456789ABCDEF
set ANDROID_ID=0123456789ABCDEF
set QIMEI36=0123456789ABCDEF0123456789ABCDEF

echo [INFO] Testing sign endpoint...
echo [INFO] URL: %BASE_URL%/sign
echo [INFO] UIN: %UIN%
echo [INFO] CMD: %CMD%
echo.

curl -s "%BASE_URL%/sign?uin=%UIN%&cmd=%CMD%&seq=%SEQ%&buffer=%BUFFER%&guid=%GUID%&android_id=%ANDROID_ID%&qimei36=%QIMEI36%"

echo.
echo.
echo [INFO] Test completed.
pause

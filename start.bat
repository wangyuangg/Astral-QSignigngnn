@echo off
chcp 65001 >nul
title QSign-Unidbg Service

cd /d "%~dp0"

:: Check if port is in use and kill existing process
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":4848.*LISTENING" 2^>nul') do (
    echo [WARN] Port 4848 is in use, killing process %%a...
    taskkill /F /PID %%a >nul 2>&1
    timeout /t 2 >nul
)

:: Check if config exists
if not exist "txlib\9.2.70\config.json" (
    echo [ERROR] Config file not found: txlib\9.2.70\config.json
    pause
    exit /b 1
)

:: Find Java
set JAVA_EXE=
if exist "%USERPROFILE%\.jdk\jdk-17.0.2\bin\java.exe" (
    set JAVA_EXE=%USERPROFILE%\.jdk\jdk-17.0.2\bin\java.exe
) else if exist "%JAVA_HOME%\bin\java.exe" (
    set JAVA_EXE=%JAVA_HOME%\bin\java.exe
) else (
    :: Try to find Java in PATH
    for /f "tokens=*" %%i in ('where java 2^>nul') do set JAVA_EXE=%%i
)

if "%JAVA_EXE%"=="" (
    echo [ERROR] Java not found. Please install JDK 17+ or set JAVA_HOME
    pause
    exit /b 1
)

echo [INFO] Using Java: %JAVA_EXE%
echo.

:: Check if JAR exists
if not exist "build\libs\unidbg-fetch-qsign-1.1.9-all.jar" (
    echo [ERROR] JAR not found. Please build the project first with: gradlew shadowJar
    pause
    exit /b 1
)

echo [INFO] Starting QSign service...
echo [INFO] Port: 4848 (default)
echo [INFO] Press Ctrl+C to stop
echo.

"%JAVA_EXE%" -jar build\libs\unidbg-fetch-qsign-1.1.9-all.jar --basePath=txlib\9.2.70

pause

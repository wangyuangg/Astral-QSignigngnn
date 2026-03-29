@echo off
chcp 65001 >nul
title Build QSign

cd /d "%~dp0"

echo [INFO] Building QSign project...

:: Set JAVA_HOME for Gradle
if exist "%USERPROFILE%\.jdk\jdk-17.0.2" (
    set JAVA_HOME=%USERPROFILE%\.jdk\jdk-17.0.2
)

call gradlew.bat shadowJar

if %ERRORLEVEL% equ 0 (
    echo.
    echo [SUCCESS] Build completed!
    echo [INFO] JAR: build\libs\unidbg-fetch-qsign-1.1.9-all.jar
) else (
    echo.
    echo [ERROR] Build failed!
)

pause

#!/usr/bin/env pwsh
# QSign-Unidbg Startup Script

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Set-Location $ScriptDir

# Check if port 4848 is in use and kill existing process
$portInUse = Get-NetTCPConnection -LocalPort 4848 -ErrorAction SilentlyContinue
if ($portInUse) {
    $pid = $portInUse.OwningProcess | Where-Object { $_ -gt 0 } | Select-Object -First 1
    if ($pid) {
        Write-Host "[WARN] Port 4848 is in use, killing process $pid..." -ForegroundColor Yellow
        Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    }
}

# Check config
if (-not (Test-Path "txlib\9.2.70\config.json")) {
    Write-Host "[ERROR] Config file not found: txlib\9.2.70\config.json" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Find Java
$JavaExe = $null
$JavaPaths = @(
    "$env:USERPROFILE\.jdk\jdk-17.0.2\bin\java.exe",
    "$env:JAVA_HOME\bin\java.exe",
    "C:\Users\Administrator\.jdk\jdk-17.0.2\bin\java.exe"
)

foreach ($path in $JavaPaths) {
    if ($path -and (Test-Path $path)) {
        $JavaExe = $path
        break
    }
}

# Try to find in PATH
if (-not $JavaExe) {
    try {
        $JavaExe = (Get-Command java -ErrorAction SilentlyContinue).Source
    } catch {}
}

if (-not $JavaExe) {
    Write-Host "[ERROR] Java not found. Please install JDK 17+ or set JAVA_HOME" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[INFO] Using Java: $JavaExe" -ForegroundColor Green

# Check JAR
if (-not (Test-Path "build\libs\unidbg-fetch-qsign-1.1.9-all.jar")) {
    Write-Host "[ERROR] JAR not found. Please build the project first with: .\gradlew.bat shadowJar" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "[INFO] Starting QSign service..." -ForegroundColor Cyan
Write-Host "[INFO] Port: 4848 (default)" -ForegroundColor Cyan
Write-Host "[INFO] Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

& $JavaExe -jar "build\libs\unidbg-fetch-qsign-1.1.9-all.jar" --basePath="txlib\9.2.70"

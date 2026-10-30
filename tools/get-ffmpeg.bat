@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ============================================
echo  ffmpeg / ffprobe 下载工具（Windows x64）
echo ============================================
echo.

if exist "%~dp0ffmpeg.exe" (
    echo [OK] 已存在 ffmpeg.exe，无需重复下载。
    echo.
    ffmpeg.exe -version 2>nul | findstr /i "ffmpeg version"
    goto :end
)

set "BASE=https://github.com/GyanD/codexffmpeg/releases/download"
set "MIRROR=https://ghfast.top/"

echo [1/3] 获取最新版本号...
for /f "delims=" %%v in ('curl -sSL --noproxy "*" -m 20 "https://api.github.com/repos/GyanD/codexffmpeg/releases/latest" ^| findstr /r /c:"\"tag_name\""') do set "TAGLINE=%%v"
for /f "tokens=2 delims=:" %%a in ("!TAGLINE!") do set "TAG=%%a"
set "TAG=!TAG: =!"
set "TAG=!TAG:"=!"
set "TAG=!TAG:,=!"

if "!TAG!"=="" (
    echo [!] 无法自动获取版本号，改用固定版本。
    set "TAG=2026-10-01-git-4f2b1c8"
)

echo     版本: !TAG!
set "FILE=ffmpeg-!TAG!-essentials_build.zip"
set "URL=!MIRROR!!BASE!/!TAG!/!FILE!"

echo [2/3] 下载（镜像加速，约 40MB）...
curl -L --noproxy "*" --connect-timeout 15 --retry 3 -# -o "_ffmpeg.zip" "!URL!"
if not exist "_ffmpeg.zip" goto :fail

echo [3/3] 解压...
tar -xf "_ffmpeg.zip" 2>nul
if errorlevel 1 (
    powershell -NoProfile -Command "Expand-Archive -Force -Path '_ffmpeg.zip' -DestinationPath '_tmp'" 2>nul
)

for /r "%~dp0" %%f in (ffmpeg.exe) do if not exist "%~dp0ffmpeg.exe" copy /y "%%f" "%~dp0" >nul
for /r "%~dp0" %%f in (ffprobe.exe) do if not exist "%~dp0ffprobe.exe" copy /y "%%f" "%~dp0" >nul

if exist "%~dp0ffmpeg.exe" (
    echo.
    echo [OK] 完成。ffmpeg.exe 已放入当前目录。
    del /q "_ffmpeg.zip" 2>nul
    for /d %%d in ("%~dp0ffmpeg-*") do rd /s /q "%%d" 2>nul
    for /d %%d in ("%~dp0_tmp") do rd /s /q "%%d" 2>nul
    goto :end
)
goto :fail

:fail
echo.
echo [X] 下载或解压失败。
echo     请手动访问: https://www.gyan.dev/ffmpeg/builds/
echo     下载 essentials 版本，把 bin 目录里的 ffmpeg.exe、ffprobe.exe 复制到本目录。
pause
exit /b 1

:end
echo.
pause
exit /b 0

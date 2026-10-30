@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

set "VER=6.8.0"
set "PKG=rea-agents@%VER%"

echo ============================================
echo  REA (reverse-engineering MCP server) setup
echo  package: %PKG%
echo ============================================
echo.

where node >nul 2>nul
if errorlevel 1 (
    echo [X] Node.js not found on PATH.
    echo     Need Node 22.x ^>=22.23.4, or 24.x ^>=24.22.1, or 26.12.1+.
    echo     Portable build: https://registry.npmmirror.com/-/binary/node/v22.23.4/node-v22.23.4-win-x64.zip
    goto :fail
)

for /f "delims=" %%v in ('node -v') do set "NODEV=%%v"
echo [i] Node: %NODEV%
echo.

echo [1/3] Downloading and running setup ^(writes MCP config + skill^)...
call npx --yes %PKG% setup --all-detected --yes
if errorlevel 1 (
    echo.
    echo [!] Setup returned a non-zero code.
    echo     If it complains about the Node version, upgrade Node first:
    echo     https://registry.npmmirror.com/-/binary/node/v22.23.4/node-v22.23.4-win-x64.zip
    echo     If it exposes no detected client, register manually using mcp.json in this folder.
    goto :fail
)

echo.
echo [2/3] Running doctor...
call npx --yes %PKG% doctor
echo.

echo [3/3] Done.
echo.
echo   Next steps:
echo     1. Restart your agent / IDE.
echo     2. In the connector manager, click "Trust" on the new MCP server named rea.
echo     3. Optional deep analysis engines:
echo        - Ghidra ^(free^): set GHIDRA_INSTALL_DIR to the extracted release folder
echo        - IDA:   set REA_IDA_MCP_CONFIG
echo        - jadx:  set REA_JADX_MCP_JAR
echo        - kuna:  set REA_KUNA_COMMAND
echo.
echo   Web frontend / Electron / .NET / JavaScript analysis works without any engine.
echo.
pause
exit /b 0

:fail
echo.
pause
exit /b 1

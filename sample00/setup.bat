@echo off
setlocal enabledelayedexpansion

:: Aller dans le dossier du script
cd /d %~dp0
for %%I in (.) do set PROJECT_NAME=%%~nxI

cd ..
set ROOT_DIR=%CD%

set TMP_DIR=%ROOT_DIR%\tmp
mkdir %TMP_DIR% 2>nul

set PROJECT_DIR=%ROOT_DIR%\%PROJECT_NAME%

echo ROOT_DIR: %ROOT_DIR%
echo PROJECT_NAME: %PROJECT_NAME%
echo PROJECT_DIR: %PROJECT_DIR%
echo TMP_DIR: %TMP_DIR%

set SHARPMAKE_PLATFORM=Windows
set SHARPMAKE_VERSION=0.76.0
set SHARPMAKE_ENGINE=net6.0

cd /d %TMP_DIR%
if not exist sharpmake (
    echo Téléchargement de Sharpmake...
    powershell -Command "& { Invoke-WebRequest -Uri 'https://github.com/ubisoft/Sharpmake/releases/download/%SHARPMAKE_VERSION%/Sharpmake-%SHARPMAKE_ENGINE%-%SHARPMAKE_PLATFORM%-%SHARPMAKE_VERSION%.zip' -OutFile 'Sharpmake.zip' }"
    mkdir sharpmake
    powershell -Command "& { Expand-Archive -Path 'Sharpmake.zip' -DestinationPath 'sharpmake' }"
    del Sharpmake.zip
)

set SHARPMAKE_BIN=%TMP_DIR%\sharpmake\Sharpmake.Application

cd /d %PROJECT_DIR%
"%SHARPMAKE_BIN%" "/sources(@'main.sharpmake.cs')"

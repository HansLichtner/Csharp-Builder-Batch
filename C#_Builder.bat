@echo off
setlocal enabledelayedexpansion

:: Local do MSBuild 2019
set msBuild="C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin\MSBuild.exe"

echo Chamando o vsdevcmd 2019...
echo.
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\Tools\VsDevCmd.bat"

echo Executando limpeza de informações de zona...
echo.

set "rootFolder=%~1"

if not defined rootFolder (
    echo Por favor, arraste a pasta para o script batch.
    exit /b
)

for /r "%rootFolder%" %%F in (*) do (
    echo. > "%%F:Zone.Identifier"
)

echo Concluído! Informações de zona limpas em todos os arquivos e pastas.
echo.
::pause

set "solutionFile="
for /r "%rootFolder%" %%F in (*.sln) do (
    set "solutionFile=%%F"
    goto :Build
)

echo Arquivo .sln não encontrado na pasta especificada.
exit /b

:Build
echo Arquivo .sln encontrado: %solutionFile%
echo.

set "buildFolder=%rootFolder%\Build"
if not exist "%buildFolder%" (
    mkdir "%buildFolder%"
)

echo Iniciando o build com MSBuild 2019...
echo.
%msBuild% -m "%solutionFile%" /t:Build /p:Configuration=Debug /p:Platform="Any CPU" /p:OutputPath="%buildFolder%"
%msBuild% -m "%solutionFile%" /t:Build /p:Configuration=Release /p:Platform="Any CPU" /p:OutputPath="%buildFolder%"

echo Build concluído com sucesso!

pause

endlocal

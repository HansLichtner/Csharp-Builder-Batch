@echo off
setlocal enabledelayedexpansion

:: Local do MSBuild
set MSBuild="C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin\MSBuild.exe"

:: Local do VsDevCmd
set VsDevCmd="C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\Tools\VsDevCmd.bat"

echo 旼컴컴컴컴컴컴컴컴컴컴컴컴커
echo � Inicializando o VsDevCmd �
echo 읕컴컴컴컴컴컴컴컴컴컴컴컴켸
echo.
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\Tools\VsDevCmd.bat"

set "rootFolder=%~1"
echo.

if "%rootFolder%"=="" (
    goto :ChooseFolder
) else (
    goto :CleanZone
)

:ChooseFolder
set "rootFolder="
set /p "rootFolder=Arraste a pasta do projeto para c� e pressione Enter: "  
echo.

if not exist "%rootFolder%" (
    echo Caminho inv쟫ido. Verifique se o diret줿io existe. 
    echo.
    goto :ChooseFolder
)

:CleanZone
echo 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
echo � Limpando informa뉏es de zona... �
echo 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
echo.

for /r "%rootFolder%" %%F in (*) do (
    echo. > "%%F:Zone.Identifier"
)

echo 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
echo � Conclu죆o! Informa뉏es de zona limpas.  �
echo 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
echo.
::pause

:Build
::Cria a pasta "Build"
set "buildFolder=%rootFolder%\Build"
if not exist "%buildFolder%" (
    mkdir "%buildFolder%"
)

echo 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
echo � Localizando arquivos de projeto... �
echo 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

for /r "%rootFolder%" %%F in (*.sln) do (
    set "projectName=%%~nF"
    echo Arquivo !projectName!.sln encontrado: %%F
    echo.
    echo 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
    echo � Iniciando o build com MSBuild... �
    echo 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
    echo.
    %MSBuild% -m %%F /t:Build /p:Configuration=Debug /p:Platform="Any CPU" /p:OutputPath="%buildFolder%"
    if !errorlevel! equ 0 (
        echo.
        echo 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
        echo � Build de !projectName! conclu죆o com sucesso! �
        echo 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
        echo.
    ) else (
        echo.
        echo 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
        echo � Build de !projectName! falhou!  �
        echo � Verifique a falha de compila눯o �
        echo 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
        echo.
    )
    %MSBuild% -m %%F /t:Build /p:Configuration=Release /p:Platform="Any CPU" /p:OutputPath="%buildFolder%"
    if !errorlevel! equ 0 (
        echo.
        echo 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
        echo � Build de !projectName! conclu죆o com sucesso! �
        echo 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
        echo.
    ) else (
        echo.
        echo 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
        echo � Build de !projectName! falhou!  �
        echo � Verifique a falha de compila눯o �
        echo 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
        echo.
    )
)

pause

endlocal

@echo off
setlocal enabledelayedexpansion

:: Local do MSBuild
set MSBuild="C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin\MSBuild.exe"

:: Local do VsDevCmd
set VsDevCmd="C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\Tools\VsDevCmd.bat"

echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo ³ Inicializando o VsDevCmd ³
echo ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
set /p "rootFolder=Arraste a pasta do projeto para c  e pressione Enter: "  
echo.

if not exist "%rootFolder%" (
    echo Caminho inv lido. Verifique se o diret¢rio existe. 
    echo.
    goto :ChooseFolder
)

:CleanZone
echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo ³ Limpando informa‡äes de zona... ³
echo ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
echo.

for /r "%rootFolder%" %%F in (*) do (
    echo. > "%%F:Zone.Identifier"
)

echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo ³ Conclu¡do! Informa‡äes de zona limpas.  ³
echo ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
echo.
::pause


echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo ³ Localizando arquivos de projeto... ³
echo ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

:: Variável para verificar se algum projeto foi encontrado
set "projectFound="

for /r "%rootFolder%" %%F in (*.sln) do (
        set "projectFound=1"
)

:: Verificar se algum projeto foi encontrado
if "%projectFound%"=="" (
    echo.
    echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    echo ³ Nenhum arquivo .sln encontrado na pasta especificada. ³
    echo ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    echo.
    goto :End
) else (
    goto :Build
)


:Build
::Cria a pasta "Build"
set "buildFolder=%rootFolder%\Build"
if not exist "%buildFolder%" (
    mkdir "%buildFolder%"
)

for /r "%rootFolder%" %%F in (*.sln) do (
    set "projectName=%%~nF"
    echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    echo ³ Arquivo !projectName!.sln encontrado: ³
    echo ³ %%F ³
    echo ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    echo.
    echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    echo ³ Iniciando o build com MSBuild... ³
    echo ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    echo.
    %MSBuild% -m %%F /t:Restore /t:Build /p:Configuration=Debug /p:Platform="Any CPU" /p:OutputPath="%buildFolder%"
    if !errorlevel! equ 0 (
        echo.
        echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        echo ³ Build de !projectName! conclu¡do com sucesso! ³
        echo ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        echo.
    ) else (
        echo.
        echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        echo ³ Build de !projectName! falhou!  ³
        echo ³ Verifique a falha de compila‡Æo ³
        echo ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        echo.
    )
    %MSBuild% -m %%F /t:Restore /t:Build /p:Configuration=Release /p:Platform="Any CPU" /p:OutputPath="%buildFolder%"
    if !errorlevel! equ 0 (
        echo.
        echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        echo ³ Build de !projectName! conclu¡do com sucesso! ³
        echo ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        echo.
    ) else (
        echo.
        echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        echo ³ Build de !projectName! falhou!  ³
        echo ³ Verifique a falha de compila‡Æo ³
        echo ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        echo.
    )
)


:End
pause

endlocal

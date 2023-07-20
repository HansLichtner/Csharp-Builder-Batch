@echo off
setlocal enabledelayedexpansion

:: Local do MSBuild
set MSBuild="C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin\MSBuild.exe"

:: Local do VsDevCmd
set VsDevCmd="C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\Tools\VsDevCmd.bat"

echo ��������������������������Ŀ
echo � Inicializando o VsDevCmd �
echo ����������������������������
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
    echo Caminho inv�lido. Verifique se o diret�rio existe. 
    echo.
    goto :ChooseFolder
)

:CleanZone
echo ���������������������������������Ŀ
echo � Limpando informa��es de zona... �
echo �����������������������������������
echo.

for /r "%rootFolder%" %%F in (*) do (
    echo. > "%%F:Zone.Identifier"
)

echo ����������������������������������������Ŀ
echo � Conclu�do! Informa��es de zona limpas.  �
echo ������������������������������������������
echo.
::pause


echo ������������������������������������Ŀ
echo � Localizando arquivos de projeto... �
echo ��������������������������������������

:: Vari�vel para verificar se algum projeto foi encontrado
set "projectFound="

for /r "%rootFolder%" %%F in (*.sln) do (
        set "projectFound=1"
)

:: Verificar se algum projeto foi encontrado
if "%projectFound%"=="" (
    echo.
    echo �������������������������������������������������������Ŀ
    echo � Nenhum arquivo .sln encontrado na pasta especificada. �
    echo ���������������������������������������������������������
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
    echo �������������������������������������������Ŀ
    echo � Arquivo !projectName!.sln encontrado: �
    echo � %%F �
    echo ���������������������������������������������
    echo.
    echo ����������������������������������Ŀ
    echo � Iniciando o build com MSBuild... �
    echo ������������������������������������
    echo.
    %MSBuild% -m %%F /t:Restore /t:Build /p:Configuration=Debug /p:Platform="Any CPU" /p:OutputPath="%buildFolder%"
    if !errorlevel! equ 0 (
        echo.
        echo �����������������������������������������������Ŀ
        echo � Build de !projectName! conclu�do com sucesso! �
        echo �������������������������������������������������
        echo.
    ) else (
        echo.
        echo ���������������������������������Ŀ
        echo � Build de !projectName! falhou!  �
        echo � Verifique a falha de compila��o �
        echo �����������������������������������
        echo.
    )
    %MSBuild% -m %%F /t:Restore /t:Build /p:Configuration=Release /p:Platform="Any CPU" /p:OutputPath="%buildFolder%"
    if !errorlevel! equ 0 (
        echo.
        echo �����������������������������������������������Ŀ
        echo � Build de !projectName! conclu�do com sucesso! �
        echo �������������������������������������������������
        echo.
    ) else (
        echo.
        echo ���������������������������������Ŀ
        echo � Build de !projectName! falhou!  �
        echo � Verifique a falha de compila��o �
        echo �����������������������������������
        echo.
    )
)


:End
pause

endlocal

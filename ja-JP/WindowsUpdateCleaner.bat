@echo off && setlocal

rem "****************************************************"
rem "                  W A R N I N G !                   "
rem "  The character encoding of this file is Shift-JIS. "
rem "****************************************************"

set ret_success=0
set ret_error1=1
set ret_error2=2

if "%1"=="/h" (
    call :usage
    exit /b %err_level%
) else if "%1"=="--?" (
    call :usage
    exit /b %err_level%
) else if not "%1"=="/b" if not "%1"=="" (
    call :abort *** ERROR 2 *** ����������Ă��܂��B
    call :usage
    exit /b %ret_error2%
)

echo.
echo *** 1/6 *** �Ǘ��Ҍ����`�F�b�N...
echo.
whoami /priv | find "SeDebugPrivilege" > nul
if %errorlevel% neq 0 (
    if "%1"=="/b" (
        @powershell start-process """%~0""" -ArgumentList """/b""" -verb runas
        call :abort *** ERROR 1 *** �Ǘ��Ҍ���������܂���B�Ǘ��Ҍ����Ŏ��s���܂��B
        exit /b %ret_error1%
    ) else (
        @powershell start-process """%~0""" -verb runas
        call :abort *** ERROR 1 *** �Ǘ��Ҍ���������܂���B�Ǘ��Ҍ����Ŏ��s���܂��B
        exit %ret_error1%
    )

) else (

    echo.
    echo *** 2/6 *** �T�[�r�X���~���Ă��܂�...
    echo.
    net stop usosvc
    echo.
    net stop dosvc
    echo.
    net stop wuauserv
    echo.
    net stop bits

    echo.
    echo *** 3/6 *** Windows Update�֘A�̃t�H���_�ƃt�@�C�����폜���Ă��܂�...
    echo.
    rd /s /q %SystemRoot%\SoftwareDistribution.old
    echo.
    move %SystemRoot%\SoftwareDistribution %SystemRoot%\SoftwareDistribution.old
    echo.
    del %ALLUSERSPROFILE%\Microsoft\Network\Downloader\qmgr0.dat
    echo.
    del %ALLUSERSPROFILE%\Microsoft\Network\Downloader\qmgr1.dat

    echo.
    echo *** 4/6 *** �T�[�r�X���J�n���Ă��܂�...
    echo.
    net start bits
    echo.
    net start wuauserv
    echo.
    net start dosvc
    echo.
    net start usosvc

    echo.
    echo *** 5/6 *** Windows Update�̃X�L�������J�n���Ă��܂�...
    echo.
    %SystemRoot%\system32\usoclient.exe StartScan

    echo.
    echo *** 6/6 *** �������������܂����I
    echo.

)

if "%1"=="" (
    exit %ret_success%
)
if "%1"=="/b" (
    exit /b %ret_success%
)

rem ------------
rem  subrootins
rem ------------

:usage
echo [Usage]
echo %~n0        : �ʏ���s��A�R�}���h�v�����v�g���I�����܂��B
echo %~n0 /b     : �ʏ���s��A�R�}���h�v�����v�g�͏I�������܂���B
echo %~n0 /h     : Help��\�����܂��B
echo %~n0 --?    : Help��\�����܂��B
exit /b

:abort
echo (%~n0) %*
exit /b

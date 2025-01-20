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
    call :abort *** ERROR 2 *** 引数が誤っています。
    call :usage
    exit /b %ret_error2%
)

echo.
echo *** 1/6 *** 管理者権限チェック...
echo.
whoami /priv | find "SeDebugPrivilege" > nul
if %errorlevel% neq 0 (
    if "%1"=="/b" (
        @powershell start-process """%~0""" -ArgumentList """/b""" -verb runas
        call :abort *** ERROR 1 *** 管理者権限がありません。管理者権限で実行します。
        exit /b %ret_error1%
    ) else (
        @powershell start-process """%~0""" -verb runas
        call :abort *** ERROR 1 *** 管理者権限がありません。管理者権限で実行します。
        exit %ret_error1%
    )

) else (

    echo.
    echo *** 2/6 *** サービスを停止しています...
    echo.
    net stop usosvc
    echo.
    net stop dosvc
    echo.
    net stop wuauserv
    echo.
    net stop bits

    echo.
    echo *** 3/6 *** Windows Update関連のフォルダとファイルを削除しています...
    echo.
    rd /s /q %SystemRoot%\SoftwareDistribution.old
    echo.
    move %SystemRoot%\SoftwareDistribution %SystemRoot%\SoftwareDistribution.old
    echo.
    del %ALLUSERSPROFILE%\Microsoft\Network\Downloader\qmgr0.dat
    echo.
    del %ALLUSERSPROFILE%\Microsoft\Network\Downloader\qmgr1.dat

    echo.
    echo *** 4/6 *** サービスを開始しています...
    echo.
    net start bits
    echo.
    net start wuauserv
    echo.
    net start dosvc
    echo.
    net start usosvc

    echo.
    echo *** 5/6 *** Windows Updateのスキャンを開始しています...
    echo.
    %SystemRoot%\system32\usoclient.exe StartScan

    echo.
    echo *** 6/6 *** 処理が完了しました！
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
echo %~n0        : 通常実行後、コマンドプロンプトを終了します。
echo %~n0 /b     : 通常実行後、コマンドプロンプトは終了させません。
echo %~n0 /h     : Helpを表示します。
echo %~n0 --?    : Helpを表示します。
exit /b

:abort
echo (%~n0) %*
exit /b

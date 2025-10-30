@echo off
setlocal EnableDelayedExpansion

REM Default values
set "size=1000"
set "fstype=ext4"
set "label=casper-rw"
set "outputfile=persistent.dat"

goto :check_privileges

REM Function to print usage information
:print_usage
echo Usage:  create.bat [ -s size ] [ -t fstype ] [ -l label ] [ -o output file ]
echo   OPTION: (optional)
echo    -s --size size in MB, default is 1000
echo    -t --fstype filesystem type, options are ext2, ext3 and ext4, default is ext4
echo    -l --label label, default is "casper-rw"
echo    -o --output outputfile name, default is "persistent.dat"
echo    -h --help help
goto :eof

REM Function to print error message
:print_err
echo.
echo %*
echo.
goto :eof

REM Check if running with elevated privileges
:check_privileges
net session >nul 2>nul
if %errorLevel% neq 0 (
    call :print_err Please run the script as administrator.
    exit /b 1
)

REM Process command line arguments
:parse_args
if "%~1" == "" goto :check_args
if "%~1" == "-s" (
    set /a "size=%~2"
    shift
) else if "%~1" == "--size" (
    set /a "size=%~2"
    shift
) else if "%~1" == "-t" (
    set "fstype=%~2"
    shift
) else if "%~1" == "--fstype" (
    set "fstype=%~2"
    shift
) else if "%~1" == "-l" (
    set "label=%~2"
    shift
) else if "%~1" == "--label" (
    set "label=%~2"
    shift
) else if "%~1" == "-o" (
    set "outputfile=%~2"
    shift
) else if "%~1" == "--output" (
    set "outputfile=%~2"
    shift
) else if "%~1" == "-h" (
    goto :print_usage
) else if "%~1" == "--help" (
    goto :print_usage
) else (
    echo Unknown argumment "%~1".
    call :print_usage
    exit /b 1
)
shift
goto :parse_args

:check_args
REM Check label
if "%label%" == "" (
    call :print_err The label can NOT be empty.
    exit /b 1
)

REM Check size
set /a "vtminsize=1"
if %size% lss %vtminsize% (
    call :print_err Size too small %size% MB
    exit /b 1
)

REM Check fs type
if /i "%fstype%"=="ext2" goto :create_file
if /i "%fstype%"=="ext3" goto :create_file
if /i "%fstype%"=="ext4" goto :create_file
call :print_err %fstype% is not supported. The unique filesystems that are supported are ext2, ext3 and ext4.
exit /b 1

REM Create sparse file
:create_file
echo Creating %outputfile%
fsutil file createnew %outputfile% %size%000000 >nul
echo Setting valid data
fsutil file setvaliddata %outputfile% 0 >nul

REM Convert relative output path to full path
echo Getting full path of the file
set "relativepath=%outputfile%"
for %%A in ("%outputfile%") do (
    set "result1=%%~dpA"
    set "result1=!result1:~0,-1!"
    set "result2=%%~nxA"
)
set "outputfile="!result1!\!result2!""

REM Use ext2fsd tools to create ext4 filesystem
echo Creating %fstype% file system
echo y | ext2fsd\mke2fs -t %fstype% -q -L %label% %outputfile% >nul

echo %relativepath% was created succesfully with %size%000000 bytes and %fstype% file system.
exit /b 0

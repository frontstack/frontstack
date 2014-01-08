@ECHO OFF
::
:: FrontStack installation utility script for Windows
:: @author Tomas Aparicio
:: @license WTFPL
::

ECHO.
ECHO  -------------------------------------
ECHO         Welcome to FrontStack
ECHO  -------------------------------------
ECHO    Development environment made easy 
ECHO      for modern web projects 
ECHO  -------------------------------------
ECHO.
ECHO  Host requirements:
ECHO   * Windows XP/Vista/7/8 (64 bit)
ECHO   * 4GB RAM
ECHO   * 4GB HDD
ECHO   * Internet access (HTTP/S)
ECHO   * VirtualBox and Vagrant
ECHO.
ECHO  FrontStack installer script for Windows
ECHO.
ECHO  This process normally takes some time... please be patient
ECHO.


WHERE /Q git
IF ERRORLEVEL 1 (
  GOTO DISCOVER_GIT  
)

:CONTINUE

WHERE /Q vagrant
IF ERRORLEVEL 1 (
  IF NOT EXIST "%HOMEDRIVE%\HashiCorp\vagrant" (
    IF EXIST "%VAGRANT_HOME%" (
      GOTO SET_VAGRANT_PATH
    ) ELSE (
      ECHO Vagrant is required!
      ECHO Seems like Vagrant is not installed or not PATH accesible
      ECHO You must install it to continue
      PAUSE
      EXIT 1
    )
  )
)

:INSTALL

SET /P install_dir="Installation directory? [%USERPROFILE%]: " 
IF [%install_dir%]==[] (
  SET install_dir=%USERPROFILE%
) ELSE (
  IF NOT EXIST "%install_dir%" (
    ECHO.
    ECHO Error: the installation path do not exists: %install_dir%
    ECHO Enter a valid path and try it again
    ECHO.
    PAUSE
    EXIT 1
  )
)

IF EXIST "%install_dir%\frontstack" (
  ECHO 'frontstack' directory already exists
  ECHO You must remove it to continue
  PAUSE
  EXIT 1
)

:: change working diretory
cd "%install_dir%"
ECHO.

:: clone the repository
git clone https://github.com/frontstack/vagrant frontstack
:: enter it
cd "%install_dir%\frontstack"
ECHO.

:: start the vm
vagrant up

ECHO.
ECHO FrontStack Vagrant installed in 'frontstack/'
ECHO. 
ECHO 1. Run 'vagrant ssh' or connect via SSH to localhost:2222  
ECHO 2. Put your code in 'workspace/' directory
ECHO.
ECHO Thanks for using FrontStack
ECHO.

PAUSE
EXIT 0

DISCOVER_GIT:
:: if it's not in PATH, auto discover the git binary
IF EXIST "%LOCALAPPDATA%\Programs\Git\bin\git.exe" (
  SET PATH=%LOCALAPPDATA%\Programs\Git\bin;%PATH%
) ELSE (
  IF EXIST "%PROGRAMFILES%\Git\bin\git.exe" (
    SET PATH=%PROGRAMFILES%\Git\bin;%PATH%
  ) ELSE (
    IF EXIST "%PROGRAMFILES(x86)%\Git\bin\git.exe" (
      SET PATH=%PROGRAMFILES(x86)%\Git\bin;%PATH%
    ) ELSE (
       ECHO Git is required!
       ECHO Seems like Git is not installed. You must install it to continue
       PAUSE
       EXIT 1
    )
  )
)

GOTO CONTINUE


:SET_VAGRANT_PATH
SET PATH=%VAGRANT_HOME%:%PATH%
GOTO INSTALL
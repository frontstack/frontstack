@ECHO OFF
::
:: FrontStack installation utility script for Windows
:: @author Tomas Aparicio
:: @license WTFPL
::

ECHO.
ECHO -------------------------------------
ECHO         Welcome to FrontStack
ECHO -------------------------------------
ECHO   Development environment made easy 
ECHO      for modern web projects 
ECHO -------------------------------------
ECHO.
ECHO Host requirements:
ECHO  * Windows XP/Vista/7/8 (64 bit)
ECHO  * 4GB RAM
ECHO  * 4GB HDD
ECHO  * Internet access (HTTP/S)
ECHO.
ECHO FrontStack installer script for Windows
ECHO.
ECHO This process normally takes some time... please be patient
ECHO.

WHERE /Q git
IF ERRORLEVEL 1 (
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
)

WHERE /Q vagrant
IF ERRORLEVEL 1 (
  IF NOT EXIST "%HOMEDRIVE%\HashiCorp\vagrant" (
    ECHO Vagrant is required!
    ECHO Seems like Vagrant is not installed. You must install it to continue
    PAUSE
    EXIT 1
  )
)

IF EXIST frontstack (
  ECHO 'frontstack' directory already exists
  ECHO You must remove it to continue
  PAUSE
  EXIT 1
)

:: clone the repository
git clone https://github.com/frontstack/vagrant frontstack

cd frontstack
vagrant up

ECHO.
ECHO FrontStack Vagrant installed in '$installpath'
ECHO. 
ECHO 1. Customize the Vagrantfile
ECHO 2. Customize setup.ini and aditional provisioning scripts
ECHO 3. Run 'vagrant ssh' or connect to SSH localhost:2222  
ECHO 4. Put your code in the workspace directory
ECHO FrontStack installed sucessfully! 
ECHO.
ECHO Now you can access to the VM using a SSH client like putty
ECHO SSH server listening on localhost:2222
ECHO.

PAUSE
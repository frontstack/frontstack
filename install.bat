@ECHO OFF
::
:: FrontStack installation utility script for Windows
:: @author Tomas Aparicio
:: @license WTFPL
::

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
ECHO FrontStack installed sucessfully!
ECHO.
ECHO Now you can access to the VM using a SSH client like putty
ECHO SSH server listening on localhost:2222
ECHO.

PAUSE
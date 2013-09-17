#!/bin/bash
#
# FrontStack installation script
# @author Tomas Aparicio
# @version 0.1
# @license WTFPL
#

OUTPUTLOG='./frontstack.log'
INSTALLURL="https://github.com/frontstack/vagrant/archive/master.tar.gz"

exists() {
  type $1 >/dev/null 2>&1;
  if [ $? -eq 0 ]; then
    echo 1
  else
    echo 0
  fi
}

checkExitCode() {
  if [ $? -ne 0 ]; then
    echo $1
    exit 1
  fi
}

installRPM() {
  echo 'rpm'
}

installDEB() {
  echo 'deb'
}

downloadStatus() {
  if [ -f $1 ]; then
    while : ; do
      sleep 1

      local speed=$(echo `cat $1 | grep -oh '\([0-9.]\+[%].*[0-9.][s|m|h|d]\)' | tail -1`)
      echo -n "$speed"
      echo -n R | tr 'R' '\r'
      # evaluate exit code?
      if [ -f $2 ]; then
        sleep 1
        local error=$(echo `cat $2`)
        if [ $error != '0' ]; then
          if [ $error == '6' ]; then
            echo "Server authentication error, configure setup.ini properly. See $OUTPUTLOG"
          else
            echo "Download error, exit code $2. See $OUTPUTLOG"
          fi
          exit $?
        fi
        break
      fi
    done
  fi
}

# check OS architecture
if [ "`uname -m`" != "x86_64" ]; then
   echo "FrontStack only supports 64 bit based OS. Cannot continue"
   exit 1
fi

if [ "$(uname)" == "Darwin" ]; then
  OS='Darwin/OSX'    
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  OS='GNU/Linux'
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
  OS='Cygwin Windows' 
  echo 'Note that Cygwin platform is under experimental support'
else
  echo 'Platform not suported.'
  echo 'You probably are under Windows, so think about if you are a fucking loser'
  exit 1
fi

# discover the http client
DLBIN=`which curl`
if [ -n $DLBIN ]; then
  DLBIN=`which wget` ' -F '
fi

cat <<EOF
 -------------------------------------
         Welcome to FrontStack
 -------------------------------------
   A modern, modular, fully portable 
          and multilanguage 
     software stack solution for 
   modern Web projects development
 -------------------------------------

 OS detected: $OS

 Requirements:
  * 64 bits processor
  * GNU/Linux 64 bits
  * 768MB RAM
  * 1GB of hard disk free space
  * Internet access (HTTP/s protocol)
  * Root access level
  * VirtualBox
  * Vagrant


EOF

sleep 1

# checking prerequirements

$DLBIN http://yahoo.com > $OUTPUTLOG 2>&1
checkExitCode "No Internet HTTP connectivity.\nCheck if you are behind a proxy and your authentication credentials.\nSee $OUTPUTLOG"

if [ `exists VirtualBox` -eq 0 ]; then
  echo 'VirtualBox not found on the system.\nYou must install it before continue'
  echo 'https://www.virtualbox.org/wiki/Downloads'
  exit 1
fi

if [ `exists vagrant` -eq 0 ]; then
  echo 'Vagrant not found on the system.\nYou must install it before continue'
  echo 'http://downloads.vagrantup.com/'
  exit 1
fi


read -p 'Do you want to install FrontStack [Y/n]: ' res
if [ $res == 'n' ] || [ $res == 'N' ]; then
  echo 'Exiting'
  exit 0
fi

read -p "Installation path (defaults to '$HOME'): " installpath
if [ -z $installpath ]; then
  installpath=$HOME
else
  if [ ! -d $installpath ]; then
    echo "'$installpath' is not a directory or not exists. Exiting"
    exit 1
  fi
fi

echo 'Downloading file...'

`$DLBIN INSTALLURL` > $OUTPUTLOG 2>&1
checkExitCode "Error while downloading the package... See $OUTPUTLOG"





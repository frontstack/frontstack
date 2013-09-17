#!/bin/bash
#
# FrontStack installation script
# @author Tomas Aparicio
# @version 0.1
# @license WTFPL
#

OUTPUTLOG='./frontstack.log'
DOWNLOAD="https://github.com/frontstack/vagrant/archive/master.tar.gz"
FILENAME='frontstack-vagrant.tar.gz'

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
if [ `exists curl` -eq 1 ]; then
  DLBIN="`which curl` -L -s -o $FILENAME " 
else
  DLBIN="`which wget` -F -O $FILENAME "
fi

cat <<EOF

 -------------------------------------
         Welcome to FrontStack
 -------------------------------------
   Development environment made easy 
       for modern web projects 
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
checkExitCode "No Internet HTTP connectivity. Check if you are behind a proxy and your authentication credentials. See $OUTPUTLOG"
if [ -f "./index.html" ]; then
  rm -rf "./index.html"
fi

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
  installpath=$HOME/frontstack
else
  if [ ! -d $installpath ]; then
    echo "'$installpath' is not a directory or not exists. Exiting"
    exit 1
  fi
fi

if [ ! -d $installpath ]; then
  mkdir "$installpath"
  checkExitCode "Cannot create the installation directory '$installpath'. Cannot continue"
else
  if [ -f $installpath/Vagrantfile ]; then
    echo "Another installation was found in '$installpath'"
    read -p 'Do you want to override it? [Y/n]: ' res
    if [ $res == 'n' ] || [ $res == 'N' ]; then
      echo 'Exiting'
      exit 0
    fi
  fi
fi

echo 'Downloading FrontStack Vagrant files...'

$DLBIN $DOWNLOAD > $OUTPUTLOG 2>&1
checkExitCode "Error while downloading the package... See $OUTPUTLOG"

tar xvfz ./$FILENAME -C "$installpath" >> $OUTPUTLOG 2>&1
checkExitCode "Error while uncompressing the package... See $OUTPUTLOG"

# move files
cp -R "$installpath/vagrant-master/* $installpath"
rm -rf "$installpath/vagrant-master"

# clean files
rm -rf $FILENAME
rm -rf $OUTPUTLOG

cat <<EOF

FrontStack VM config installed in '$installpath'

1. Customize the Vagrantfile
2. Customize scripts/setup.ini
3. Run $ vagrant up
4. Enjoy and code!

EOF


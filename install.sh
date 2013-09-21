#!/bin/bash
#
# FrontStack installation script
# @author Tomas Aparicio
# @version 0.1
# @license WTFPL
#
# Optional arguments:
#   -f <1>            [force installation without asking]
#   -p <installpath>  [installation path]
#

output='frontstack.log'
vagrant_download="https://github.com/frontstack/vagrant/archive/master.tar.gz"
filename='frontstack-vagrant.tar.gz'
testcon='test.html'
virtualize=1

clean_files() {
  rm -rf $filename
  rm -rf $output
  rm -rf $testcon
}

exists() {
  type $1 >/dev/null 2>&1;
  if [ $? -eq 0 ]; then
    echo 1
  else
    echo 0
  fi
}

check_exit() {
  if [ $? -ne 0 ]; then
    echo $1
    clean_files
    [ -z $2 ] && exit 1
  fi
}

installion_success() {
      cat <<EOF

FrontStack Vagrant installed in '$installpath'

1. Customize the Vagrantfile
2. Customize setup.ini and aditional provisioning scripts
3. Run $ vagrant up 
4. Start coding!

EOF
}

# check OS architecture
if [ "`uname -m`" != "x86_64" ]; then
   echo "FrontStack only supports 64 bit OS. Cannot continue"
   exit 1
fi

if [ "$(uname)" == "Darwin" ]; then
  os='Darwin/OSX'    
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  os='GNU/Linux'
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
  os='Cygwin Windows' 
  echo 'Note that Cygwin platform is under experimental support'
else
  echo 'Platform not suported.'
  echo 'You probably are under Windows, so think about if you are a fucking loser'
  exit 1
fi

# discover the http client
if [ `exists curl` -eq 1 ]; then
  dl_binary="`which curl` -L -s -o " 
else
  dl_binary="`which wget` -F -O "
fi

cat <<EOF

 -------------------------------------
         Welcome to FrontStack
 -------------------------------------
   Development environment made easy 
       for modern web projects 
 -------------------------------------

 OS detected: $os

 Requirements:
  * 64 bit OS
  * 2GB RAM
  * 2GB of hard disk free space
  * Internet access (HTTP/s protocol)
  * VirtualBox
  * Vagrant 


EOF

# checking prerequirements

`$dl_binary $testcon http://yahoo.com > $output 2>&1`
check_exit "No Internet HTTP connectivity. Check if you are behind a proxy and your authentication credentials. See $output"
if [ -f "./$testcon" ]; then
  rm -rf "./$testcon"
fi

if [ $os == 'GNU/Linux' ]; then
  echo 'You are running GNU/Linux :)'
  read -p 'Do you want to virtualize FrontStack anyway? [Y/n]: ' res 
  if [ $res != 'y' ] && [ $res != 'Y' ]; then
    virtualize=0
  fi 
fi

if [ $virtualize == '1' ]; then
  if [ `exists VirtualBox` -eq 0 ]; then
    echo 'VirtualBox not found on the system. You must install it before continue'
    echo 'https://www.virtualbox.org/wiki/Downloads'
    exit 1
  fi

  if [ `exists vagrant` -eq 0 ]; then
    echo 'Vagrant not found on the system. You must install it before continue'
    echo 'http://downloads.vagrantup.com/'
    exit 1
  fi
fi

while getopts "f:p:" OPTION; do
  case "$OPTION" in
    f)
       force=1
       ;;
    p)
       installpath="$OPTARG"
       ;;
  esac
done

if [ -z $force ]; then 
  read -p 'Do you want to install FrontStack [Y/n]: ' res
  if [ $res == 'n' ] || [ $res == 'N' ]; then
    echo 'Exiting'
    exit 0
  fi
fi

# supports first argument for path installation
if [ -z $installpath ]; then
  read -p "Installation path (defaults to '$HOME'): " installpath
fi

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
  check_exit "Cannot create the installation directory '$installpath'. Cannot continue"
else
  if [ -z $force ] && [ -f $installpath/Vagrantfile ]; then
    echo "Another installation was found in '$installpath'"
    read -p 'Do you want to override it? [Y/n]: ' res
    if [ $res == 'n' ] || [ $res == 'N' ]; then
      echo 'Exiting'
      exit 0
    fi
  fi
fi

echo 'Downloading FrontStack Vagrant files...'

`$dl_binary $filename $vagrant_download > $output 2>&1`
check_exit "Error while downloading the package Vagrant from Github... See $output"

tar xvfz ./$filename -C "$installpath" >> $output 2>&1
check_exit "Error while uncompressing the package... See $output"

# move files to root directory
cp -R "$installpath"/vagrant-master/* "$installpath"

# clean files
rm -rf "$installpath/vagrant-master"
clean_files

if [ $virtualize != '1' ]; then
  sudo bash $installpath/scripts/setup.sh
  installion_success
else
  # configure Vagrant
  if [ $(exists `vagrant plugin list | grep vagrant-vbguest`) -eq 1 ]; then
    echo 'Configuring Vagrant...'
    vagrant plugin install vagrant-vbguest >> $output 2>&1
    check_exit "Error while installing Vagrant plugin... See $output" 1
  fi

  # auto start VM
  if [ -z $force ]; then
    echo 
    read -p 'Do you want to start the VM [y/N]: ' res
    if [ $res == 'y' ] || [ $res == 'Y' ]; then
      cd $installpath
      vagrant up
    else 
      installion_success
    fi
  else
    installion_success
  fi
fi
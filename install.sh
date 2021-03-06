#!/bin/bash
#
# FrontStack installation script
# @author Tomas Aparicio
# @version 0.3
# @license WTFPL
#
# Optional arguments:
#   -f                [force installation without asking]
#   -p <installpath>  [installation path]
#

output='frontstack.log'
fs_download='http://sourceforge.net/projects/frontstack/files/latest/download'
vagrant_download="https://github.com/frontstack/vagrant/archive/master.tar.gz"
filename='frontstack-vagrant.tar.gz'
temp_download='/tmp/frontstack-latest.tar.gz'
status_download='/tmp/frontstack-download'
testcon='test.html'
install_script=$1
virtualize=1

clean_files() {
  rm -rf $filename
  rm -rf $output
  rm -rf $testcon
  rm -rf $temp_download
  rm -rf $status_download
  rm -rf $install_script
}

exit_clean() {
  clean_files
  exit $1
}

exit_ok() {
  echo $1
  clean_files
  exit 0
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
    clean_files
    while [ -n "$1" ]; do
       echo $ARGS "$1"
       shift
    done
    exit 1
  fi
}

download_status() {
  if [ -f $1 ]; then
    while : ; do
      sleep 1

      local speed=$(echo `cat $1 | grep -oh '\([0-9.]\+[%].*[0-9.][s|m|h|d]\)' | tail -1`)
      echo -n "Downloading... $speed"
      echo -n R | tr 'R' '\r'

      if [ -f $2 ]; then
        sleep 1
        local error=$(echo `cat $2`)
        if [ $error != '0' ]; then
          echo 
          if [ $error == '6' ]; then
            echo "Server authentication error, configure setup.ini properly. See $output"
          else
            echo "Download error, exit code '$error'. See $output"
          fi
          exit $?
        fi
        break
      fi
    done
  fi
}

start_vm() {
  clean_files
  cd $installpath
  vagrant up
}

installation_success() {
      cat <<EOF
FrontStack Vagrant installed in '$installpath'

1. Customize the Vagrantfile
2. Customize setup.ini and aditional provisioning scripts
3. Run 'vagrant up' 
4. Put your code in the workspace directory

EOF
}

if [ "$(uname)" == "Darwin" ]; then
  os='Darwin/OSX'    
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  os='GNU/Linux'
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
  os='Cygwin Windows' 
  echo 'Note that Cygwin platform is under experimental support'
else
  echo 'Platform not suported.'
  exit 1
fi
 
# discover the http client binary
if [ `exists curl` -eq 1 ]; then
  dl_binary="`which curl` -L -s -o " 
else
  dl_binary="`which wget` -F -O "
fi

cat <<EOF

 --------------------------------------
         Welcome to FrontStack
 --------------------------------------
   Development environment stack made
     easy for modern web projects 
 --------------------------------------

 OS detected: $os

 Requirements:
  * GNU/Linux 64 bit
  * 512MB RAM (>=768MB recommended)
  * 2GB HDD
  * Internet access (HTTP/S)


EOF

# check OS architecture
if [ "`uname -m`" != "x86_64" ]; then
   echo "FrontStack only supports 64 bit OS. Cannot continue"
   exit 1
fi

if [ $os == 'GNU/Linux' ]; then
  echo 'You are running GNU/Linux :)'
  echo 'Note that you can use FrontStack without virtualization!'
  echo
  read -p 'Do you want to virtualize anyway? [N/y]: ' res
  if [ ! -z $res ]; then 
    if [ $res != 'y' ] && [ $res != 'Y' ]; then
      virtualize=0
    fi
  else
    virtualize=0
  fi
  sleep 1
fi

if [ $virtualize == '1' ]; then
  if [ `exists VirtualBox` -eq 0 ]; then
    echo 'VirtualBox not found on the system. You must install it before continue'
    echo 'https://www.virtualbox.org/wiki/Downloads'
    exit_clean 1
  fi

  if [ `exists vagrant` -eq 0 ]; then
    echo 'Vagrant not found on the system. You must install it before continue'
    echo 'http://downloads.vagrantup.com/'
    exit_clean 1
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

# supports first argument for path installation
if [ -z $installpath ]; then
  read -p "Installation path (defaults to '$HOME/frontstack'): " installpath
fi

if [ -z $installpath ]; then
  installpath=$HOME/frontstack
else
  if [ ! -d $installpath ]; then
    echo "'$installpath' is not a directory or not exists. Exiting"
    exit_clean 1
  fi
fi

if [ ! -d $installpath ]; then
  mkdir "$installpath"
  check_exit "Cannot create the installation directory '$installpath'. Cannot continue"
else
  if [ -z $force ] && [ -f $installpath/Vagrantfile ]; then
    echo "Another installation was found in '$installpath'"
    read -p 'Do you want to override it? [Y/n]: ' res
    if [ -z $res ] || [ $res == 'n' ] || [ $res == 'N' ]; then
      echo 'Exiting'
      exit_clean 0
    fi
  fi
fi

if [ $virtualize == '0' ]; then
  echo 
  `wget -F $fs_download -O $temp_download > $output 2>&1 && echo $? > $status_download || echo $? > $status_download` &
  download_status $output $status_download
  check_exit "Error while downloading FrontStack" "Check if you have Internet connection" "Ouput log: $output"

  echo -n 'Extracting (this may take some minutes)... '
  tar xvfz $temp_download -C "$installpath" >> $output 2>&1
  echo 'done!'

  cat <<EOF

FrontStack installed in: "$installpath"

To have fun, simply run:
$ $installpath/bash.sh

EOF

else

  echo 'Downloading FrontStack Vagrant files...'

  `$dl_binary $filename $vagrant_download > $output 2>&1`
  check_exit "Error while downloading the package Vagrant from Github... See $output"

  tar xvfz ./$filename -C "$installpath" >> $output 2>&1
  check_exit "Error while uncompressing the package... See $output"

  # move files to root directory
  cp -R "$installpath"/vagrant-master/* "$installpath"

  # clean files
  rm -rf "$installpath/vagrant-master"

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
    if [ ! -z $res ]; then
      if [ $res == 'y' ] || [ $res == 'Y' ]; then
        start_vm
      else 
        installation_success
      fi
    else
      # force VM setup from bash installation      
      start_vm
    fi
  else
    installation_success
  fi

fi

clean_files

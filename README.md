# FrontStack

Self-contained, portable and ready-to-run GNU/Linux x64 software stack for modern web projects development.

`FrontStack is in beta stage`

## About

FrontStack aims to provide a complete development environment for 
modern Front End web projects based on a technologic stack powered by Node.js, Ruby or Python.

Forget about dev environments, just code!

## Installation

### GNU/Linux

1. Download the tarball
```
$ wget https://sourceforge.net/projects/frontstack/files/latest/download -O frontstack-latest.tar.gz
```

2. Then install it in a custom path
```
$ tar xvfz frontstack-latest.tar.gz -C $HOME/fronstack
```

3. Use the environment specific variables
```
$ cd ~/frontstack && ./bash.sh
```

### Other OS (virtualized)

You can use FrontStack in other OS easily using VirtualBox and Vagrant

1. Download [Virtualbox](https://www.virtualbox.org/wiki/Downloads) for your OS (64 bits)

2. Download [Vagrant](http://downloads.vagrantup.com/) for your OS (64 bits)

3. Download FrontStack for VM installations

Run the auto intallation script
```
$ curl -s https://raw.github.com/frontstack/frontstack/master/install.sh > install.sh && bash install.sh
```

or [download](https://github.com/frontstack/vagrant/archive/master.zip) it manually

4. Customize `Vagrantfile` and `setup.ini` (optionally)

5. Run `$ vagrant up`

##### Virtualization troubles

If you have some Virtualbox problems while trying to boot the VM and get a message like 
`processor architecture is not 64 bits` and you are sure your processor it is, you should 
try to enable the VT-x/AMD virtualization technology from your BIOS.

## Software stack

See the [stack repository](https://github.com/frontstack/stack) for more information about the software stack included

## Issues 

FrontStack is in beta stage, some things maybe are broken.
Please, feel free to report any issue you experiment.

## Author

* [Tomas Aparicio](https://github.com/h2non) 

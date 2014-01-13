# FrontStack

Self-contained, portable and ready-to-run GNU/Linux software stack for modern web development

## About

FrontStack aims to provide a complete development environment for 
modern web development based on a software stack powered by Node.js, Ruby and Python

Forget about development environments, just code!

## Features

- GNU/Linux
- 64 bits (yes! we're in 2014, it's time to switch)
- Multiplatform (using VirtualBox and Vagrant)
- Fully self-contained without OS-level shared libraries dependencies
- Great isolation from the OS
- Configurable from an `ini` file
- Support for package provisioning
- Easy to install and use
- Easy to use from CI and deployment environments
- Support for software stack updates
- Pre-installed dev tools like Grunt, Yeoman, Bower, Compass and more

## Why FrontStack?

- GNU/Linux is a consistent and reliable UNIX-like OS
- Fully portable (runs in any GNU/Linux distro)
- No OS configuration setup or specific requirements
- Virtualization today is lightweight, do not fear it!
- Unique environment: reproducible, consistent, reliable
- Avoid provide support or maintain multiple platforms or dev environments
- Most CI servers runs GNU/Linux, provide the same environment to the end developers
- Automatically package provisioning
- Pre-installed common dev tools like Grunt, Yeoman, Bower and Compass

## Installation
        
### Virtualized 

You can easily run FrontStack in any OS using VirtualBox and Vagrant

1. Download [Virtualbox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](http://downloads.vagrantup.com/) for your OS (64 bit)

2. Download FrontStack for virtual installations

  Run the installation script
  ```
  $ curl -s https://raw.github.com/frontstack/frontstack/master/install.sh | bash
  ```

  If are an unlucky guy and you are running Windows, you can use the [install.bat][1] script (Git required)

3. Customize `Vagrantfile` and `setup.ini` (optionally)

4. From the `Vagrantfile` directory, run: 
  
  ```
  $ vagrant up 
  ```

  and if all goes fine, run:
  ```
  $ vagrant ssh
  ```

### Manual installation for GNU/Linux

1. Download the tarball
```
$ wget https://sourceforge.net/projects/frontstack/files/latest/download -O frontstack-latest.tar.gz
```

2. Then install it in a custom path
```
$ mkdir ~/frontstack/ && tar xvfz frontstack-latest.tar.gz -C ~/frontstack
```

3. Use the environment specific bash session
```
$ cd ~/frontstack && ./bash.sh
```

If you want to load the environment variables on each bash session, add in your `~/.bash_profile` the following line:

```shell
[ -f ~/frontstack/scripts/setenv.sh ] && . ~/frontstack/scripts/setenv.sh
```

#### Possible virtualization troubles

##### Processor architecture

If you have some Virtualbox problems while trying to boot the VM and get a message like 
`processor architecture is not 64 bits` and you are sure your processor it is, you should 
try to enable the VT-x/AMD virtualization technology from your BIOS.

##### VBox Guest Additions version mismatch

To avoid issues with the VirtualBox Guest Additions installation and versions mismatch, 
you should install the `vagrant-vbguest` plugin

From the Vagrantfile directory, run:
```
$ vagrant plugin install vagrant-vbguest
```

## Update 

You can easily upgrade the whole FrontStack environment running:

```shell
$ frontstack update
```

The update script is located in `frontstack/scripts/update.sh`

Note that all files and directories will be overwritten, except the `packages/` directory.

You probably will need to instal Node or Ruby packages via it's own package manager, right? And what happens if I do an upgrade?
All the Node packages or Ruby gems you install during your development will be installed at the `packages/` directory and this will be ignored by the update process, so all the packages will remain after updates.

## Configuration

You can easily configure the FrontStack from a simple `setup…ini` file (see the [Vagrant][2] repository)

Here a complete `setup.ini` example file. You should comment the options you don't need

```ini
[frontstack]
;; guest OS installation path
fs_install=/home/vagrant/frontstack
;; frontstack tarball URL to download
fs_download=http://sourceforge.net/projects/frontstack/files/latest/download
;; http credentials to download the tarball, if it's required
fs_http_user=john
fs_http_password=1234
;; tarball compression format, supported: tar.gz, zip and 7z
fs_format=tar.gz
;; user to asign permissiongs to frontstack files
fs_user=vagrant
;; flush iptables rules and allow all by default
fs_reset_firewall=1

[proxy]
http_proxy=http://my.proxy:3128
https_proxy=https://ssl.proxy:3128
no_proxy=.company.com
;; proxy auth credentials, if it's required
proxy_user=john
proxy_password=1234

[provision]
;; list of OS packages to install (whitespace separated)
install_packages=git nmap
;; customized post-install bash script (runs on guest machine)
install_script=/home/vagrant/setup/post-install.sh
;; Node.js packages to install (whitespace separated)
npm=http-server harp
;; Ruby gems to install (whitespace separated)
gem=heel sinatra
```

## FrontStack CLI

```
  FrontStack CLI commands:

  update
    Update FrontStack if new versions are available
  version  
    Show the current FrontStack version
  where [package]
    Show path where a given packages is located
  info
    Show FrontStack project useful links
  help
    Show this info

  Examples:

  $ fronstack update
  $ fronstack where ruby

```

## Requirements

See the [stack requirements](https://github.com/frontstack/stack#requirements)

## Software stack

* Node 
  * npm 
  * Yeoman 
  * Grunt CLI
  * Bower
  * Croak
  * Node-gyp 
  * CoffeeScript
* Ruby 
  * RubyGems
  * Compass
  * Sass
* Python 
* PhantomJS
* SlimerJS 
* CasperJS

See the [stack repository](https://github.com/frontstack/stack) for more information and specific versions

For new packages requests, please [open](https://github.com/frontstack/stack/issues) a Github issue with your request

## Issues 

FrontStack is still in beta stage.
Please, feel free to report any issue you experiment via Github.

## Author

* [Tomas Aparicio](https://github.com/h2non) 


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/frontstack/frontstack/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

[1]: https://github.com/frontstack/frontstack/raw/master/install.bat
[2]: https://github.com/frontstack/vagrant

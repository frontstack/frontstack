# FrontStack

Self-contained, portable and ready-to-run GNU/Linux x64 software stack for modern web projects development.

`FrontStack is in beta stage`

## About

FrontStack aims to provide a complete development environment for 
modern Front End web projects based on a technologic stack powered by Node.js, Ruby or Python.

Forget about dev environments, just code!

## Installation

### Virtualized

You can easily run FrontStack in any OS using [VirtualBox](https://www.virtualbox.org) and [Vagrant](http://vagrantup.com)

1. Download [Virtualbox](https://www.virtualbox.org/wiki/Downloads) for your OS (64 bits)

2. Download [Vagrant](http://downloads.vagrantup.com/) for your OS (64 bits)

3. Download FrontStack for virtual installations

  Run the intallation script
  ```
  $ curl -s https://raw.github.com/frontstack/frontstack/master/install.sh > install.sh && bash install.sh
  ```

  or [download](https://github.com/frontstack/vagrant/archive/master.zip) it manually (generally under Windows)

4. Customize `Vagrantfile` and `setup.ini` (optionally)

5. From the `Vagrantfile` directory, run: 
  
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
$ tar xvfz frontstack-latest.tar.gz -C $HOME/fronstack
```

3. Use the environment specific variables
```
$ cd ~/frontstack && ./bash.sh
```

If you want to load the environment variables on each bash session, add in your `~/.bash_profile` the following line:

```shell
[ -f ~/fronstack/scripts/setenv.sh ] && . "~/fronstack/scripts/setenv.sh"
```

##### Possible virtualization troubles

If you have some Virtualbox problems while trying to boot the VM and get a message like 
`processor architecture is not 64 bits` and you are sure your processor it is, you should 
try to enable the VT-x/AMD virtualization technology from your BIOS.

## Update 

You can easily upgrade the whole FrontStack environment simply running the following script:

```shell
$  ~/scripts/update.sh
```

Note that all files and directories will be overwritten, except the `packages/` directory.

You probably will need to instal Node or Ruby packages via it's own package manager, right? And what happens if I do an upgrade?
All the Node packages or Ruby gems you install during your development will be installed at the `packages/` directory and this will be ignored by the update process, so all the packages will remain after updates.

## Software stack

* Node 
  * npm 
  * Yeoman 
  * Grunt-cli 
  * Bower 
  * Node-gyp 
* Ruby 
  * RubyGems 
  * Compass
  * Sass
  * eventmachine
  * Rake 
* Python 
* PhantomJS
* SlimerJS 
* CasperJS

See the [stack repository](https://github.com/frontstack/stack) for more information about versions

For new packages requests, please [open](https://github.com/frontstack/stack/issues) a Github issue with your request.

## Issues 

FrontStack is in beta stage, some things maybe are broken.
Please, feel free to report any issue you experiment via Github.

## Author

* [Tomas Aparicio](https://github.com/h2non) 

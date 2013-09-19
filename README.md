# FrontStack Vagrant

### `Still beta`

A Fully portable, self-contained, generic, modular and multi-language development environment stack for GNU/Linux 64 bits based OS for Front End projects.

# Getting started

## Host requirements

  * 64 bit processor
  * GNU/Linux 64 bits
  * 1GB RAM
  * 1GB of hard disk free space
  * Internet access (HTTP/S)

## Installation

### GNU/Linux

Simply download the setup.sh and configure the setup.ini file with your custom settings.

You can provision you machine downloading a full stack release version (tar.gz, 7z , package-specific OS) or publish the individual packages in your own repository.
See the development documentation (TODO)

### Others

The FrontStack distribution is only available for GNU/Linux, however you can use it in  other OS easily using VirtualBox and Vagrant

1. Download [Virtualbox](https://www.virtualbox.org/wiki/Downloads) for your OS (64 bits)
2. Download [Vagrant](http://downloads.vagrantup.com/) for your OS (64 bits)
3. Download [FrontStack] for VM installations
4. Customize `Vagrantfile` and `setup.ini`
5. Run `$ vagrant up`

##### Virtualization troubles

If you have some Virtualbox problems while trying to boot the VM and get a message like 
`processor architecture is not 64 bits` and you are sure your processor it is, you should 
try to enable the VT-x/AMD virtualization technology from your BIOS.

## Customize FrontStack

`TODO...`

## TODO

* Vagrant plugin

## Authors

* [Tomas Aparicio](https://github.com/h2non) 

## License

Code under [WTFPL](http://www.wtfpl.net/txt/copying/) license

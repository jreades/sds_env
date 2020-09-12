# Running SDS using Vagrant

## Installing Vagrant
The steps for this are fairly straightforward. You will need to:
- Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- Download and install [Vagrant](https://www.vagrantup.com/downloads).
- Download a copy of the [Vagrantfile](https://github.com/jreades/sds_env/raw/master/vagrant/Vagrantfile) in an easy-to-find place on your computer (I would suggest your 'Documents' folder or a 'CASA' folder below that).

## Creating the Virtual Machine
Now that you've got all of the pieces saved to your computer, you need to:
- Launch the Terminal or PowerShell
- Navigate to the directory where you saved the Vagrantfile (_e.g._ `cd ~/Docouments/` or `cd ~/Documents/CASA/`).
- Run `vagrant up` and then wait while Vagrant builds you new a virtual machine (this will take about 30 minutes, download about 6GB of data, and use up about 8GB of space on your computer's hard drive).

## When the Virtual Machine is Running
It can be hard to tell when things are done, especially when it takes 30 minutes or more the _first_ time you do it (after this startup will take seconds). You are looking for this message:
```shell
==> default: Running provisioner: shell...
    default: Running: inline script
    default: Running docker start-up script...
    default: b5b6aae6b9ba0913dfe3f5dc6c233c422ad48e099daf2941e5aec843b58e3714
    default: Ready on localhost:8888
```
You can now point your browser to [localhost:8888](http://localhost:8888) where you should see this:
![JupyterLab login](https://github.com/jreades/sds_env/raw/master/vagrant/img/Login.png)

You can now type in the password to access JupyterLab. By default (if you are following this course as part of your Master's degree or you are following along on your own) this will be `casa` + the academic year (_e.g._: 2021 or 2122).

If you have successfully logged in you will see this:
![JupyterLab UI](https://github.com/jreades/sds_env/raw/master/vagrant/img/JupyterLab.png)

**Do _not_ create a new Notebook yet!**

## Creating Notebooks

Notice that on the left-hand side is a diretory (folder) called `work`. This is where you should save your work! Double-click on the `work` folder to open it.

Click on the 'Notebook' icon with the label `Python 3` or `SDS 2020` (if you see _both_ of these then pick `SDS 2020`). This will create a new Notebook called `Untitled.ipynb`.

Right-click (Ctrl+Click on a Mac) on `Untitled.ipynb` and then select `Rename Notebook...`. Give your Notebook the name `Hello World.ipynb`.

In the small blue-bordered area just beneath that type `print("hello world!")` and click the 'Play' button just above. You should see `hello world!` appear just beneath. You have just run Python code on your own computer.

## Saving Your Work

Now click the 'Save' icon before picking `File` > `Close and Shutdown Notebook` and confirming with the `OK` that you want to shut it down. You should see `Hello World` in the file list on the left side of the browser window.

### But here's the trick!

You can hide this browser window and go back to your computer's Finder (Mac) or Explorer (PC). In the folder where you saved your `Vagrantfile` you should now see a _new_ folder called `notebooks` and, inside that, a file called... `Hello World.ipynb`.

<img src="https://github.com/jreades/sds_env/raw/master/vagrant/img/Finder.png" width="400" />

This is how you get data _into_ the Virtual Machine and code, figures, and results _out_ of the Virtual Machine. If you don't put your data in a folder underneath `notebooks` on _your_ computer then the Virtual Machine _cannot_ see it. If you don't save your figures, code, and results into `work` on _the Virtual Machine_ then you won't be able to find it on your computer.

## Shutting Down 

The _safest_ way to shut down is:

1. In the JupyterLab window select `File` and then `Shut Down` (see screenshot below). 
2. In a Terminal/Powershell window type `vagrant halt` and then hit 'Return' to execute the code.

![JupyterLab Shutdown](https://github.com/jreades/sds_env/raw/master/vagrant/img/Shutdown.png)

Happy coding!


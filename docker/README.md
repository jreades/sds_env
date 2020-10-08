# Using Docker

You will need [Docker](https://www.docker.com) (Desktop) to be able to install the Spatial Data Science (SDS) environment. If you do not wish to create an account with Docker then you may want to follow advice [provided here](https://github.com/docker/docker.github.io/issues/6910#issuecomment-532393783) though we cannot condone it.

#### Installing

You can then install this container by opening up a Shell/Terminal and simply running:

> `docker pull jreades/sds:2020`

#### Running

The container can be run in the Shell or Terminal as:

> `docker run --name sds --rm -ti -p 8888:8888 -v "$(pwd):/home/jovyan/work" jreades/sds:2020 jupyter lab --LabApp.password='sha1:288f84f833b0:7645388b889d84efbb2716d646e5eadd78b67d10'`

**Note**: the `pwd` in the command above means use the _current_ directory. So if you simply open a Terminal, Git Bash, or Command Prompt then Docker will 'mount' (_i.e._ make visible to the programming environment) the current directory as `work` in the programming environment. This is most likely to be your home directory and means that _everything_ in your home directory is potentially delete-able or write-able and that is a major security risk. I would _strongly_ suggest that you `cd` (Change Directory) to a sub-folder along the lines of `./Documents/CASA/` so that you have the link `work <-> CASA` between the virtual machine that Docker is running and your computer (which is the 'host'). Obviously, this assumes that you've created a CASA directory in your Documents folder and you can revise according to what you have done instead!

Anyway, assuming that you have run the command above exactly as explained, then you will then be able to point your browser to [localhost:8888](localhost:8888/lab?). You are likely to be prompted to enter a **Password**. This password is currently `casa2021`.

A couple of notes on the command above:

* This opens the `8888` port of the container, so to access the Lab instance,
  you will have to point your browser to `[localhost:8888](localhost:8888/lab/)`.
* The command also mounts the current folder (`pwd`) for the container, but you can replace that with the path to any folder on your local machine (in fact, that will only work on host machines with the `pwd` command installed)
* The `name` ensures that you don't accidentally run three versions of the same Docker image!

#### Deleting

Should you wish to remove the image and container from your system then the following approaches are available:

##### Deleting by Filter

This should be used with some care since it will try to delete all matching images and this may not be what you want:

```bash
docker ps -aqf "name=sds" --format="{{.Image}} {{.Names}} {{.ID}}" | grep "2019" | cut -d' ' -f3 | xargs docker rm -f
docker images --format="{{.Repository}} {{.Tag}} {{.ID}}" | grep "sds" | cut -d' ' -f3 | xargs docker rmi
```

##### Deleting by Image

```bash
docker ps -aq # Get list of running processes and work out container IDs to remove
docker rm -f <list of container IDs>
docker images # Get list of available images and work out image IDs to remove
docker rmi -f <list of image IDs>
```

## Citing

This draws heavily on Dani Arribas-Bel's work for Liverpool. If you use this, you should cite him.

[![DOI](https://zenodo.org/badge/65582539.svg)](https://zenodo.org/badge/latestdoi/65582539)

```bibtex
@software{hadoop,
  author = {{Dani Arribas-Bel}},
  title = {\texttt{gds_env}: A containerised platform for Geographic Data Science},
  url = {https://github.com/darribas/gds_env},
  version = {3.0},
  date = {2019-08-06},
}
```

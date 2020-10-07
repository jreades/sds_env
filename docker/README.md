# Using Docker

You will need [Docker](https://www.docker.com) (Desktop) to be able to install the Spatial Data Science (SDS) environment. If you do not wish to create an account with Docker then you may want to follow advice [provided here](https://github.com/docker/docker.github.io/issues/6910#issuecomment-532393783) though we cannot condone it.

#### Installing

You can then install this container by opening up a Shell/Terminal and simply running:

> `docker pull jreades/sds:2020`

#### Running

The container can be run in the Shell or Terminal as:

> `docker run --name sds --rm -ti -p 8888:8888 -v "$(pwd):/home/jovyan/work" jreades/sds:2020 jupyter lab --LabApp.password='sha1:288f84f833b0:7645388b889d84efbb2716d646e5eadd78b67d10'`

When you run this command you will then be able to point your browser to [localhost:8888](http://127.0.0.1:8888/lab?). You are likely to be prompted to enter a **Token**. The token should have been shown in the Shell/Terminal output shortly after you ran the above command: you can copy+paste this into the web page and should then see something like the below in your browser window:

<img src="../vagrant/img/JupyterLab.png" width="500">

A couple of notes on the command above:

* This opens the `8888` port of the container, so to access the Lab instance,
  you will have to point your browser to `[localhost:8888](http://localhost:8888/lab/)`.
* The command also mounts the current folder (`pwd`) for the container, but you can replace that with the path to any folder on your local machine (in fact, that will only work on host machines with the `pwd` command installed)
* The `name` ensures that you don't accidentally run three versions of the same Docker image!

We've put together a video (without audio!) of how to do this on a Mac and the process should be similar on a Windows machine:

[![You Tube Video](http://img.youtube.com/vi/5rh_bwxzjNs/0.jpg)](https://www.youtube.com/watch?v=5rh_bwxzjNs)

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

# `sds_env`: Spatial Data Science Platform

This is a fork from [Dani's work](https://github.com/darribas/gds_env) (**please see below for citing**) to remove R as we don't need this for teaching but do have a few more Python packages that we _do_ use. We've also added some JupyterLab extensions to make interacting with the Lab server a bit easier.

This repository contains _four_ approaches to installation:

1. [VirtualBox](./virtualbox/README.md): easiest, though some 'gotchas' on **Windows 10 _Home_**.
2. [Vagrant](./vagrant/README.md): straightforward, but requires basic comfort with command line and file system.
3. [Docker](./docker/README.md): most powerful, but requires a lot more comfort with command line and file system.
4. [Anaconda Python](./conda/README.md): direct installation when all else fails (_i.e_ on Windows 10 Home).

We are progressively migrating away from local installation via `conda` and towards the use of Docker for teaching since it ensures that all students have the same packages installed. However, if you simply want to play with the geo-data analysis stack or are on a low-powered machine unable to run Docker in full then direct installation may be appropriate.

A more detailed set of instructions can also be found in [Dani's Repo](https://github.com/darribas/gds19/tree/master/content/infrastructure). **Read this if you have trouble!**

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

## Planning
- Investigate using [conda metachannel](https://github.com/regro/conda-metachannel) to speed up package resolution when building new image. Might work with a requirements.txt file that can be read by both conda and docker, as well as the [following approach](https://stackoverflow.com/questions/34911622/dockerfile-set-env-to-result-of-command) to writing/reading data dynamically in the Docker environment.
- Investigate [mamba](https://github.com/TheSnakePit/mamba) as alternative to Metachannel.
- Adapt Dani's Makefile for use with SDS and enabling install of matching env to Docker
- Create vagrant and VB versions
- Investigate Git LFS at UCL for VB image

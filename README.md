# `sds_env`: Spatial Data Science Platform

This is a fork from [Dani's work](https://github.com/darribas/gds_env) (**please see below for citing**) to remove R as we don't need this for teaching but do have a few more Python packages that we _do_ use. We've also added some JupyterLab extensions to make interacting with the Lab server a bit easier.

We previously experimented with _four_ approaches to installation: [VirtualBox](./virtualbox/README.md); [Vagrant](./vagrant/README.md); [Docker](./docker/README.md); and [Anaconda Python](./conda/README.md) directly. Each of these has pros and cons, but after careful consideration we have come to the conclusion that Docker is the most robust way to ensure a consistent experience in which all students end up with the same versions of each library, difficult-to-diagnose hardware/OS issues are minimised, and running/recovery is the most straightfoward.

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

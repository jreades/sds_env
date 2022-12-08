# Using Docker

You will need [Docker](https://www.docker.com) (Desktop) to be able to install the Spatial Data Science (SDS) environment. If you do not wish to create an account with Docker then you may want to follow advice [provided here](https://github.com/docker/docker.github.io/issues/6910#issuecomment-532393783) though we cannot condone it.

From there, you can follow the guides provided on [jreades.github.io/sds_env](jreades.github.io/sds_env/setup/env.html) for a quick-start and [Using Docker](https://jreades.github.io/sds_env/docker/index.html) for help with making use of Quarto, Dask, and VSCode integration.

## Cross-Platform Compilation

To support M1/M2 Macs it's now necessary to compile Docker images for ARM64 as well as AMD64-bit architectures. The most straightforward instructions I've found are [here](https://medium.com/geekculture/docker-build-with-mac-m1-d668c802ab96) but there are additional steps [for Linux](https://nexus.eddiesinentropy.net/2020/01/12/Building-Multi-architecture-Docker-Images-With-Buildx/):

```shell
docker buildx create --name <buildername>
docker buildx use <buildername>
docker buildx inspect --bootstrap # Check for arm64 and amd64
docker buildx build ... 
docker login docker.io
docker push <tags>
```

In my case, the last command (when run from `sds_env`) becomes:
```shell
export IMG_NM=sds:2022i && docker buildx build --tag jreades/${IMG_NM} -o type=registry --platform=linux/arm64,linux/amd64 --compress --file docker/Dockerfile.master .
```

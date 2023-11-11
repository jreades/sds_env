# `sds_env`: Spatial Data Science Platform

This is a fork from [Dani's work](https://github.com/darribas/gds_env) (**please see below for citing**) to remove R as we don't need this for teaching but do have a few more Python packages that we _do_ use. We've also added some JupyterLab extensions to make interacting with the Lab server a bit easier.

We previously experimented with _four_ approaches to installation: [VirtualBox](./virtualbox/README.md); [Vagrant](./vagrant/README.md); [Docker](./docker/README.md); and [Anaconda Python](./conda/README.md) directly. Each of these has pros and cons, but after careful consideration we have come to the conclusion that Docker is the most robust way to ensure a consistent experience in which all students end up with the same versions of each library, difficult-to-diagnose hardware/OS issues are minimised, and running/recovery is the most straightfoward.

=========================

For *most* users you should really be looking at this through the [GitHub.io](https://jreades.github.io/sds_env/) web site!

=========================

## To Dos

1. Work out why the Intel (AMD64) image is so much larger than the Apple Silicon (ARM64) image. I can get a decent report using `docker history --format "{{.Size}}\t{{.CreatedBy}}" --no-trunc jreades/sds:2023-intel | grep -e "[G]B"` which traces the difference back to just two layers:
   - 6.52GB	`RUN |2 USERNAME=jovyan TARGETPLATFORM=linux/amd64 /bin/bash -c mamba env update -n base --quiet --file ./${yaml_nm}     && conda clean --all --yes --force-pkgs-dirs     && find /opt/conda/ -follow -type f -name '*.a' -delete     && find /opt/conda/ -follow -type f -name '*.pyc' -delete     && find /opt/conda/ -follow -type f -name '*.js.map' -delete     && pip cache purge     && rm -rf /home/$NB_USER/.cache/pip     && rm ./${yaml_nm} # buildkit`
   - 5.48GB	`RUN |2 USERNAME=jovyan TARGETPLATFORM=linux/amd64 /bin/bash -c fix-permissions $CONDA_DIR     && fix-permissions $HOME # buildkit`
   - My *guess* is that the second command's effect *depends* on the effects of the first: there are a *lot* of files modified by the `mamba` update but they end up with a different/wrong set of permissions from what the `fix-permissions` script is expecting so it then has to modify the permissions on *all* of them which almost doubles the size of image.

## Using UCL JupyterHub

### **Creating an Environment (Staff)**

1. Start up the UCL VPN.
2. Connect to [JupyterHub](https://jupyter.data-science.rc.ucl.ac.uk/)
3. Authenticate using UCL credentials.
4. Create a new terminal: File > New > Terminal

##### Incorrect Instructions from ISD

I *think* that these instructions are not correct (see below for the alternative) in the sense the use of a symlink can cause problems and duplicated environments down the line: 

```shell
course_name="casa0013"

ln -s /shared/.../casa/${course_name} $HOME/${course_name}

conda config --add envs_dirs /shared/groups/.../casa/${course_name}/envs

curl -o /tmp/casa0013.yml https://raw.githubusercontent.com/jreades/sds_env/master/conda/environment_py.yml

conda env create -n casa0013 -f /tmp/casa0013.yml
```

##### Revised Instructions

I *now* think that the correct way to do this is:

```shell
course_name="casa0013"

conda config --add envs_dirs /shared/groups/.../casa/envs

curl -o /tmp/casa0013.yml https://raw.githubusercontent.com/jreades/sds_env/master/conda/environment_py.yml

conda env create -p /shared/groups/.../casa/envs -f /tmp/casa0013.yml
```

However, note that this now means you have `.../casa/casa0013/envs/casa0013...` so it might be more sensible to set `envs_dirs` to just `...casa/envs` and then have per-module environments underneath that.

#### **Tweaks to environyment_py.yml:**

Two shortcomings in the existing approach of generating `environment_py.yml` were identified and need to be tweaked in the Makefile:

1. Remove anything with ‘linux’ in it 
2. Remove SOMPY and `mrmr`
3. Remove version from gitpython.
4. Remove python-graphviz entirely.

Additional issues may exist with replication to non-Linux systems.

### **Connecting to an Existing Environment (PGTAs & Students)**

To connect to JupyterHub:

1. Start up the UCL VPN.
2. Connect to [JupyterHub](https://jupyter.data-science.rc.ucl.ac.uk/)
3. Authenticate using UCL credentials.
4. If you see a URL that ends in `tree?` please replace this with `lab?` to get the JupyterLab interface and not the original Jupyter Notebook interface.
5. Create a new terminal: File > New > Terminal

Note that you need to replace `...` with the appropriate path (this will be obvious logged in):

```shell
course_name="casa0013"

conda config --append envs_dirs /shared/groups/.../casa/envs

jupyter contrib nbextension install --user
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

- 

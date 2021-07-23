# Installing Anaconda Python

**You are strongly encouraged to use the Docker image instead of installing Anaconda Python directly.** The basic reason for this is that you may encounter installation errors or version differences that mean your experience of runing the Spatial Data Science environment is seriously impaired.

If you persist in wanting to install natively, then you will need [Anaconda Python](https://www.anaconda.com/distribution/#download-section) (Python 3) to be able to install the programming environment.

#### Installing

After downloading and installing Anaconda Python you will also need to download the environment's [configuration file](https://raw.githubusercontent.com/jreades/sds_env/master/conda/environment_py.yml). This file (known as a 'YAML file') tells Anaconda Python what versions of what libraries to install on your computer. The idea is that all users (whether using our Vagrant approach or this one) end up with the same versions of the key programming libraries.

You will then need to work out how to use the AnacondaPrompt (Windows) or Terminal (Mac) in order to navigate to the folder holding the downloaded configuration file. It will be _something_ like `cd ~/Downloads/` to reach your downloads folder.

At this point you may start the installation by typing: 
```bash
conda-env create -f environment_py.yml
```
And then hit the return key to run the command.

#### Configuring

To make this new 'configuration' visible in JupyterLab you then need to run the following two commands...

```bash
conda activate sds2020
python -m ipykernel install --name sds2021 --display-name "CASA2021" 
```

**Note**: when you connect to Jupyter, you should see a second tile called `CASA202`1. Users of Docker will see _only_ `Python3`. You should always use the `CASA2021` tile (which represents a separate computing environment) in Anaconda instead of the default `Python3` tile.

#### Running

Still using the Terminal/AnacondaPrompt type:
```bash
conda activate sds2021
jupyter lab
```

Do **not** run Jupyter Lab from the *Anaconda Navigator* since it does not configure the spatial analysis libraries correctly.

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

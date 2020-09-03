# Installing Anaconda Python

You will need [Anaconda Python](https://www.anaconda.com/distribution/#download-section) (Python 3) to be able to install the GSA environment.

#### Installing

After downloading and installing Anaconda Python you will need to work out how to use the AnacondaPrompt (Windows) or Terminal (Mac) in order to navigate to the folder holding the [YAML file](https://raw.githubusercontent.com/jreades/sds_env/master/conda/environment.yml)

> `conda-env create -f environment.yml`

#### Configuring

To make this new 'kernel' visible in JupyterLab you then need to run the following two commands...

```bash
conda activate sds2020
python -m ipykernel install --name sds2020 --display-name "CASA2020" 
```

#### Running

```bash
conda activate sds2020
jupyter lab
```

Do not run Jupyter Lab from the Anaconda Navigator since it does not configure the libraries correctly.

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

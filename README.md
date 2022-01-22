# `sds_env`: Spatial Data Science Platform

This is a fork from [Dani's work](https://github.com/darribas/gds_env) (**please see below for citing**) to remove R as we don't need this for teaching but do have a few more Python packages that we _do_ use. We've also added some JupyterLab extensions to make interacting with the Lab server a bit easier.

We previously experimented with _four_ approaches to installation: [VirtualBox](./virtualbox/README.md); [Vagrant](./vagrant/README.md); [Docker](./docker/README.md); and [Anaconda Python](./conda/README.md) directly. Each of these has pros and cons, but after careful consideration we have come to the conclusion that Docker is the most robust way to ensure a consistent experience in which all students end up with the same versions of each library, difficult-to-diagnose hardware/OS issues are minimised, and running/recovery is the most straightfoward.

A more detailed set of instructions can also be found in [Dani's Repo](https://github.com/darribas/gds19/tree/master/content/infrastructure). **Read this if you have trouble!**

## Using Anaconda Python

 **You are strongly encouraged to use the [Docker](./docker/README.md) image instead of installing Anaconda Python directly.** The basic reason for this is that you may encounter installation errors or version differences that mean your experience of running the Spatial Data Science environment is seriously impaired. Furethermore, we are not in a position to provide support for the wide variety of platforms (hardware and software) that students may present.

#### Installating Python

If you *really* want to install natively, despite everything we said above, then you will need [Anaconda Python](https://www.anaconda.com/distribution/#download-section) (Python 3 64-bit) to be able to install the programming environment.

##### Mac OSX

If you are using Mac OS, you can download Anaconda directly from [here](https://www.anaconda.com/distribution/#download-section) and then install it.

##### Windows

If you are using Windows 10 or 11, things are a bit trickier. Using Anaconda on Windows is not pleasant, as many packages are only available for Unix/Linux, which makes it hard to configure the Anaconda environment. Moreover, using the Windows CMD or powershell or Anaconda prompt is unpleasant. Therefore, we recommend using Miniconda for WSL (Windows Subsystem for Linux) on your Windows machine. 

The installation of Miniconda for WSL consists of the following steps:

1. Install WSL (Ubuntu for Windows) and Windows Terminal on Windows, following this [link](https://www.digitalocean.com/community/tutorials/how-to-install-the-windows-subsystem-for-linux-2-on-microsoft-windows-10).
2. Start a Windows Terminal of Ubuntu. **Note that all following steps are on Windows Terminal instead of CMD or Anaconda prompt**.
3. Go to https://repo.anaconda.com/miniconda/ to find the list of Miniconda releases. Select the latest release for your machine. I have a 64-bit x86 computer, so I choose **Miniconda3-latest-Linux-x86_64.sh**. If you have a 32-bit computer, you would select **Miniconda3-latest-Linux-x86.sh**.
4. From the terminal run `wget https://repo.anaconda.com/miniconda/[YOUR VERSION]`. Example: `wget  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh`.
5. Run the installation script: `bash Miniconda3-latest-Linux-x86_64.sh`. Replace the file name of **.sh** if needed.
6. Read the license agreement and follow the prompts to accept. When asks you if you'd like the installer to prepend it to the path, say yes.
7. Reload the .bash configs so WSL knows where the conda is installed: `source ~/.bashrc`. Mine is */home/user_name/anaconda3/bin/python*. If it doesn’t have anaconda in the path, do the next step. Otherwise, skip the next step.
8. Manually add the Anaconda bin folder to your PATH. To do this, I added "export PATH=/home/user_name/anaconda3/bin:$PATH" to the bottom of my ~/.bashrc file. Do replace *user_name* with your username.

**Note**: Miniconda is a free minimal installer for conda. It is a lighter version of Anaconda and makes configuring a new environment easy.

**Note**: if you have installed Anaconda for Windows, you don’t need to uninstall it before installing conda for WSL. These two pieces are separate.

#### Installing the Environment

After downloading and installing Anaconda Python you will also need to download the environment's [configuration file](https
://raw.githubusercontent.com/jreades/sds_env/master/conda/environment_py.yml). This file (known as a 'YAML file') tells Anaconda Python what versions of what libraries to install on your computer. The idea is that all users end up with the same versions of the key programming libraries.

You will then need to work out how to use the Terminal (Mac in order to navigate to the folder holding the downloaded configuration file. It will be _something_ like `cd ~/Downloads/` to reach your downloads folder.

At this point you may start the installation by typing:
```bash
conda-env create -n sds2021 -f environment_py.yml
```
And then hit the return key to run the command.

#### Configuring

To make this new 'configuration' visible in JupyterLab you then need to run the following two commands...

```bash
conda activate sds2021
python -m ipykernel install --name sds2021 --display-name "CASA2021"
```

**Note**: when you connect to Jupyter, you should see a second tile called `CASA2021`. Users of Docker will see _only_ `Python3`. You should always use the `CASA2021` tile (which represents a separate computing environment) in Anaconda instead of the default `Python3` tile.

**Note**: if you get a warning of ‘No permission’ because of the above commands, please add `sudo` to that command and run it again. You would need to input the password for WSL or Mac.

#### Running

Still using the Terminal type (Windows users, please use Windows Terminal):
```bash
conda activate sds2021
jupyter lab
```

Do **not** run Jupyter Lab from the *Anaconda Navigator* since it does not configure the spatial analysis libraries correctly.

## Using UCL JupyterHub

### **Creating an Environment (Staff)**



1. Start up the UCL VPN.
2. Connect to [JupyterHub](https://jupyter.data-science.rc.ucl.ac.uk/)
3. Authenticate using UCL credentials.
4. Create a new terminal: File > New > Terminal

##### Instructions from ISD

I now think that these instructions are not correct (see below for the alternative) in the sense the use of a symlink can cause problems and duplicated environments down the line. Anyway, type the following, but note that you need to replace `...` with the appropriate path (this will be obvious logged in):

```shell
course_name="casa0013"

ln -s /shared/.../casa/${course_name} $HOME/${course_name}

conda config --add envs_dirs /shared/groups/.../casa/${course_name}/envs

curl -o /tmp/casa0013.yml https://raw.githubusercontent.com/jreades/sds_env/master/conda/environment_py.yml

conda env create -n casa0013 -f /tmp/casa0013.yml
```

##### Revised Instructions

I now think that the correct way to do this is:

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

## To Dos

- Add [mgwr](https://mgwr.readthedocs.io/en/latest/) to image? 

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

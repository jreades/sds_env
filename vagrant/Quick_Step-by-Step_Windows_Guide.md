# Installing SDS Environment on Windows 10

1. Set up a CASA folder somewhere easy to find (e.g. in your `Documents` directory)

2. Register on GitHub -- you can use a personal email address or your UCL address and then associate a second email address later.

3. Download and install Git Bash

4. None

5. Clone the i2p project

   command: git clone https://github.com/jreades/i2p

   URL: https://github.com/jreades/i2p

6. Check BIOS setting

   URL: https://2nwiki.2n.cz/pages/viewpage.action?pageId=75202968 

7. Install Vagrant and VirtualBox

8. Download Vagrantfile and put it in your CASA directory

   URL: https://github.com/jreades/sds_env/blob/master/vagrant/Vagrantfile

9. Create the Vagrant virtual machine using `vagrant up` (which must be run from Git Bash in the _same_ folder where you saved the Vagrantfile.

10. Log in to JupyterLab by going to `localhost:8888` and entering the password `casai2p`.

11. Create a notebook in Vagrant

If you are unable to install Vagrant (back in step 7 _and_ it's definitely not the BIOS issue in step 6), then you will need to install Anaconda Python directly: 

11. Install Anaconda Python

12. Download the YAML file

    URL: https://github.com/jreades/sds_env/blob/master/conda/environment_py.yml

13. Install the conda environment using `conda env create -f environment_py.yml` which you run from the Anaconda Prompt.

14. Start up JupyterLab from the Anaconda Prompt like this:
```
conda activate sds2020
jupyter lab
```


# How to pull and run this image
# > docker pull jreades/sds:1.0
# > docker run --rm -ti -p 8888:8888 -v ${PWD}:/home/jovyan/work jreades/sds:1.0
#
# How to build
# > docker build -t jreades/sds:2020 --compress .
# How to push an updated image
# > docker tag jreades/sds:2020 jreades/sds:latest
# > docker login docker.io
# > docker push jreades/sds:2020 jreades/sds:latest
#
#--- Build from Jupyter-provided Minimal Install ---#
# https://github.com/jupyter/docker-stacks/blob/master/docs/using/selecting.md

# June 2020
FROM jupyter/minimal-notebook:6d42503c684f

LABEL maintainer="j.reades@ucl.ac.uk"

# https://github.com/ContinuumIO/docker-images/blob/master/miniconda3/Dockerfile
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

ENV yaml_nm 'environment.yml'
ENV env_nm sds2020
ENV kernel_nm 'CASA2020'

#--- Python ---#
RUN echo "Building $kernel_nm"

# Get conda updated and set up before installing
# any packages
RUN conda update -n base conda --yes \
    && conda config --add channels conda-forge \
#    && conda config --add channels pyviz \
#    && conda config --add channels makepath \
    && conda config --set channel_priority strict

SHELL ["/bin/bash", "-c"]
#RUN sudo fallocate -l 1G /swapfile
ADD ./${yaml_nm} ./
RUN conda-env create -n ${env_nm} -f ./${yaml_nm}  
RUN conda clean --all --yes --force-pkgs-dirs \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.pyc' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && pip cache purge \ 
    && rm -rf /home/$NB_USER/.cache/pip \ 
    && rm ./${yaml_nm} \
    && conda list -e > requirements.txt \ 
    && conda-env export -n ${env_nm} > ${env_nm}-full.yml

# Set paths for conda and PROJ
# Change depending on whether using base environment
#ENV PATH /opt/conda/bin:$PATH
#ENV PROJ_LIB /opt/conda/share/proj/
ENV PATH /opt/conda/envs/${env_nm}/bin:$PATH
ENV PROJ_LIB /opt/conda/envs/${env_nm}/share/proj/

# And configure the bash shell params 
COPY init.sh /tmp/
RUN cat /tmp/init.sh > ~/.bashrc 
# Change depending on whether using base environment
#RUN echo "export PROJ_LIB=/opt/conda/share/proj/" >> ~/.bashrc
RUN echo "export PROJ_LIB=/opt/conda/envs/${env_nm}/share/proj/" >> ~/.bashrc

#--- JupyterLab config ---#
USER root

# Need to add these if rmotr/solutions ever works:
# c.JupyterLabRmotrSolutions.is_enabled = True # True, False
# c.JupyterLabRmotrSolutions.role = 'teacher' # 'teacher', 'student'
SHELL ["/bin/bash", "-c"]
RUN echo $'\n\
    c.NotebookApp.default_url = \'/lab\' \n\
    c.JupyterLabRmotrSolutions.is_enabled = True \n\
    c.JupyterLabRmotrSolutions.role = \'student\'\n' >> /home/$NB_USER/.jupyter/jupyter_notebook_config.py

# Install jupyterlab extensions, but don't build
# (saves some time over install and building each)
RUN jupyter lab clean \
# These should work, but can be commented out for speed during dev
    && jupyter labextension install --no-build @jupyter-widgets/jupyterlab-manager \
    && jupyter labextension install --no-build jupyter-matplotlib \ 
    && jupyter labextension install --no-build @jupyterlab/mathjax3-extension \ 
    && jupyter labextension install --no-build jupyterlab-plotly \ 
    && jupyter labextension install --no-build @jupyterlab/geojson-extension \ 
    && jupyter labextension install --no-build @krassowski/jupyterlab_go_to_definition \
    && jupyter labextension install --no-build @ryantam626/jupyterlab_code_formatter \ 
    && jupyter labextension install --no-build @bokeh/jupyter_bokeh \ 
    && jupyter labextension install --no-build @pyviz/jupyterlab_pyviz \ 
    && jupyter labextension install --no-build jupyter-leaflet \
    && jupyter labextension install --no-build nbdime-jupyterlab \
    && jupyter labextension install --no-build ipysheet \ 
    && jupyter labextension install --no-build @lckr/jupyterlab_variableinspector \ 
    && jupyter labextension install --no-build jupyterlab-jupytext \ 
    #&& jupyter labextension install --no-build @rmotr/jupyterlab-solutions \
    && jupyter labextension install --no-build qgrid \
# Don't work currently
    && jupyter labextension install --no-build @krassowski/jupyterlab-lsp \
#    && jupyter labextension install --no-build pylantern \ 
#    && jupyter labextension install --no-build @oriolmirosa/jupyterlab_materialdarker \ 
#    && jupyter labextension install --no-build @jpmorganchase/perspective-jupyterlab \ 
    && jupyter labextension install --no-build @jupyterlab/toc

# Build the jupyterlab extensions
RUN jupyter lab build \
    && jupyter labextension enable jupyterlab-manager \ 
    && jupyter labextension enable jupyter-matplotlib \
    && jupyter labextension enable mathjax3-extension \ 
    && jupyter labextension enable jupyterlab-plotly \ 
    && jupyter labextension enable geojson-extension \ 
    && jupyter labextension enable jupyterlab_go_to_definition \
    && jupyter labextension enable jupyterlab_code_formatter \
    && jupyter labextension enable jupyter_bokeh \
    && jupyter labextension enable jupyterlab_pyviz \
    && jupyter labextension enable jupyter-leaflet \ 
    && jupyter labextension enable nbdime-jupyterlab \
    && jupyter labextension enable ipysheet \ 
    && jupyter labextension enable jupyterlab_variableinspector \ 
    && jupyter labextension enable jupyterlab-jupytext \
    #&& jupyter labextension enable jupyterlab_rmotr_solutions \
    && jupyter labextension enable qgrid \ 
    && jupyter labextension enable jupyterlab-lsp \
    && jupyter labextension enable toc \ 
    && jupyter lab clean -y

# Clean up
RUN conda clean --all -f -y \ 
    && npm cache clean --force \
    && rm -rf $CONDA_DIR/share/jupyter/lab/staging \
    && rm -rf "/home/${NB_USER}/.node-gyp" \ 
    && rm -rf /home/$NB_USER/.cache/yarn \ 
# Fix permissions
    && fix-permissions "${CONDA_DIR}" \
    && fix-permissions "/home/${NB_USER}" \
# Build mpl font cache
    && python -c "import matplotlib.pyplot;"

#--- Preload the NLTK/Spacy libs ---#
RUN python -c "import nltk; nltk.download('wordnet'); nltk.download('stopwords'); nltk.download('punkt'); nltk.download('city_database')"
# This may bloat the Docker image massively
#RUN python -m spacy download en \ 
#    && python -m spacy download en_core_web_sm 

#--- Set up Kernelspec so name visible in chooser ---#
USER root
SHELL ["/bin/bash", "-c"]
RUN . /opt/conda/etc/profile.d/conda.sh \
    && conda activate ${env_nm} \
    && python -m ipykernel install --user --name ${env_nm} --display-name ${kernel_nm} \
    && ln -s /opt/conda/bin/jupyter /usr/local/bin

# Switch back to user to avoid accidental container runs as root
USER $NB_UID

RUN echo "Build complete."

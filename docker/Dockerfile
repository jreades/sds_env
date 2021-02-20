# How to pull and run this image (where "${SDS_RELEASE}" should be replaced by, e.g., "0.6.1")
# > export SDS_RELEASE 0.6.1 # 0.6.1 is an example
# > docker pull jreades/sds:${SDS_RELEASE}
# > docker run --rm -ti -p 8888:8888 -v ${PWD}:/home/jovyan/work jreades/sds:${VERSION_NUM} jupyter lab
# OR 
# > docker run --rm -ti -p 8888:8888 --mount type=bind,source=$(pwd),target=/home/jovyan/ jreades/sds:${SDS_RELEASE} jupyter lab
#
# How to build
# > docker build -t jreades/sds:${SDS_RELEASE} --compress .
# How to push an updated image
# > docker login docker.io
# > docker push jreades/sds:${SDS_RELEASE}
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

#--- Future work ---#
# Install sed/awk

#--- Python ---#
# Get conda updated and set up before installing
# any packages
#
# This can be useful for constraining the solution
# down below as we can specify the python version.
# RUN echo $(python --version)
#RUN conda update -n base conda --yes \
#    && conda config --add channels conda-forge \
#    && conda config --add channels pyviz \
#    && conda config --add channels makepath \
RUN conda config --add channels conda-forge \
    && conda config --set channel_priority strict

SHELL ["/bin/bash", "-c"]
#ADD https://raw.githubusercontent.com/jreades/sds_env/master/conda/${yaml_nm} ./
COPY ./conda/${yaml_nm} ./
RUN conda-env create -n ${env_nm} -f ./${yaml_nm} \
    && conda clean --all --yes --force-pkgs-dirs \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.pyc' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && pip cache purge \ 
    && rm -rf /home/$NB_USER/.cache/pip \ 
    && rm ./${yaml_nm}

# Set paths for conda and PROJ
# Change depending on whether using base environment
#ENV PATH /opt/conda/bin:$PATH
#ENV PROJ_LIB /opt/conda/share/proj/
ENV PATH /opt/conda/envs/${env_nm}/bin:$PATH
ENV PROJ_LIB /opt/conda/envs/${env_nm}/share/proj/

# And configure the bash shell params 
#COPY ./tools/init.sh ./
#RUN cat ./init.sh > ~/.bashrc \ 
#    && rm ./init.sh

# Change depending on whether using base environment
#RUN echo "export PROJ_LIB=/opt/conda/share/proj/" >> ~/.bashrc
RUN echo "export PROJ_LIB=/opt/conda/envs/${env_nm}/share/proj/" >> ~/.bashrc

#--- Preload the NLTK/Spacy libs ---#
RUN python -c "import nltk; nltk.download('wordnet'); nltk.download('stopwords'); nltk.download('punkt'); nltk.download('city_database'); nltk.download('averaged_perceptron_tagger')"
# This may bloat the Docker image massively
#RUN python -m spacy download en \ 
#    && python -m spacy download en_core_web_sm 

#--- JupyterLab config ---#
USER root

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
    && jupyter labextension install --no-build @bokeh/jupyter_bokeh \ 
    && jupyter labextension install --no-build @pyviz/jupyterlab_pyviz \ 
    && jupyter labextension install --no-build @reviewnb/jupyterlab_gitplus \
    && jupyter labextension install --no-build jupyter-leaflet \
    && jupyter labextension install --no-build nbdime-jupyterlab \
#    && jupyter labextension install --no-build ipysheet \ 
    && jupyter labextension install --no-build @lckr/jupyterlab_variableinspector \ 
#    && jupyter labextension install --no-build jupyterlab-jupytext \ 
#    && jupyter labextension install --no-build qgrid2 \
# Don't work currently
#    && jupyter labextension install --no-build @rmotr/jupyterlab-solutions \
#    && jupyter labextension install --no-build pylantern \ 
#    && jupyter labextension install --no-build @oriolmirosa/jupyterlab_materialdarker \ 
#    && jupyter labextension install --no-build @jpmorganchase/perspective-jupyterlab \ 
    && jupyter labextension install @krassowski/jupyterlab-lsp@2.0.0 \
#    && jupyter labextension install @ryantam626/jupyterlab_code_formatter 
    && jupyter labextension install --no-build @jupyterlab/toc 

# Docs suggest this needs to be installed after, though I have my doubts.
#RUN conda install -n ${env_nm} --yes --quiet \
#    'jupyterlab_code_formatter' 

# Build the jupyterlab extensions
RUN jupyter lab build -y --dev-build=False \
    && jupyter labextension enable jupyterlab-manager \ 
    && jupyter labextension enable jupyter-matplotlib \
    && jupyter labextension enable mathjax3-extension \ 
    && jupyter labextension enable jupyterlab-plotly \ 
    && jupyter labextension enable geojson-extension \ 
    && jupyter labextension enable jupyterlab_go_to_definition \
    && jupyter labextension enable jupyter_bokeh \
    && jupyter labextension enable jupyterlab_pyviz \
    && jupyter labextension enable jupyter-leaflet \ 
    && jupyter labextension enable nbdime-jupyterlab \
#    && jupyter labextension enable ipysheet \ 
    && jupyter labextension enable jupyterlab_variableinspector \ 
#    && jupyter labextension enable jupyterlab-jupytext \
#    && jupyter labextension enable qgrid2 \ 
    && jupyter labextension enable jupyterlab-lsp \
    && jupyter labextension enable toc \ 
#    && jupyter serverextension enable --py jupyterlab_code_formatter \
    && jupyter serverextension enable --py jupyterlab_gitplus \ 
    && jupyter lab clean -y

# Clean up
RUN conda clean --all -f -y \ 
    && npm cache clean --force \
    && rm -rf $CONDA_DIR/share/jupyter/lab/staging \
    && rm -rf "/home/${NB_USER}/.node-gyp" \ 
    && rm -rf /home/$NB_USER/.cache/yarn \ 
# Build mpl font cache
    && python -c "import matplotlib.pyplot;"

# Fix permissions
RUN fix-permissions $CONDA_DIR \
    && fix-permissions $HOME

#
# To generate a new password on a machine with jupyter notebook libs installed: 
# > python3 -c "from notebook.auth import passwd; print(passwd('YOUR PASSWORD HERE'))"
# 

#--- Configure startup params ---#
# Switch back to user to avoid accidental container runs as root
USER $NB_UID

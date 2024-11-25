ENV env_nm 'base'
#ENV env_nm 'sds2024'
#ENV env_path '/opt/conda/'
#ENV env_path /opt/conda/envs/$env_nm/

RUN if [ "$env_nm" = "base" ]; then export env_path='/opt/conda/'; else export env_path="/opt/conda/envs/$env_nm/"; fi

USER $NB_UID

ADD ./conda/$yaml_nm ./

#RUN conda env create -n $env_nm --quiet --file $yaml_nm --solver=libmamba \
#RUN conda env update -n base --quiet --file ${yaml_nm} --solver=libmamba \
RUN if [ "$env_nm" = "base" ]; \
        then conda env update -n $env_nm --quiet --file $yaml_nm --solver=libmamba; \
        else conda env create -n $env_nm --quiet --file $yaml_nm --solver=libmamba; \
    fi \ 
    && rm $yaml_nm \
    && conda clean --all --yes --force-pkgs-dirs \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.pyc' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    #&& find "${env_path}/lib/python*/site-packages/bokeh/server/static" \
    #   -follow -type f -name '*.js' ! -name '*.min.js' -delete \
    && pip cache purge 

#--- Preload the NLTK/Spacy libs and code formatter ---#

ENV PROJ_LIB=$env_path/share/proj/
ENV GENSIM_DATA_DIR=/home/$NB_USER/work/gensim-data
ENV SPACY_DATA_DIR=/home/$NB_USER/work/spacy-data
ENV XDG_CACHE_HOME=/home/$NB_USER/.cache/

# This bloats the Docker image but not massively
# Should rebuild the font manager and allow us to access
# the fonts we've just added in Matplotlib... *should*
RUN source activate ${env_nm} \
    && mkdir -p "/home/$NB_USER/.cache/black/$(black --version | head -n 1 | cut -d ' ' -f 2)" \
    && black --code "print ( 'hello, world' )" \
    && MPLBACKEND=Agg python -c "import matplotlib.pyplot" \
    && python -c "import matplotlib.font_manager;" \
    && python -c "import logging; logging.basicConfig(level='INFO'); import black" \
    && conda deactivate

RUN if [ -v "$r5v" ]; then \
        source activate ${env_nm} \
        && python -c "import nltk; nltk.download('wordnet'); nltk.download('stopwords'); nltk.download('punkt'); nltk.download('city_database'); nltk.download('averaged_perceptron_tagger'); nltk.download('omw-1.4')" \
        && python -c "import duckdb; db = duckdb.connect(); db.execute('INSTALL spatial'); db.execute('INSTALL httpfs'); db.execute('LOAD spatial; LOAD httpfs;');" \
        && conda deactivate; \
    fi  

#--- Tidy and fix permissions ---#
USER root

# Disable message
RUN jupyter labextension disable "@jupyterlab/apputils-extension:announcements" \
    # Clean up
    && jupyter lab clean -y \
    && conda clean --all -f -y \
    && npm install -g tldr \
    && npm cache clean --force \
    && rm -rf $CONDA_DIR/share/jupyter/lab/staging \
    && rm -rf /home/$NB_USER/.node-gyp/* \
    && rm -rf /home/$NB_USER/.local/* \
    && rm -rf /home/$NB_USER/.cache/rosetta \
    && rm -rf /home/$NB_USER/.cache/yarn \ 
    && rm -rf /home/$NB_USER/.cache/pip 
    # Fix permissions
    #&& fix-permissions $CONDA_DIR \
    #&& fix-permissions /home/$NB_USER

#--- Final steps
USER $NB_UID

RUN source activate $env_nm \
    #&& jupyter kernelspec install $env_path --user --replace --name=$env_nm --display-name="Python (${env_nm})" \
    && ipython kernel install --user --name $env_nm --display-name="Python (${env_nm})" \
    && conda deactivate \
    && if [ "$env_nm" != "base" ]; then jupyter kernelspec remove -y python3; fi

RUN jupyter lab --generate-config \
    && echo "c.MultiKernelManager.default_kernel_name='$env_nm'" >> \
       /home/$NB_USER/.jupyter/jupyter_lab_config.py \
    # https://github.com/jupyter/notebook/issues/3674#issuecomment-397212982
    && echo "c.KernelSpecManager.allowed_kernelspecs = {'$env_nm'}" >> \
        /home/$NB_USER/.jupyter/jupyter_lab_config.py \
    && echo "c.KernelSpecManager.ensure_native_kernel = True" >> \
         /home/$NB_USER/.jupyter/jupyter_lab_config.py \
    && echo "conda activate $env_nm" >> /home/$NB_USER/.bashrc

#--- Make Proj4 Easy to Find ---#
# Change depending on whether using base environment

RUN echo "export PATH=$env_path/bin/:$PATH" >> ~/.bashrc 
RUN echo "export PROJ_LIB=$PROJ_LIB" >> ~/.bashrc
RUN echo "export GENSIM_DATA_DIR=$GENSIM_DATA_DIR # python -m gensim.downloader --download <dataname>" >> ~/.bashrc 
RUN echo "export SPACY_DATA_DIR=$SPACY_DATA_DIR # spacy.load('/path/to/en_core_web_sm')" >> ~/.bashrc 
RUN echo "export XDG_CACHE_HOME=$XDG_CACHE_HOME" >> ~/.bashrc

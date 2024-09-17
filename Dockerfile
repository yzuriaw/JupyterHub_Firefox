# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/datascience-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

ARG JUPYTERLAB_VERSION=4.2.1
ARG JUPYTERHUB_VERSION=4.0.2

USER root

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends ffmpeg dvipng cm-super && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update

RUN apt-get install -y --fix-missing \
    git \
    npm \
    nodejs \
    wget \
    curl \
    pkg-config \
    && apt-get clean && rm -rf /tmp/* /var/tmp/*



USER ${NB_UID}

RUN pip3 install --no-cache \
    wbdata \
    socrata-py \
    sodapy \
    faodata \
    notebook==7.2.0 \
    jupyterlab==$JUPYTERLAB_VERSION \
    jupyterhub==$JUPYTERHUB_VERSION

RUN pip3 install --no-cache \
    wheel \
    reportlab \ 
    colour \ 
    pyproj \ 
    holoviews \ 
    country_converter \ 
    lxml \ 
    pyxlsb \
    python-pptx \ 
    openpyxl \
    shapely \ 
    geopandas \
    jupyterlab_iframe \
    pandas \
    selenium \
    seaborn \
    openai \ 
    pypdf \
    xlsxwriter 

RUN conda install --quiet --yes -c conda-forge \
    jupyterlab_pygments \
    altair \
    bottleneck  \
    cloudpickle  \
    cython \
    dask  \
    dill \
    h5py  \
    ipympl \
    ipywidgets  \
    keras \
    matplotlib-base  \
    numba \
    numexpr \
    patsy \
    protobuf \
    pytables \
    pyspark \
    'r-repr' \
    scikit-image \
    scikit-learn \
    scipy \
    statsmodels \
    sympy \
    pytorch  \
    tensorflow \
    widgetsnbextension \
    xlrd && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# R packages (needed for )

RUN conda install --quiet --yes -c conda-forge \
    'r-repr'

RUN pip3 install jupyterlab_git \
    lckr_jupyterlab_variableinspector \
    jupyterlab-spellchecker \
    jupyter-ai \
    jupyter-server-proxy 

RUN pip install --upgrade jupyter-server

USER ${NB_UID}

CMD ["jupyterhub-singleuser"]

ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions "/home/${NB_USER}"

USER ${NB_UID}

WORKDIR "${HOME}"

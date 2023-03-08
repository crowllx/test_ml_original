
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG OWNER=jupyter
ARG BASE_CONTAINER=$OWNER/minimal-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    # for cython: https://cython.readthedocs.io/en/latest/src/quickstart/install.html
    # for matplotlib anim
    ffmpeg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

#change workspace before installing python packages in order to avoid cache errors in gitpod
WORKDIR /workspace

# Install Python 3 packages
RUN arch=$(uname -m) && \
    if [ "${arch}" == "aarch64" ]; then \
        # Prevent libmamba from sporadically hanging on arm64 under QEMU
        # <https://github.com/mamba-org/mamba/issues/1611>
        export G_SLICE=always-malloc; \
    fi && \
    mamba install --quiet --yes \
    'matplotlib-base' \
    'pandas' \
    'scipy' \
    'sqlalchemy' \
    'numpy' \
    'scikit-learn' && \
    mamba clean --all -f -y
# Import matplotlib the first time to build the font cache.
#ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

#RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
#   fix-permissions "/home/${NB_USER}"

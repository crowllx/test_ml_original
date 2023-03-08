#image for Machine Learning in python/jupyter notebooks
FROM gitpod/workspace-base
ARG DEBIAN_FRONTEND=noninteractive
ARG USER=gitpod
USER root
EXPOSE 8888:8888/tcp

WORKDIR /workspace

#update apt-get packages
RUN sudo apt-get update --yes && \
    sudo apt-get install --yes --no-install-recommends python3 \
                                                       python3-pip

USER ${USER}

#install requirements
RUN pip install --no-cache-dir \
    ipykernel \
    matplotlib \
    pandas \
    scipy \
    sqlalchemy \
    numpy \
    notebook \
    scikit-learn

ENV XDG_CACHE_HOME="/home/${USER}/.cache/"
RUN MPLBACKEND=Agg python3 -c "import matplotlib.pyplot"

#create and edit jupyter notebook config file
RUN jupyter notebook --generate-config && echo -e \ 
	'c.NoteBookApp.ip - "0.0.0.0"\n \
	c.NoteBookApp.open_browser = False\n \
	c.InLineBackend.figure_formats = {"png", "jpeg", "svg", "pdf"}\n \
	\n# https://github.com/jupyter/notebook/issues/3130\n \
	c.FileContentsManager.delete_to_trash = False' >> /home/gitpod/.jupyter/jupyter_notebook_config.py 


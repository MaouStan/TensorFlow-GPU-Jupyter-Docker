# Use NVIDIA CUDA base image
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/miniconda3/bin:${PATH}"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    ca-certificates \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /root/miniconda3 && \
    rm ~/miniconda.sh && \
    /root/miniconda3/bin/conda clean -a -y && \
    ln -s /root/miniconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /root/miniconda3/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# Create a new conda environment
RUN conda create -n tf_gpu python=3.9 -y

# Install packages in separate steps
RUN conda run -n tf_gpu conda install -y tensorflow-gpu && conda clean -a -y
RUN conda run -n tf_gpu conda install -y jupyter && conda clean -a -y
RUN conda run -n tf_gpu conda install -y numpy pandas && conda clean -a -y
RUN conda run -n tf_gpu conda install -y matplotlib && conda clean -a -y
RUN conda run -n tf_gpu conda install -y scikit-learn && conda clean -a -y

# Set up Jupyter with a default password
RUN conda run -n tf_gpu jupyter notebook --generate-config && \
    echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.ServerApp.password = u''" >> /root/.jupyter/jupyter_notebook_config.py

# Create a startup script
RUN echo '#!/bin/bash\n\
source /root/miniconda3/etc/profile.d/conda.sh\n\
conda activate tf_gpu\n\
jupyter notebook --allow-root --ip=0.0.0.0 --port=8888 --no-browser &\n\
tail -f /dev/null\n\
' > /start_jupyter.sh && chmod +x /start_jupyter.sh


# Set the working directory
WORKDIR /workspace

# Expose Jupyter port
EXPOSE 8888

# Start Jupyter Notebook
CMD ["/start_jupyter.sh"]

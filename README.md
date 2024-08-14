# TensorFlow GPU Jupyter Environment

This project provides a Docker-based environment for running TensorFlow with GPU support and Jupyter Notebook.

## Prerequisites

- Docker installed on your system
- NVIDIA GPU with compatible drivers (for GPU support)
- NVIDIA Container Toolkit (for GPU support)

## Running from Pre-built Image

1. Pull the pre-built image:
   ```
   docker pull tensorflow-gpu-jupyter.tar
   ```

2. Run the container:
   ```
   docker run --gpus all -p 8888:8888 -v $(pwd):/workspace tensorflow-gpu-jupyter
   ```

3. Access Jupyter Notebook:
   - Run the following command to get the Jupyter Notebook URL and token:
     ```
     docker logs tensorflow-gpu-jupyter
     ```
   - Look for a line that starts with "http://127.0.0.1:8888/?token=". Copy the entire URL.
   - Open a web browser and paste the copied URL.

## Building a New Image
1. Build the Docker image:
   ```
   docker build -t tensorflow-gpu-jupyter .
   ```

2. Run the container:
   ```
   docker run --gpus all -p 8888:8888 -v $(pwd):/workspace tensorflow-gpu-jupyter
   ```

3. Access Jupyter Notebook:
   - Run the following command to get the Jupyter Notebook URL and token:
     ```
     docker logs tensorflow-gpu-jupyter
     ```
   - Look for a line that starts with "http://127.0.0.1:8888/?token=". Copy the entire URL.
   - Open a web browser and paste the copied URL.

## Verifying GPU Support

1. Open the `Test.ipynb` notebook in Jupyter.
2. Run the cells to check TensorFlow version, GPU availability, and perform a sample computation.

## Notes

- The Dockerfile installs TensorFlow with GPU support, Jupyter, and other common data science libraries.
- The working directory inside the container is `/workspace`, which is mapped to your current directory when running the container.
- Jupyter Notebook runs on port 8888 inside the container, which is mapped to the same port on your host machine.

For any issues or questions, please refer to the project repository or contact the maintainer.

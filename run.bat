@echo off

REM Run the Docker container
docker run --gpus all -d -p 8888:8888 -v "%cd%:/workspace" --name tensorflow-jupyter tensorflow-gpu-jupyter

REM Wait for the Jupyter Notebook to start
timeout 10

REM Get the Jupyter Notebook URL with token
for /f "tokens=*" %%a in ('docker logs tensorflow-jupyter 2^>^&1 ^| findstr /C:"http://127.0.0.1:8888/tree?token="') do set JUPYTER_URL=%%a

if "%JUPYTER_URL%"=="" (
    echo Couldn't find Jupyter URL. Please check the container logs manually.
) else (
    echo Jupyter Notebook is running. Use this URL to access it:
    echo %JUPYTER_URL%
)

echo To stop the container, run: docker stop tensorflow-jupyter
echo To start it again, run: docker start tensorflow-jupyter

pause

echo "Started"
docker build --progress=plain --no-cache -t jupyter_notebook_converter:0.1 . 


docker tag jupyter_notebook_converter:0.1 sergeyhein/sandbox:jupyter_notebook_converter-0.1

docker push sergeyhein/sandbox:jupyter_notebook_converter-0.1
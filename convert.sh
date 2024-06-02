#!/bin/bash

# Bash script to convert Jupyter notebooks to PDF
# Input: Full path to the notebook

# Check if the notebook path is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_notebook>"
    exit 1
fi

notebook="$1"

# Create a new temporary directory
temp_folder=$(mktemp -d)
echo "temp_folder: $temp_folder"

# Get the full path, name without extension, folder, and file name of the notebook
full_path=$(realpath "$notebook")
name=$(basename "$notebook" .ipynb)
folder=$(dirname "$full_path")
notebook_file=$(basename "$notebook")

# Copy the notebook to the temporary directory
cp -f "$notebook" "$temp_folder"


docker_image="sergeyhein/sandbox:jupyter_notebook_converter-0.1"
echo "Running the docker container using wsl"
echo "temp_folder: $temp_folder"
echo "docker_image: $docker_image"
echo "notebook: $notebook"

docker run --rm -v "${temp_folder}:/data" "${docker_image}" /convert.sh "$notebook_file"

# Copy the generated .tex and .pdf files back to the original notebook directory
src="$temp_folder/$name.tex"
dst="$folder/$name.tex"
echo "$src -> $dst"
cp -f "$src" "$dst"

src="$temp_folder/${name}_updated.tex"
dst="$folder/${name}_updated.tex"
echo "$src -> $dst"
cp -f "$src" "$dst"

src="$temp_folder/${name}_updated.pdf"
dst="$folder/${name}_updated.pdf"
echo "$src -> $dst"
cp -f "$src" "$dst"


src="$temp_folder/$name.pdf"
dst="$folder/$name.pdf"
echo "$src -> $dst"
cp -f "$src" "$dst"

src="$temp_folder/$name.html"
dst="$folder/$name.html"
echo "$src -> $dst"
cp -f "$src" "$dst"

# Check for and copy any output files directory
src="$temp_folder/${name}_files"
if [ -d "$src" ]; then
    dst="$folder"
    echo "$src -> $dst"
    cp -rf "$src" "$dst"
fi


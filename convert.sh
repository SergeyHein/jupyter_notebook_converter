#!/bin/bash
# $1 - ipynb file located in /data

FILE="$1"

cd /data
jupyter nbconvert "$1" --to pdf --no-prompt
jupyter nbconvert "$1" --to latex --no-prompt
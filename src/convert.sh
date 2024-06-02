#!/bin/bash
# $1 - ipynb file located in /data

FILE="$1"
FILE_WITHOUT_EXT="${FILE%.*}"
cd /data
jupyter nbconvert "$1" --to pdf --no-prompt
jupyter nbconvert "$1" --to latex --no-prompt
jupyter nbconvert "$1" --to html --no-prompt

cp "${FILE_WITHOUT_EXT}.tex" "${FILE_WITHOUT_EXT}_updated.tex"


sed -i '/\\textbf{Table of contents}/,/^$/{
  /\\textbf{Table of contents}/a\
\n\\newpage\\tableofcontents\\newpage\n
  /\\textbf{Table of contents}/,/^$/d
}' "${FILE_WITHOUT_EXT}_updated.tex"

echo "xelatex 3 times: ['xelatex', ${FILE_WITHOUT_EXT}_updated.tex, '-quiet']"


xelatex "${FILE_WITHOUT_EXT}_updated.tex" -quiet
xelatex "${FILE_WITHOUT_EXT}_updated.tex" -quiet
xelatex "${FILE_WITHOUT_EXT}_updated.tex" -quiet
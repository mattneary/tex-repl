#!/bin/bash
uuid=$(uuidgen)
src=`mktemp /tmp/$uuid.tex`
dest=`mktemp /tmp/$uuid.pdf`

render() {
  # Accepts contents and builds latex document
  (echo "\documentclass{article}"
   echo "\usepackage[paperheight=1in,paperwidth=3in]{geometry}"
   echo "\begin{document}$1\end{document}") > "$src"
  # tex -> pdf
  (cd /tmp &&
   xelatex -interaction=nonstopmode "$src" &> /dev/null
   if [ $? -eq 0 ]; then
     echo OK
   else
     echo "Failed to process latex: $tex"
   fi)
}

render "\phantom{a}"
open "$dest"

while true; do
  tex=""
  cr=$'\n'

  # Read LaTeX, treating lines prefixed by '  ' as part of a multi-line string.
  while true; do
    IFS=""
    read -p "> " -er chunk
    if [[ "${chunk:0:2}" == "  " ]]; then
      tex=$"$tex$cr${chunk:2}"
    else
      tex=$"$tex$cr$chunk"
      break
    fi
  done

  render "$tex"
done


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
  read -p "> " -er tex
  render "$tex"
done


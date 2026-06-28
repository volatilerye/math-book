#!/bin/sh

set -eu

DOC="main.tex"
CLEAN=0
RUNS=1

while [ $# -gt 0 ]; do
  case "$1" in
    --tombo|--t)
      DOC="tombo-main.tex"
      ;;
    --clean|--c)
      CLEAN=1
      ;;
    --twice|--2)
      RUNS=2
      ;;
    # ...
  esac
  shift
done

if [ "$CLEAN" -eq 0 ]; then
  mendex -r -c -g -s ./index.ist -p any ./main.idx
fi

i=1
while [ "$i" -le "$RUNS" ]; do
  lualatex \
    -file-line-error \
    -synctex=1 \
    -interaction=nonstopmode \
    -halt-on-error \
    "$DOC"
  i=$((i + 1))
done


if [ "$CLEAN" -eq 1 ]; then
  find . \
    \( \
      -name '*.aux' -o \
      -name '*.log' -o \
      -name '*.toc' -o \
      -name '*.out' -o \
      -name '*.synctex.gz' \
    \) \
    -type f \
    -delete
fi
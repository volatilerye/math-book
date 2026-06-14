#!/bin/sh

set -eu

DOC="main.tex"
CLEAN=0

while [ $# -gt 0 ]; do
  case "$1" in
    --tombo|--t)
      DOC="tombo-main.tex"
      ;;
    --clean|--c)
      CLEAN=1
      ;;
    -h|--help)
      cat <<EOF
Usage: ./build.sh [OPTIONS]

Options:
  --tombo, --t    Build tombo-main.tex
  --clean, --c    Remove auxiliary files after build
  --help, -h      Show this help
EOF
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
  shift
done

lualatex \
  --cmdx \
  -file-line-error \
  -synctex=1 \
  -interaction=nonstopmode \
  -halt-on-error \
  "$DOC"

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
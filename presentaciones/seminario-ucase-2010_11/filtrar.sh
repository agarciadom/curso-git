#!/bin/sh

# Guión sencillo para filtrar la entrada estándar para convertir
# secuencias de escape ANSI a código LaTeX.

fold -sw 80 \
    | fold -w 80 \
    | ansifilter -Lf \
    > cmd.tex

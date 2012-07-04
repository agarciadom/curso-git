PDF=transparencias.pdf
LATEXMK_FLAGS=-r latexmkrc.pl -pdf
.PHONY: all install preview clean

all: $(PDF)

install:
	git config --global color.ui always
	sudo apt-get install latexmk
	wget http://www.andre-simon.de/zip/ansifilter-1.5.tar.bz2
	tar xf ansifilter-1.5.tar.bz2
	pushd ansifilter-1.5
	make && sudo make install

%.pdf: %.tex
	latexmk $(LATEXMK_FLAGS) $<

preview: $(subst .pdf,.tex,$(PDF))
	latexmk $(LATEXMK_FLAGS) -pvc $<

clean:
	latexmk -C -pdf $<
	$(RM) $(FIGURES) $(PDF) *.synctex.gz cmd.tex

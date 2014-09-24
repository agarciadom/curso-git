DOC=apuntes-ramas.pdf
DOTTEX=\
  problema-borrar-ramas.tex \
  sinproblema-borrar-ramas.tex \
  original-reunir-ramas.tex \
  merged-reunir-ramas.tex \
  rebased-reunir-ramas.tex \
  fforward-reunir-ramas.tex

.PHONY: clean install-deps

$(DOC) :: $(DOTTEX) 

%.pdf: %.tex
	pdflatex $< && pdflatex $<

%.tex: %.dot
	dot2tex -s --figonly $< > $@
	sed -i.bak 's/tikzpicture/tikzpicture-fixed/g' $@

clean:
	$(RM) *~ $(DOTTEX) $(DOC)

install-deps:
	sudo pip install dot2tex

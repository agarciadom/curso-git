DOC=apuntes-ramas.pdf
DOTTEX=problema-borrar-ramas.tex sinproblema-borrar-ramas.tex
.PHONY: clean

$(DOC) :: $(DOTTEX) 

%.pdf: %.tex
	pdflatex $< && pdflatex $<

%.tex: %.dot
	dot2tex -s --figonly $< > $@
	sed -i.bak 's/tikzpicture/tikzpicture-fixed/g' $@

clean:
	$(RM) *~ $(DOTTEX) $(DOC)

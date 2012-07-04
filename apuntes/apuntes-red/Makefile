DOC=apuntes-red.pdf
DOTTEX=\
  fetch-nomerge-1.tex \
  fetch-nomerge-2.tex \
  fetch-nomerge-3.tex \
  fetch-ff-1.tex \
  fetch-ff-2.tex \
  fetch-ff-3.tex \
  flujo-centralizado.tex \
  ramas-repo-git.tex \
  flujo-enc-integracion.tex \
  flujo-dictador.tex

.PHONY: clean

$(DOC) :: $(DOTTEX) 

%.pdf: %.tex
	pdflatex $< && pdflatex $< && bibtex ${<:.tex=} && pdflatex $<

%.tex: %.dot
	dot2tex --autosize --figonly $< > $@
	sed -i.bak 's/tikzpicture/tikzpicture-fixed/g' $@

%.tex: %.twopi
	dot2tex --autosize --figonly --prog twopi $< > $@
	sed -i.bak 's/tikzpicture/tikzpicture-fixed/g' $@

clean:
	$(RM) *~ $(DOTTEX) $(DOC)

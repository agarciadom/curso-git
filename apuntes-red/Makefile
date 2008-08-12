DOC=apuntes-red.pdf
DOTTEX=\
  fetch-nomerge-1.tex \
  fetch-nomerge-2.tex \
  fetch-nomerge-3.tex \
  fetch-ff-1.tex \
  fetch-ff-2.tex \
  fetch-ff-3.tex

.PHONY: clean

$(DOC) :: $(DOTTEX) 

%.pdf: %.tex
	pdflatex $< && pdflatex $< && bibtex ${<:.tex=} && pdflatex $<

%.tex: %.dot
	dot2tex -s --figonly $< > $@
	sed -i.bak 's/tikzpicture/tikzpicture-fixed/g' $@

clean:
	$(RM) *~ $(DOTTEX) $(DOC)

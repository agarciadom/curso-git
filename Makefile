
SVGS =  \
	slides-me.svg        \
	slides-dd-talk.svg   \
	slides-dd-title.svg  \
	slides-ug-talk.svg   \
	slides-ug-title.svg
PDFS = $(SVGS:%.svg=%.pdf)

FINAL = slides-dd.pdf slides-ug.pdf

all: ${FINAL}

${PDFS}: %.pdf: %.svg
	negative -t pdf -o $@ $<

slides-dd.pdf: slides-dd-title.pdf slides-me.pdf slides-dd-talk.pdf
	pdftk $^ cat output $@
	
slides-ug.pdf: slides-ug-title.pdf slides-me.pdf slides-ug-talk.pdf
	pdftk $^ cat output $@

clean:
	-rm -f *~ ${PDFS} ${FINAL}


SVGS =  \
	slides-me.svg        \
	slides-dd-title.svg  \
	slides-dd-talk.svg   \
	slides-ug-title.svg  \
	slides-ug-intro.svg  \
	slides-ug-cmd.svg    \
	slides-ug-use-lcl.svg    \
	slides-ug-use-dst.svg    \
	slides-ug-use-dex.svg

PDFS = $(SVGS:%.svg=%.pdf)

FINAL = slides-dd.pdf slides-ug.pdf

all: ${FINAL}

${PDFS}: %.pdf: %.svg
	negative -t pdf -o $@ $<

slides-dd.pdf: slides-dd-title.pdf slides-me.pdf slides-dd-talk.pdf
	pdftk $^ cat output $@
	
slides-ug.pdf: slides-ug-title.pdf slides-me.pdf slides-ug-intro.pdf slides-ug-cmd.pdf slides-ug-use-lcl.pdf slides-ug-use-dst.pdf slides-ug-use-dex.pdf
	pdftk $^ cat output $@

clean:
	-rm -f *~ ${PDFS} ${FINAL}

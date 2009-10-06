
dd_SVGS =  \
	slides-dd-title.svg  \
	slides-me.svg        \
	slides-dd-talk.svg
dd_PDFS = $(dd_SVGS:%.svg=%.pdf)

ug_SVGS =  \
	slides-ug-title.svg      \
	slides-me.svg            \
	slides-ug-intro.svg      \
	slides-ug-cmd.svg        \
	slides-ug-use-cmt.svg    \
	slides-ug-use-hst.svg    \
	slides-ug-use-dst.svg    \
	slides-ug-use-dex.svg
ug_PDFS = $(ug_SVGS:%.svg=%.pdf)

SVGS = $(sort ${dd_SVGS} ${ug_SVGS})
PDFS = $(SVGS:%.svg=%.pdf)

FINAL = slides-dd.pdf slides-ug.pdf

all: ${FINAL}

${PDFS}: %.pdf: %.svg
	negative -t pdf -o $@ $<

slides-dd.pdf: ${dd_PDFS}
	pdftk $^ cat output $@
	
slides-ug.pdf: ${ug_PDFS}
	pdftk $^ cat output $@

clean:
	-rm -f *~ ${PDFS} ${FINAL}

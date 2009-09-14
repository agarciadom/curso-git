
SVGS =  \
	slides-me.svg        \
	slides-dd-talk.svg   \
	slides-dd-title.svg  \
	slides-ug-talk.svg   \
	slides-ug-title.svg
PDFS = $(SVGS:%.svg=%.pdf)


all: ${PDFS}

${PDFS}: %.pdf: %.svg
	negative -t pdf -o $@ $<


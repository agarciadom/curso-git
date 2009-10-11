
dd_SVGS =  \
	tracking-title.svg      \
	about-me.svg            \
	tracking-talk.svg
dd_PDFS = $(dd_SVGS:%.svg=%.pdf)

ug_SVGS =  \
	perfected-title.svg     \
	about-me.svg            \
	perfected-intro.svg     \
	perfected-cmd.svg       \
	perfected-use-cmt.svg   \
	perfected-use-hst.svg   \
	perfected-use-dst.svg   \
	perfected-use-dex.svg
ug_PDFS = $(ug_SVGS:%.svg=%.pdf)

SVGS = $(sort ${dd_SVGS} ${ug_SVGS})
PDFS = $(SVGS:%.svg=%.pdf)

dd_FINAL = slides-tracking-code-changes-in-git.pdf
ug_FINAL = slides-git-revision-control-perfected.pdf

FINAL = ${dd_FINAL} ${ug_FINAL}

all: ${FINAL}

${PDFS}: %.pdf: %.svg
	negative -t pdf -o $@ $<

${dd_FINAL}: ${dd_PDFS}
	pdftk $^ cat output $@
	
${ug_FINAL}: ${ug_PDFS}
	pdftk $^ cat output $@

clean:
	-rm -f *~ ${PDFS} ${FINAL}

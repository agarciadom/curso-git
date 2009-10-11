
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

dd_NAME  = slides-tracking-code-changes-in-git
dd_FINAL = ${dd_NAME}.pdf
dd_STAMP = .${dd_NAME}.stamp

ug_NAME  = slides-git-revision-control-perfected
ug_FINAL = ${ug_NAME}.pdf
ug_STAMP = .${ug_NAME}.stamp

FINALS   = ${dd_FINAL} ${ug_FINAL}
STAMPS   = ${dd_STAMP} ${ug_STAMP}

all: pdfs pngs

# pdf building...

pdfs: ${FINALS}

${dd_FINAL}: ${dd_PDFS}
	pdftk $^ cat output $@
	
${ug_FINAL}: ${ug_PDFS}
	pdftk $^ cat output $@

${PDFS}: %.pdf: %.svg
	negative -t pdf -o $@ $<

# png building...

pngs: ${STAMPS}

${dd_STAMP}: ${dd_SVGS}
	mkdir -p ${dd_NAME}
	negative -t pngs -o "${dd_NAME}/####.png" $^
	touch $@

${ug_STAMP}: ${ug_SVGS}
	mkdir -p ${ug_NAME}
	negative -t pngs -o "${ug_NAME}/####.png" $^
	touch $@

# cleanup...

clean:
	-rm -f *~ ${PDFS} ${FINALS} ${STAMPS}
	-rm -rf ${dd_NAME} ${ug_NAME}

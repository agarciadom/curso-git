
all: slides.pdf

slides.pdf: distributed-development.svg
	negative -t pdf $<

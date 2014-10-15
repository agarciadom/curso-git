EXE=hola
CFLAGS=-Wall -ansi -pedantic -ggdb
OBJS=hola_mundo.o
.PHONY: all clean

all: ${EXE}

${EXE}: ${OBJS}
	${CC} ${LDFLAGS} -o $@ $^

clean:
	${RM} *.o *~ ${EXE}

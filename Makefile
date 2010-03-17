EXE=main
CFLAGS=-Wall -ansi -pedantic -ggdb
OBJS=main.o
.PHONY: all clean

all: ${EXE}

${EXE}: ${OBJS}
	${CC} ${LDFLAGS} -o $@ $^

clean:
	${RM} *.o *~ ${EXE}

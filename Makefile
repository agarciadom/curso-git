EXE=main
CFLAGS=-Wall -ansi -pedantic -ggdb
OBJS=main.o fib.o
.PHONY: all clean

all: ${EXE}

${EXE}: ${OBJS}
	${CC} ${LDFLAGS} -o $@ $^

main.o fib.o: fib.h

clean:
	${RM} *.o *~ ${EXE}

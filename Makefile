EXE=mostrar_fib
CFLAGS=-Wall -ansi -pedantic -ggdb
OBJS=principal.o fib.o
.PHONY: all clean

all: ${EXE}

${EXE}: ${OBJS}
	${CC} ${LDFLAGS} -o $@ $^

principal.o fib.o: fib.h

clean:
	${RM} *.o *~ ${EXE}

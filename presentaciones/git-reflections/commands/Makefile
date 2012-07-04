
TYPES = all init everyday additional more special plumbing 

TARGETS = $(TYPES:%=commands-%.svg)

Q = $(if ${V},,@)

all: ${TARGETS}

commands-all.svg:        OPTS = -u 000000 init.list -u 000000 everyday.list -u 000000 additional.list -u 000000 more.list -u 000000 special.list -u 000000 plumbing.list
commands-init.svg:       OPTS = -u 0000CC init.list -u EEEEEE everyday.list -u EEEEEE additional.list -u EEEEEE more.list -u EEEEEE special.list -u EEEEEE plumbing.list
commands-everyday.svg:   OPTS = -u 0000CC init.list -u 008800 everyday.list -u EEEEEE additional.list -u EEEEEE more.list -u EEEEEE special.list -u EEEEEE plumbing.list
commands-additional.svg: OPTS = -u 0000CC init.list -u 008800 everyday.list -u 008888 additional.list -u EEEEEE more.list -u EEEEEE special.list -u EEEEEE plumbing.list
commands-more.svg:       OPTS = -u 0000CC init.list -u 008800 everyday.list -u 008888 additional.list -u 888800 more.list -u EEEEEE special.list -u EEEEEE plumbing.list
commands-special.svg:    OPTS = -u 0000CC init.list -u 008800 everyday.list -u 008888 additional.list -u 888800 more.list -u 880000 special.list -u EEEEEE plumbing.list
commands-plumbing.svg:   OPTS = -u 0000CC init.list -u 008800 everyday.list -u 008888 additional.list -u 888800 more.list -u 880000 special.list -u 444444 plumbing.list

$(TARGETS): commands-%.svg: %.list template.svg Makefile build-command-slide.pl 
	@echo "$<  => $@"
	${Q} ./build-command-slide.pl -i $< -o $@ ${OPTS}

.PHONY: all

SUBDIRS = library permission-type frac-nesting simple-concur
META = Makefile sources.cfg
GEN = clsmap.elf methmap.elf fldmap.elf predmap.elf cxt.elf
HELP = clsmap-base.elf methmap-base.elf fldmap-base.elf predmap-base.elf \
	cxt-base.elf
HAND = utils.elf set-conversion.elf reftype.elf subtyping.elf typing.elf \
	example.elf consistency.elf clsmap2predmap.elf conversion.elf before-read.elf \
  read.elf write.elf let.elf call.elf sub.elf cond.elf let-more.elf seq.elf \
	conversion.thm
CSRC = clsmap.cpp methmap.cpp fldmap.cpp predmap.cpp cxt.cpp

RELEASE = reftype.tgz

CLEANFILES = ${GEN} ${SUBDIRS} ${RELEASE}
SRC = ${META} ${HELP} ${HAND} ${CSRC}

all : ${SUBDIRS} ${SRC} ${GEN}

CAT = cat
CPP = cpp
CPPFLAGS = -DBEGIN_ELF="%}%" -DEND_ELF="%{%" -I../library
REC = ../library/remove-empty-comments.pl
GN = ../library/get-names.pl
SR = ./set-renaming.rb

%.elf : %.cpp %-base.elf
	${CPP} ${CPPFLAGS} $*.cpp | ${REC} > $$$$.elf; \
	${GN} $* $$$$.elf | ${CAT} $$$$.elf - > $*.elf; \
	rm $$$$.elf

VCI = /afs/cs.uwm.edu/users/csfac/boyland/cmd/vci

.PHONY: checkin checkout set-renamings

library :
	ln -s ../library library

simple-concur :
	ln -s ../simple-concur simple-concur

frac-nesting :
	ln -s ../frac-nesting frac-nesting

permission-type :
	ln -s ../permission-type permission-type

checkin :
	${VCI} ${SRC}

checkout :
	co ${SRC}

${RELEASE} : README sources.cfg Makefile ${GEN}
	tar cvf - README sources.cfg `cat sources.cfg` | gzip > ${RELEASE}

clean :
	rm -f ${CLEANFILES}

realclean : clean
	rcsclean

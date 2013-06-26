.PHONY: all

SUBDIRS = library permission-type frac-nesting simple-concur
META = Makefile sources.cfg
GEN = clsmap.elf methmap.elf fldmap.elf predmap.elf tgtmap.elf \
	inner-efxmap.elf efxmap.elf
HELP = clsmap-base.elf methmap-base.elf fldmap-base.elf predmap-base.elf \
	tgtmap-base.elf inner-efxmap-base.elf efxmap-base.elf
HAND = tgtmap-efxmap.elf reftype.elf cxt.elf consistency.elf \
	subst.elf subtyping.elf typing.elf consistency.thm clsmap2predmap.elf \
	clsmap2predmap.thm conversion.elf consume.thm conversion.thm

CSRC = clsmap.cpp methmap.cpp fldmap.cpp predmap.cpp tgtmap.cpp \
	inner-efxmap.cpp efxmap.cpp

RELEASE = simple-refty.tgz

CLEANFILES = ${GEN} ${SUBDIRS} ${RELEASE}
SRC = ${META} ${HELP} ${HAND} ${CSRC}

all : ${SUBDIRS} ${SRC} ${GEN}

CAT = cat
CPP = cpp
CPPFLAGS = -DBEGIN_ELF="%}%" -DEND_ELF="%{%" -I../library -Ilibrary-extra
REC = ../library/remove-empty-comments.pl
GN = ../library/get-names.pl

%.elf : %.cpp %-base.elf
	${CPP} ${CPPFLAGS} $*.cpp | ${REC} > $$$$.elf; \
	${GN} $* $$$$.elf | ${CAT} $$$$.elf - > $*.elf; \
	rm $$$$.elf

VCI = /afs/cs.uwm.edu/users/csfac/boyland/cmd/vci

.PHONY: checkin checkout

checkin :
	${VCI} ${SRC}

checkout : 
	co ${SRC}

dependency :
	(ln -s ../library library; \
	ln -s ../simple-concur simple-concur; \
	ln -s ../frac-nesting frac-nesting; \
	ln -s ../permission-type permission-type)

${RELEASE} : README sources.cfg Makefile ${GEN}
	tar cvf - README sources.cfg `cat sources.cfg` | gzip > ${RELEASE}

clean :
	rm -f ${CLEANFILES}

realclean : clean
	rcsclean

.PHONY: all

SUBDIRS = library permission-type frac-nesting simple-concur
META = Makefile sources.cfg
GEN = clsmap.elf methmap.elf fldmap.elf predmap.elf tgtmap.elf \
	fxmap.elf efxmap.elf efx.elf
HELP = clsmap-base.elf methmap-base.elf fldmap-base.elf predmap-base.elf \
	tgtmap-base.elf fxmap-base.elf efxmap-base.elf efx-base.elf
HAND = tgtmap-efxmap.elf reftype.elf cxt.elf consistency.elf \
	subst.elf subtyping.elf typing.elf consistency.thm clsmap2predmap.elf \
	clsmap2predmap.thm conversion.elf consume.thm conversion.thm
CSRC = clsmap.cpp methmap.cpp fldmap.cpp predmap.cpp tgtmap.cpp \
	fxmap.cpp efxmap.cpp efx.cpp
TRANS = set2efxmap
SET_RENAME = set-renamings

RELEASE = reftype.tgz

CLEANFILES = ${GEN} ${SUBDIRS} ${RELEASE}
SRC = ${META} ${HELP} ${HAND} ${CSRC}

all : ${SUBDIRS} ${SRC} ${GEN}

CAT = cat
CPP = cpp
CPPFLAGS = -DBEGIN_ELF="%}%" -DEND_ELF="%{%" -I./library
REC = ./library/remove-empty-comments.pl
GN = ./library/get-names.pl
SR = ./set-renaming.rb

${TRANS}.elf : ${SET_RENAME} ${TRANS}.cpp ${TRANS}-base.elf
	${CPP} ${CPPFLAGS} ${TRANS}.cpp | ${REC} > $$$$.elf; \
	${CAT} $<.elf $$$$.elf > ${TRANS}.elf; \
	rm $$$$.elf

%.elf : %.cpp %-base.elf
	${CPP} ${CPPFLAGS} $*.cpp | ${REC} > $$$$.elf; \
	${GN} $* $$$$.elf | ${CAT} $$$$.elf - > $*.elf; \
	rm $$$$.elf

${SET_RENAME} : library/set.elf
	cat $< | ${SR} > $@.elf

VCI = /afs/cs.uwm.edu/users/csfac/boyland/cmd/vci

.PHONY: checkin checkout set-renamings

checkin :
	${VCI} ${SRC}

checkout : 
	co ${SRC}

dependency :
	(ln -s ../twelf-library library; \
	ln -s ../simple-concur simple-concur; \
	ln -s ../frac-nesting frac-nesting; \
	ln -s ../permission-type permission-type)

${RELEASE} : README sources.cfg Makefile ${GEN}
	tar cvf - README sources.cfg `cat sources.cfg` | gzip > ${RELEASE}

clean :
	rm -f ${CLEANFILES}

realclean : clean
	rcsclean

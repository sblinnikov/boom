.SUFFIXES: .srs

COMDECKS=../hcol/comdecks

bin=../bin

include ../Makefile.opts
LIBS=-L../lib -lboom

all: plotr plrates plframe plsnaps plotenu plshockr

plotr: plotr.o
	$(FC) plotr.o $(LDFLAGS) $(LIBS) $(SYSLIBS) -o plotr

plrates: plrates.o
	$(FC) plrates.o $(LDFLAGS) $(LIBS) $(SYSLIBS) -o plrates

plframe: plframe.o plcommon.o
	$(FC) plframe.o plcommon.o $(LDFLAGS) $(LIBS) $(SYSLIBS) -o plframe

plsnaps: plsnaps.o plcommon.o
	$(FC) plsnaps.o plcommon.o $(LDFLAGS) $(LIBS) $(SYSLIBS) -o plsnaps

plotenu: plotenu.o plcommon.o
	$(FC) plotenu.o plcommon.o $(LDFLAGS) $(LIBS) $(SYSLIBS) -o plotenu

plshockr: plshockr.o plcommon.o
	$(FC) plshockr.o plcommon.o $(LDFLAGS) $(LIBS) $(SYSLIBS) -o plshockr

install: plotr plframe plsnaps plotenu plshockr
	install plotr $(bin)
	install plframe $(bin)
	install plsnaps $(bin)
	install plotenu $(bin)
	install plshockr $(bin)

clean:
	rm -f *.o *~ plotr plframe plsnaps plrates plotenu plshockr *.out \#* in out

# here was a buggy dependence which produced $(FC) -F (obsolete) option
#.srs.F:
#	$(bin)/prefort n ../hcol/comdecks $*.srs
#	mv $*.f $*.F

.srs.o:
	$(bin)/prefort n $(COMDECKS) $*.srs 
	mv $*.f $*.F 
	$(FC) -c $(FFLAGS) $*.F -o $*.o
	rm $*.F

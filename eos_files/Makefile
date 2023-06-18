.SUFFIXES: .srs 
OBJS=tableeos.o 
LIBS=-L../lib -lboom 
COMDECKS=../hcol/comdecks
bin=../bin

include ../Makefile.opts

tableeos: $(OBJS)
	$(FC) -o tableeos $(OBJS) $(LIBS) $(SYSLIBS)

install: tableeos
	./tableeos 
	mv eostab.6.3.new eostab.6.3

clean:
	rm -f $(OBJS) tableeos.f tableeos eostab.* *~

# here was a buggy dependence which produced $(FC) -F (obsolete) option
#.srs.F:
#	echo .srs.F: $(FC) $(FFLAGS)
#	$(bin)/prefort n $(COMDECKS) $*.srs
#	mv $*.f $*.F

.srs.o:
	$(bin)/prefort n $(COMDECKS) $*.srs 
	mv $*.f $*.F 
	$(FC) -c $(FFLAGS) $*.F -o $*.o
	rm $*.F

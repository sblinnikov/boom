srcs = prefort.f getargu.f numarg.f
objs = prefort.o getargu.o numarg.o
bin = ../bin

include ../Makefile.opts


prefort: $(objs)
	$(FC) $(SYSLIBS) $(objs) -o prefort

install: prefort
	install prefort $(bin)

clean: 
	rm -f $(objs) prefort *~ \#*

 

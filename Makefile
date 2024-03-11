all: help

install:
	cd prefort ; make install
	cd hcol ; make install
	cd eos_files ; make install
	cd plot ; make install
	cd imodels ; rm -f model.dat
	cd imodels ; ln -s woosley.dat model.dat

boom: install

help:
	@echo "Type make boom for build"
	@echo "You can do: "
	@echo " install    --  "
	@echo " boom       --  compile boom"
	@echo " clean      --  DELETE many garbage files in subdirectories"
	@echo " distclean  --  DELETE all files in outputs/ "
	@echo " dist       --  as distclean and attempt to archive smth"
	@echo " help       --  print this help"


clean:
	cd hcol ; make clean
	cd eos_files ; make clean
	cd prefort ; make clean
	cd lib ; rm -f *.a *~
	cd plot ; make clean
	cd bin ; rm -f boom tableeos prefort plotr plframe plsnaps plotenu plshockr *~
	rm -f *~ datainp/*~ imodels/model.dat

distclean: clean
	mkdir tmprdr
	@echo $(shell pwd)
	mv outputs/README  tmprdr/
	rm -f outputs/*
	mv  tmprdr/README outputs
	rmdir tmprdr

dist: distclean
	rm -f boom-`date +%Y%m%d`.tgz
	cd .. ; tar czf boom-`date +%Y%m%d`.tgz --exclude RCS \
             --exclude .svn boom --exclude .git boom



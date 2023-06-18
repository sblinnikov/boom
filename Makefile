install:
	cd prefort ; make install
	cd hcol ; make install
	cd eos_files ; make install
	cd plot ; make install
	cd imodels ; rm -f model.dat
	cd imodels ; ln -s woosley.dat model.dat

boom: install

clean:
	cd hcol ; make clean
	cd eos_files ; make clean
	cd prefort ; make clean
	cd lib ; rm -f *.a *~
	cd plot ; make clean
	cd bin ; rm -f boom tableeos prefort plotr plframe plsnaps plotenu plshockr *~
	rm -f *~ datainp/*~ imodels/model.dat

distclean: clean
	rm -f outputs/*

dist: distclean
	rm -f boom-`date +%Y%m%d`.tgz
	cd .. ; tar czf boom-`date +%Y%m%d`.tgz --exclude RCS \
             --exclude .svn boom 



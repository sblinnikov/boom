# boom write-up by SeB  

origin  git@github.com:sblinnikov/boom.git  

## Introduction  

This is a README file made by S.I.Blinnikov from the original README  
-- some corrections are marked by SeB, but many are just added.  

The interactive documentation used to be at  

http://en.wikiversity.org/wiki/BoomCode  

but it seems that the link does not work properly now  
(10.01.2014, updated 20.11.2025)  

Author:  
Joseph Chen-Yu Wang joe@confucius.gnacademy.org  
President, Globewide Network Academy - http://www.gnacademy.org/  

S.B. Physics - MIT - 1991 Ph.D. Astronomy - University of Texas at Austin  

Author's e-mail joe@confucius.gnacademy.org  


## QUICKSTART  

cd <rootdir> for boom  
edit Makefile.opts to set compiler options  

SeB:  

There are prepared Makefile.opts.gf etc.  

Almost nothing works in original scripts.  

### GFORTRAN  

E.g. for gfortran:  Makefile.opts.gf wanted /usr/lib/libg2c.a which was absent.  
One can take it from /opt/sage-4.6.2/local/lib/libg2c.a if sage is installed.  
It starts working with SYSLIBS= -lgfortran (no libg2c.a is used) but at some  
point the compilation crashed finding errors in formats.    

In original code there were many warnings on type mismatch of formal and actual  
arguments, gfortran did not work with default options,  
intel fortran works OK with this.  

In gfortran  
FFLAGS=-fallow-argument-mismatch  
option degrades type mismatch of arguments to warnings,  
but the executable crashed immediately.
It is better to correct this mismatch which is done now by SeB.
Use Makefile.opts.gfstrict as a template for Makefile.opts with gfortran.  


Function exp10() is OK for ifort/ifx but is absent in gfortran.  
So, it is defined as  
  exp10(x) = 1d1**x  
in plot/plshockr.srs  

### INTEL IFORT AND IFX  

Makefile.opts.ifc wants  
SYSLIBS= -lsvml -lguide -no-ipo -lpthread  
but  -lguide is deprecated in the newer releases of intel compiler suite,  
use -liomp5 instead.  

Makefile.opts.ifc13 works with this option  
-- tested with ifort version 14.0.2 and version 2021.9.0 .  

Makefile.opts.ifc21 works with ifort 2021.11.1.  

Now Makefile.opts.ifx works with ifx versions through 2025.*.* prior to 2025.3.0 .  
Version 2025.3.0 fails with unformatted *.t09 file trying to read more data.  
A new version of boom is now prepared with formatted read/write to *.t09 files.  




## BUILDING EXECUTABLE  

So, e.g., just  
 cp Makefile.opts.ifx Makefile.opts  
then:  

make (to read help)  
make clean  
make boom  
  
copy bin/runboom.sample to bin/runboom:  
 cp bin/runboom.sample bin/runboom  
edit bin/runboom to set the actual <rootdir> for boom in the line, e.g., I use  
  
my($rootdir) = "/home/seb/prg/boom";  
or  
my($rootdir) = "/home/seb/prg/gitWork/boom";  

NB. bin/runboom.sample redirects stdout to the file $outdir/$model.t06. 
Explore *.t06 text for important messages and diagnostics.  
I add my messages with '***NB***' mark.  

This will build boom with formatted *.t09.  
If you want to use old unformatted version do  

 make -f unf.mak clean  
 make -f unf.mak boom  



## Boom parameters  

Boom parameters (given in *.srs files like input.srs):  

adaptlag - Turn on or off adaptive meshing  
 0 = off  
 1 = on  

 smass - Output mass limit (solar mass)  
 keyzons - Initial zoning (use 4)  
 nitmax - Maximum iterations per run  
 timax - Maximum simulation time  
 runtime - Maximum CPU time  
 keos is the equation of state  
 6 =  
 7 = interpolated table  
 inprof = two parts.  
The last digit is the keyets c inprof has 2 digits :  
 the 2nd stands for keyets c  
 the first is for the initial configutation  
 c 1 isentrope  
 c 2 isothermal  
 c 3 wzw call wwconf  
 c 4 arnett,s 1.5 m call arconf  
 c 5 wzw 1.5 m call wzconf  
 c 8 nomoto9 call nmconf  
 c 9 s15s7b2 call wznconf  
 c 10 sedov test  
  
 keyets = 1 (ro, e) given   
 keyets = 2 (ro, t) given   
 keyets = 3 (ro, s) given (choose this)  
  
 sedove - Energy to add for sedov test used only for initial config 10  
 sedovm - Mass to add for sedov test only for initial config 10  
 pexter = outer pressure boundary condition  
 stab - Hydrodynamical stability factor. Time step / courant time. Choose 0.5  
  

#### = Neutrino Algorithm =  
 kdnscat - turn on down scattering.  

## TO RUN:  

Prepare input model imodels/model.dat, e.g.  
from the root boom/ directory  

cp imodels/woosley.dat imodels/model.dat  

To run without perl script, try e.g. 

./bin/boom datainp/test3nr.1 

./bin/boom datainp/test3nr.2  

etc. until  

./bin/boom datainp/test3nr.5  

Change boom to boomunf here for unformatted t09 version.  

To run the same with the perl script runboom:

cd bin  

./runboom test3nr 1 5  (OK in gfortran and in ifx)

will run test3nr models, which are good for fast tests.  
Change runboom to runboomunf here for unformatted t09 version.  


For debug (if compiled with -g option)  

gdb ./bin/boom  

 r datainp/tau3.1  
 r datainp/tau3.2  
...  
or  
 r datainp/test3nr.1  
 r datainp/test3nr.2  
...  
etc.  

For other models in bin/ directory  

./runboom <model name> 1 5  

1 here is the first stage, 5 is the final stage  
./runboom <model name> 5  
will do the same  

Probably,  

./runboom <model name> 5 10  

will begin from stage 5 and continue to stage 10 (this must be checked).  

E.g.  

./runboom test3 1 2
-- a quick initial test (crashes in gfortran, OK in ifx)


See the file datainp/README for model names.  

tau3 is the most realistic model.  

Files like tau3.1 contain namelist &cor with main control parameters.  

  
## GETTING DATA OUT  

cd plot  

The data are saved in a number of files with extensions:  

t06 t09 (?) t10 dump files   
t12 ntplot - flow lines for plotr, plshockr and plotenu routines  
t13 ro-snaps  
t15 profiles snap  
t17 may be used instead of plot.out in plframe and plsnaps  
t25 full group y and fluxes  
t35 a profile for Alexei(?) hydro variables+concentrations  
t45 a profile for convective energies and fluxes  
t55 a profile(?) for shock profiles  
t77 extract file - briefings: it outputs each 1000 steps, e.g.:  

ntime= 38000  time= 254.119 msec.  dt=     0.784 musec.  

so use, e.g.  

 tail -f tau3.t77  

to monitor your run if you have the model tau3 from directory plot/ :

 ./plotr ../outputs/tau3.t12 2 > tau3.t12.pl  
or for test3nr model  
 ./plotr ../outputs/test3nr.t12 2 > test3nr.t12.pl  
-- produces a set of r(t) plots with a step in the second arg (here 2).  
The file like test3nr.t12 contains too many profiles of physical quantities,  
so the step allows to rarefy the output and to get good plots.  

One may omit the second argument:  
  
 ./plotr ../outputs/tau3.t12 > tau3.t12.pl  
or  
 ./plotr ../outputs/test3nr.t12 > test3nr.t12.pl  
-- if the second argument is omitted, then the default is step=10  

tau3.t12.pl or test3nr.t12.pl, etc., can be plotted  
with ploticus (http://ploticus.sourceforge.net/):  

 ploticus tau3.t12.pl (or pl tau3.t12.pl, if alias pl is defined)  

For output like qq.pl one can produce a png file with:  
 ploticus -f qq.pl -o qq.png -png  

 ploticus -f tau3.t12.pl -o tau3.t12.png -png  
gives tau3.t12.png  


-- see man ploticus and other examples below  

 ./plotr ../outputs/test3nr.t12 15 > test3nr.t12.pl  

 ploticus -f test3nr.t12.pl -o test3nr.t12.png -png  
gives test3nr.t12.png  


./plshockr ../outputs/tau3.t12 100 > tau3.100.shk  
or  
./plshockr ../outputs/test3nr.t12 100 > tau3.100.shk  
-- produces a set of shock radii with a step in the second arg (here 100)  
./plshockr ../outputs/tau3.t12 > tau3.10.shk  
or  
./plshockr ../outputs/tau3.t12 > tau3.10.shk  
or  
./plshockr ../outputs/test3nr.t12 > test3nr.10.shk  

-- if the second arg is omitted, then the default is step=10  

./plotenu ../outputs/tau3.t12 2 > tau3.t12.Lnu  
or by default  
./plotenu ../outputs/tau3.t12 > tau3.t12.Lnu  
-- produces a set of neutrino Luminosity Lnu(t) plots in 1e50 erg/s  
when the second arg is 2 or omitted  

./plotenu ../outputs/tau3.t12 2 > tau3.t12.enu  
-- produces a set of the mean neutrino energy Enu in MeV  
when the second arg is 1  


./plframe - produces a snapshot of many variables at a single moment  
./plsnaps - shows the time evolution of a variable  

### A typical run of plsnaps follows  

------------------------------------------------------------  
joe@bodhi plot]$ ./plsnaps  
 type name  
../outputs/tau3  
tau3c     30.07.93         181  
   12    3         0         7       176sofhead  
  181  123    0    7  176
  type start end inc (msec)
200 300 10
 type xvar (m, r, or logr)
m
 type yvar
s

if one types e.g.
w

the code tells:

  no such var. if you want to stop type:
                  stop, end or nomore
  existing variables are: e, ro, s, t, v, ye, r, gama, p, zones

After prompt  
  type start end inc (msec)  
  180 420 60  
-- would be a better choice, since first points are not interesting  
Now, e.g.:  
 type xvar (m, r, or logr)  
m  
 type yvar  
t  

These applications produce a file called plot.out which can be plotted  
with ploticus (http://ploticus.sourceforge.net/)  

pl plot.out  

Of course, plot.out can be renamed and saved as e.g. plotTmModel_tau3.out  


Then using a text editor change in the file  
 plot.out  
    yrange:   0.000000000000000E+000   15.0000000000000  
to  
    yrange:   0.000000000000000E+000   25.0000000000000  
or higher, if end time is larger than 420,  in all lines,  this is T in MeV  


    ploticus plot.out -jpeg -o t_r_4.jpg

or better
               -png -o tm.png

then the file is smaller,

x - mass M_r/Msun- T in MeV

If we rename plot.out to TMplot.out, then we can use sm macro  
tpM from the script TpMr.sm to plot Tp(M_r) graph.  

If we select entropy s then we rename plot.out to sMplot.out, 
and entrM macro from entropMr.sm .  


------------------------------------------------------------  

## COMPILERS

Author's old remark: I've found that boom tends to always show new bugs with a
new compiler. 
Boom has been run on Linux ia32 with Intel  
Fortran 7,8, and 9.  
It also runs on x86_64 with Intel Fortran 9, but the cpu timer seems to stop working.  

SeB: ifort version 2021.9.0 seems to work OK.  

Makefile.opts.ifc21 works with ifort 2021.11.1  

Makefile.opts.ifx24 and Makefile.opts.ifx are equivalent, they differ  
only in comments.  

Both are OK for recent ifx compilers
(tested through version 2025.3.0).  

------------------------------------------------------------  

### Notes on SeB corrections  

Use Makefile.opts.gf7 for gfortran 7.5 and Makefile.opts.gf{strict} for newer versions of gfortran.  

After SeB corrected the code, the warnings on mismatch of actual and formal  
parameters disappeared, and it works, but there is a dangerous place: 
files with extension t06 were linked to unit=6  
which is stdout, and gfortran failed to work in open statements with modifying status.  

SeB changed unit=6 to unit=16 but this is not debugged yet in detail.  

## Model runs (from Wang's thesis Sec. 5.1)  


Table lists the models which were run.   

_________________________________________________________________  

| model name |  nu-types |    convection    |  
|:---------- | :--------:|:---------------  |
|ntest1      |   none    | none             |
|test3       |nu_e       |  none               |
|test3c      |nu_e       |  standard parameters|  
|tau3        |all species|  none               |
|tau3c       |all species|  standard parameters|  
|tau3ca      |all species|  convective braking | 
|tau3ctp     |all species|  turbulent pressure | 
|tau3ctpa    |all species|  turbulent pressure and convective braking  |  
|tau3nd      |all species|  neutrino advection  
____________________________________________________________________  

The model ntest1 did not include neutrino transport and was intended to test
the hydrodynamics of the code and to insure that an explosion was possible 
without neutrino losses taken into account. 
Because convection requires neutrino losses to create the initial negative entropy 
gradient, no models without neutrino losses but with convection were computed.

The models test3 and test3c were run with electron neutrinos only.
The test3 model did not contain convection while test3c contained convection 
with the standard convection parameters, as defined in chapter 4 of dissertation
(asymmetry parameter =0.1, all other parameters =1.0, no salt finger mixing).
Although physically unrealistic, these models were intended to calculate 
the impact of different neutrino heating assumptions on the behavior of the model.

The models tau3 contained all neutrino species. 

Model tau3 omitted convection and was intended as a control against which models with
convection were to be compared. 

Model tau3c was a model with the standard parameters for convection described earlier.

Model tau3ca contained an extra convective term in order to be taken into account, 
albeit in a crude fashion, for the mechanism of Burrows, Hayes, and Fryxell (1995)
in which convection decreases the net infall velocity and therefore increases the 
"residence time" which material has to heat within the gain radius.  
Because non-electron neutrinos and convection were turned off before bounce, the 
characteristics of the infall phase in all of the models were identical. 
Bounce occurred 203 milliseconds after the start of the simulation, and the maximum 
central density was 2.8 x 10^4 grams/cm^3.  

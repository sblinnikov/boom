#GNU Fortran
FC=gfortran
#FFLAGS=-O3 -g
#FFLAGS=-g
FFLAGS= -fallow-argument-mismatch
#SYSLIBS= -lgfortran /usr/lib/libg2c.a
#SYSLIBS= -lgfortran /opt/sage-4.6.2/local/lib/libg2c.a
SYSLIBS= -lgfortran


# G95
#FC=g95
#FFLAGS=-O3

# Intel Fortran 7.0
#FC=ifc
#FFLAGS=-O3 -ip -g -fno-alias -axKW -vec_report2
#SYSLIBS= -lintrins -lPEPCF90 -lsvml
#FFLAGSBUG=$(FFLAGS)

# Intel Fortran 8.0
#FC=ifort
#FFLAGS=-g -O3 -ip -axKN -pg -vec_report2
#FFLAGSBUG=-g 
#SYSLIBS= -lsvml

# Intel Fortran 9.0
#FC=ifort
#FFLAGS=-g -O3 -pg -axKWN -ip -vec-report2 -parallel # 32bit
#FFLAGS=-g -O3 -pg -axW -ip -vec-report2 -parallel # 64bit
#FFLAGSBUG=-g 
#SYSLIBS= -lsvml -lguide -no-ipo

# Intel Fortran 10.1
#FC=ifort
#FFLAGS=-g -O3  # 32bit
#FFLAGS=-g -O3 -pg -axKWN -ip -vec-report2 -parallel # 32bit
#FFLAGS=-g -O3 -pg -axW -ip -vec-report2 -parallel # 64bit
#FFLAGSBUG=-g 
#SYSLIBS= -lsvml -lguide -no-ipo -lpthread

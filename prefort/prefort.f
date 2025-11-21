      program prefort
c      ------------------------------------------------------
c      insert all comdecks to their calling lines 
c      input on command-line:
c      prefort option [book_name] file1 file2...
c
c      file1,file2... files containing sources and comdecks            
c      option is any combination of the letters bcsf or n
c      if the letter b apears book_name follows the option
c      otherwise book_name must be omitted
c      option=n (normal) sub1.f sub2.f ... files are produced
c                        subn.f is a file containing subroutine subn
c                               ready for the fortran-compiler.
c      option=f (first-time) prevents producing subn.f files
c                               produces subs.srs,comdecks
c      option=b (book) a book containing all sub1.f,sub2.f...is written
c                      to file named bbok_name (shoud have a suffix .f)
c      option=s (source) sub1.srs sub2.srs... files are produced
c                        subs.srs contains a source of subroutine subs
c      option=c (comdecks) a file named "comdecks" is produced
c                          containing all comdecks
c     
c      nt1 scratch-file to which all decks are copied
c      nt2 contains all comdecks in original form. 
c          "comdeck" file if c option is used.
c      nt3 scratch used for producing insertions of comdecks in comdecks
c      nt4 scratch-file containing comdecks with all insertions
c      nt5 book of all subn.f suroutines (ready for ftn) "book_name-file.
c      nt6 used for writing subn.f files
c      nt7 used for writing subn.srs files
c     --------------------------------------------------------------------
      parameter (nameleng=15)
      character like*132,line*132,lfn*100,filout*100 
      character option*4,xname*80,filim(50)*100
c
      nt1=91
      nt2=92
      nt3=93
      nt4=94
      nt5=95
      nt6=96
      nt7=97
c
      ndecks=0
      ksors=0
      kfort=1
      kcoms=0
      kbook=0
c
   10 format(a)
c
      option='    '
      call getargu(1,option)
      do 170 n=1,4
      if(option(n:n).eq.'s') ksors=1
      if(option(n:n).eq.'f') kfort=0
      if(option(n:n).eq.'f') ksors=1
      if(option(n:n).eq.'f') kcoms=1
      if(option(n:n).eq.'c') kcoms=1
      if(option(n:n).eq.'b') kbook=1
      if(option(n:n).eq.'s') ksors=1
      if(option(n:n).eq.'f') kfort=0
      if(option(n:n).eq.'f') ksors=1
      if(option(n:n).eq.'f') kcoms=1
      if(option(n:n).eq.'c') kcoms=1
      if(option(n:n).eq.'b') kbook=1
  170 continue
c
      open(unit=nt1,iostat=ierr,form='formatted',status='scratch'
     1,err=91)
      open(unit=nt3,iostat=ierr,form='formatted',status='scratch'
     1,err=93)
      open(unit=nt4,iostat=ierr,form='formatted',status='scratch'
     1,err=94)
c
      if(kcoms.ne.0) go to 180
      open(unit=nt2,iostat=ierr,form='formatted',status='scratch'
     1,err=92)
      go to 190
  180 continue
      open(unit=nt2,file='comdecks',status='unknown'
     1,form='formatted',err=98,iostat=ierr)
  190 continue
      if(kbook.ne.0) go to 200
c
c     no-book of compile-ready program
      nf1=2
      open(unit=nt5,iostat=ierr,form='formatted'
     1,err=95,status='scratch')
      go to 210
  200 continue
c
c     book of compile-ready program on filout
      nf1=3
      call getargu(2,filout)
      print *,' open output file=',filout
      open(unit=nt5,file=filout,iostat=ierr,form='formatted'
     1,err=99,status='new')
  210 continue
c
c     copy all input files to nt1(=all decks),nt2,nt3(=all comdecks)
      ncoms=0
      ndcks=0
      call numargu(nfils)
      do 110 nf=nf1,nfils
      call getargu(nf,lfn)
      filim(nf)=lfn
      nfx=nf+20
c      write(*,*)'nf,nfx=',nf,nfx
c      pause
      if(nfx.ge.90) stop ' many input files as arguments'
      open(unit=nfx ,file=lfn    ,iostat=ierr,form='formatted'
     1,err=90,status='old')
  120 continue
      line=' '
      read(nfx,10,end=110) line
      if(line(1:5).eq.'*deck') go to 150
      if(line(1:8).eq.'*comdeck'.or .line(1:3).eq.'*cd') go to 140
      go to 120
c
c     copy comdecks to nt2,nt3
  140 continue
      ncoms=ncoms+1 
      call writel (nt2,line)
      write(nt3,10) line
  130 continue
      line=' '
      read(nfx,10,end=110) line
      if(line(1:5).eq.'*deck') go to 150
      if(line(1:8).eq.'*comdeck'.or .line(1:3).eq.'*cd') go to 140
      call writel (nt2,line)
      if(line(1:1).eq.'c')     go to 130
      write(nt3,10) line
      go to 130
c
c     copy decks to nt1
  150 continue
      ndcks=ndcks+1 
      write(nt1,10) line
  160 continue
      line=' '
      read(nfx,10,end=110) line
      if(line(1:5).eq.'*deck') go to 150
      if(line(1:8).eq.'*comdeck'.or .line(1:3).eq.'*cd') go to 140
      write(nt1,10) line
      go to 160
c
  110 continue
      print 111,nf1,nfils,(filim(nf),nf=nf1,nfils)
  111 format(' input files from',i2,' to',i2,':',5(1x,a10)/
     1,' ',8a10/' ',8a10) 
 
      rewind nt1
      rewind nt2
      rewind nt3
      rewind nt4
      if(ndcks.eq.0) go to 997
      if(ncoms.eq.0) go to 300
c     ----------------------------------------------------------------
c     make all inserts in comdecks (nt2,nt3 original comdecks,nt4=result)
      call makecom(nt2,nt3,nt4,keyerr,nameleng)
      if(keyerr.ne.0.and.kfort.ne.0) then
      line= '       remark inserted by prefort: a comdeck missing'
      call writel(nt6,line)
      stop 'a comdeck missing'
      endif
c     ----------------------------------------------------------------
c
c     read a line from nt1 (ommit *deck lines and replace *call lines)
c     copy resulting text to nt5
   40 continue
      line=' '
      read (nt1,10,end=50) line
      if(line(1:5).eq.'*call') go to 60 
      if(line(1:5).eq.'*deck') go to 41 
      if(ksors.ne.0) call writel(nt7,line)
      call writel(nt5,line)
      if(line(1:1).eq.'c') go to 40
      if(kfort.ne.0) call writel(nt6,line)
      go to 40
c
c     a new deck found. open files deckname.f deckname.s
   41 continue
      ndecks=ndecks+1
      if(ksors.eq.0) go to 42
      call fname(line,xname,'.srs',nameleng)
      print *,' open file=',xname
      if(ndecks.gt.1) close(unit=nt7,status='keep')
      open(unit=nt7,file=xname,status='unknown'
     1,iostat=ierr,form='formatted',err=97)
      call writel(nt7,line)
   42 continue
      if(kfort.eq.0) go to 43
      call fname(line,xname,'.f  ',nameleng)
      if(ndecks.gt.1) close(unit=nt6,status='keep')
      open(unit=nt6,file=xname,status='unknown'
     1,iostat=ierr,form='formatted',err=96)
      print *,' open file=',xname
   43 continue
      go to 40
c
c     *call was found, replace it by the corresponding comdeck
   60 continue
      if(ksors.ne.0) call writel(nt7,line)
      if(kfort.eq.0) go to 40
      rewind nt4
   61 continue
      like=' '
      read (nt4,10,end=998) like
      if(like(1:8).ne.'*comdeck'.and.like(1:3).ne.'*cd') go to 61
      if(like(10:9+nameleng).eq.line(7:6+nameleng))  go to 100
      go to 61
c
c           comdeck has been found
  100 continue
      line=' '
      read (nt4,10,end=40 ) line
      if(line(1:5).eq.'*deck'   ) go to 999
      if(line(1:8).eq.'*comdeck'.or.line(1:3).eq.'*cd') go to 40
      if(kfort.ne.0) call writel(nt6,line)
      call writel(nt5,line)
      go to 100
c     ----------------------------------------------------- 
c
c     no comdecks. write nt1 to nt5 omitting *deck lines
  300 continue
      rewind nt1
  310 continue
      line=' '
      read (nt1,10,end=50) line
      if(line(1:5).eq.'*deck') go to 341
      if(line(1:5).eq.'*call'.and.kfort.ne.0) then
      line= '       remark inserted by prefort: missing comdecks'
      call writel(nt6,line)
      stop ' missing comdecks'
      endif
      if(ksors.ne.0) call writel(nt7,line)
      call writel(nt5,line)
      if(line(1:1).eq.'c') go to 310
      if(kfort.ne.0) call writel(nt6,line)
      go to 310
c
  341 continue
      ndecks=ndecks+1
      if(ksors.eq.0) go to 342
      call fname(line,xname,'.srs',nameleng)
      if(ndecks.gt.1) close(unit=nt7,status='keep')
      open(unit=nt7,file=xname,status='unknown'
     1,iostat=ierr,form='formatted',err=97)
      call writel(nt7,line)
  342 continue
      if(kfort.eq.0) go to 343
      call fname(line,xname,'.f  ',nameleng)
      if(ndecks.gt.1) close(unit=nt6,status='keep')
      open(unit=nt6,file=xname,status='unknown'
     1,iostat=ierr,form='formatted',err=96)
  343 continue
      go to 310
c
c      ----------------------------------------------------------
   50 continue
      stop 'well done'
c     -------------------------------------------------------------
c
c      errors
   90 print *,ierr
      print *,' cannot open input  file=',lfn    
      stop 'io-err 90'
   91 print *,ierr
      stop 'io-err 91'
   92 print *,ierr
      stop 'io-err 92'
   93 print *,ierr
      stop 'io-err 93'
   94 print *,ierr
      stop 'io-err 94'
   95 print *,ierr
      stop 'io-err 95'
   96 print *,ierr
      stop 'io-err 96'
   97 print *,ierr
      stop 'io err 97'
   98 print *,ierr
      stop 'io err 98'
   99 print *,ierr
      stop 'io-err 99'
c                  comdeck has not been found
  997 continue
      stop ' no decks'
  998 continue
      print *,' comdeck or deck error in like='
      print *,' line:',line
      go to 963
  999 continue
      print *,' deck found before end of comdeck in line='
      print *,line
      print *,' comdeck=',like(10:9+nameleng)
  963 continue
      line= '       remark inserted by prefort:  comdeck or deck err'
      if(kfort.ne.0) call writel(nt6,line)
      stop ' comdeck errors 999'
c
      end 
      subroutine fname(line,xname,prefix,nameleng)
      character xname*(*),line*(*),prefix*4,low*1
c
      xname=' '
      n=5
      k=0
   10 continue
      n=n+1
      if(n.gt.72) stop 'deck without name'
      if(line(n:n).eq.' ') go to 10
   20 continue
      k=k+1
      if(k.gt.nameleng) stop ' long deckname'
      call lowcase(line(n:n),low)
      xname(k:k)=low       
      n=n+1
      if(line(n:n).ne.' ') go to 20
      xname(k+1:k+4)=prefix 
      return
      end
      subroutine lowcase(u,l)
      character u*1,l*1
c
      l=u
      if(u.eq.'A') l='a'
      if(u.eq.'B') l='b'
      if(u.eq.'C') l='c'
      if(u.eq.'D') l='d'
      if(u.eq.'E') l='e'
      if(u.eq.'F') l='f'
      if(u.eq.'G') l='g'
      if(u.eq.'H') l='h'
      if(u.eq.'I') l='i'
      if(u.eq.'J') l='j'
      if(u.eq.'K') l='k'
      if(u.eq.'L') l='l'
      if(u.eq.'M') l='m'
      if(u.eq.'N') l='n'
      if(u.eq.'P') l='p'
      if(u.eq.'Q') l='q'
      if(u.eq.'O') l='o'
      if(u.eq.'R') l='r'
      if(u.eq.'S') l='s'
      if(u.eq.'T') l='t'
      if(u.eq.'U') l='u'
      if(u.eq.'V') l='v'
      if(u.eq.'W') l='w'
      if(u.eq.'X') l='x'
      if(u.eq.'Y') l='y'
      if(u.eq.'Z') l='z'
      return
      end
      subroutine makecom(nt2,nt3,nt4,keyerr,nameleng)
c
c     insert comdecks into comdecks wherever a *call... encountered
c     nt4 contains original text
c     on nt2 all comdecks are copied
c     on nt3 comdecks with all insertions are copied
c            followed by all original decks (i.e. no insert. in decks)
c
      character like*132,line*132
c
      keyerr=0
      iters=0
      ncoms=0
      rewind nt2
      rewind nt3
      rewind nt4
c
   10 format(a)
c
  400 continue
      rewind nt3
      iters=iters+1 
      if(iters.gt.10) stop ' many iters'
      ncalls=0
   40 continue
      line=' '
      read (nt3,10,end=50) line
      if(line(1:5).eq.'*deck') stop ' deck not expected on nt3'
      if(line(1:5).eq.'*call') go to 60 
      write(nt4,10) line
      go to 40
c                  *call was found
   60 continue
      ncalls=ncalls+1
      rewind nt2
   61 continue
      like=' '
      read (nt2,10,end=999) like
      if(like(1:8).ne.'*comdeck'.and.like(1:3).ne.'*cd') go to 61
      if(like(10:9+nameleng).eq.line(7:6+nameleng))  go to 101
      go to 61
c           comdeck has been found
  101 continue
c     print *,' insert:',like
  100 continue
      line=' '
      read (nt2,10,end=40 ) line
      if(line(1:5).eq.'*deck'   ) stop ' deck not expected on nt2'
      if(line(1:8).eq.'*comdeck'.or.line(1:3).eq.'*cd') go to 40
      write(nt4,10) line
      go to 100
c     ----------------------------------------------------- 
c
c     copy back nt4 to nt3
   50 continue
      rewind nt2
      rewind nt3
      rewind nt4
      do 80 n=1,55555
      line=' '
      read (nt4,10,end=90) line
      write(nt3,10)        line
   80 continue
      stop ' more than 55555 lines'
   90 continue
      rewind nt2
      rewind nt3
      rewind nt4
      if(ncalls.ne.0) go to 400
c
c     all *call comdeck in comdecks are satisfied 
      return
c     ------------------------------------------------------------------
c
c     errors
c     comdeck has not been found
  999 continue
      print *,' comdeck has not been found '
      print *,line
      keyerr=1
      return
      end 
      subroutine writel(nt,line)
      character line*(*)
c
      n=133
   30 continue
      n=n-1
      if(n.eq.0) go to 50
      if(line(n:n).ne.' ') go to 40
      go to 30
   40 continue
      if(.not.(line(1:1).eq.'c'.or.line(1:1).eq.'C').and.n.gt.72) then
      print *,    ' following FORTRAN line illegal. length=',n
      print 10,line(1:n)
      write(nt,*) ' following FORTRAN line illegal. length=',n
      endif
      write(nt,10) line(1:n)
   10 format(a)
c
   50 continue
      return
      end

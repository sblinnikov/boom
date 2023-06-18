      program  plotro
      implicit real*8(a-h,o-z)
      parameter  (ndim=1000)
      real  x(ndim),y(ndim)
      real  x1,x2,y1,y2,dx1,dx2,dy1,dy2,zavit
      real shiftx,shifty
      dimension  fm(ndim),ro(ndim)
      character*10  name,namef
      character*10  job,datex,clockx,version
      character*30  path
      character*50  plotfile
      character*28  datef,datelabel
      character*10  user,usernam
      character*10  header(10)
      character*10  hx,hy,timlabel
      integer  screen
      data  path/'/usr/aux/itamar/'/
      pi=asin(1d0)
      degrad=180d0/pi
      loc=index(path,' ')-1
      open(unit=6)
      print *,' type job name'
      read (*,800) name
 800  format(a)
      print *,'type a nonzero # for screen'
      read *,screen
      call  pfname(name,namef,lng)
      if(lng.eq.0)  print *,'illegal name'
      if(lng.eq.0)  stop 'illegal name'
      open(unit=13,file=path(1:loc)//namef(1:lng)//'.t13',status='old'
     1,access='sequential',form='formatted')
      rewind  13
      close(unit=6)
      open(unit=6,file=namef(1:lng)//'.out',status='unknown'
     1,access='sequential',form='formatted')
      read (13,903) header
903   format(10a10) 
      print  901,header
901   format(10a10)
      job=header(1) 
      print *,' job=',job
      datex=header(2)
      print *,' date=',datex
      clockx=header(3)
      print *,' clock=',clockx
      version=header(4) 
      print *,' version=',version
1     format(i10)
      read  (header(5)(1:10),1) jmax
      read  (header(6)(1:10),1) ngmax
      read  (header(7)(1:10),1) keygr
      read  (header(8)(1:10),1) keyeos
      read  (header(9)(1:10),1) jmxeq1
      print 902,jmax,ngmax,keygr,keyeos,jmxeq1
902   format(' jmax=',i5,' ngmax=',i5,' keygr=',i2,
     1 ' keyeos=',i2,' jmxeq1=',i3)
      np=jmax-1
9     format(a10)
      read (13,*) (fm(i),i=1,np)
      do   i=1,np
      x(i)=fm(i)/1.99e33
      enddo
      nt=0
      hx='mass'
      hy='ro'
      if(screen.eq.0) then
      plotfile=path(1:loc)//namef(1:lng)//'.ro-profs.mongo'
      call psfile(plotfile)
      call psland
      call setlweight(0.50)
c     call setloc(150.0,150.0,600.0,450.0)
      call setexpand(0.)
      call margins(1.,1.,1.,1.)
      call setexpand(1.)
      else
      call device(13)
      call tsetup
      call setexpand(0.)
      call margins(1.,1.,1.,1.)
      call setexpand(1.)
      call erase
      end if
      xmin=0d0
      xmax=1.5d0
      dx=0.1d0
      ymin=6d0
      ymax=15d0
      x1=xmin
      x2=xmax
      y1=ymin
      y2=ymax
      call setlim(x1,y1,x2,y2)
      dx1=    dx
      dx2=5.0*dx
      dy1=-1.
      dy2=0.
      call ticksize (dx1,dx2,dy1,dy2)
      call box(1,2) 
      k=index(hx,' ')-1
      call xlabel(k,hx)
      k=index(hy,' ')-1
      call ylabel(k,hy)
      k=index(job,' ')-1
      call tlabel(k,job)
      print *,'job-name=',job, 'length(name)=',k
      datelabel=datef()
      call rlabel(10,datex)
      usernam=user()
      print *,'user name=',usernam
c      call relocate (x2+0.25*dx,y2+0.5*dy)
      shifty=1.
      shiftx=1.25*dx1
      call relocate (x2+shiftx,y2+shifty)
      call setexpand(1.5)
      call setangle (-90.)
      call label(10,usernam)
      call setangle (0.)
      call setexpand(1.0)
      call grid (0)
c-----------------------------------------------------------
15    continue
      read (13,*,end=900) t
      nt=nt+1
      print *,'  nt=',nt,'  time=',t
      write (timlabel(1:7),801) t
 801  format('t=',3pf5.1)
      read (13,*) (ro(i),i=1,np)
      do   i=1,np
      y(i)=log10(ro(i))
      enddo
      call connect(x,y,np)
      j=2
 24   if(x(j).gt.0.6) then
                      goto  25
                      else
                      j=j+1
                      if(j.eq.np)  goto  25
                      goto  24
                      endif
 25   continue
      print *,' j=',j
      alfa=(y(j+1)-y(j-1))/(x(j+1)-x(j-1))
      zavit=10.*alfa
      print *,' alfa=',alfa,'  zavit=',zavit
      call relocate (x(j),y(j)+0.1)
      call setangle(zavit)
      call setexpand(0.35)
      call label (7,timlabel)
      call setexpand(1.)
      call setangle(0.)
      goto  15
900   continue
      if (screen.eq.0)then
                      trash=fileplot(0)
                      else
                      call tidle
      end if 
      stop 'well end'
      end 
      subroutine  pfname(name1,name2,lng)
      implicit real*8(a-h,o-z)
      character*(*) name1
      character*10  name2
      locmx=len(name1)
      locmx=min(locmx,10)
      name2(1:10)=name1(1:10)
      loc0=0
 1    continue
      loc=index(name2,' ')
      if(loc.eq.loc0)  goto  10
      do  5  l=loc+1,locmx
      name2(l-1:l-1)=name2(l:l)
 5    continue
      loc0=loc
      goto  1
 10   continue
      lng=loc-1
      return
      end
      function datef()
      character*80  command
      character*50  filename
      character*28  fulldate
      character*28  datef
      nunit=91
      filename='.date'
      command='date > '//filename
      call system(command)
      open(unit=nunit,file=filename,status='unknown')
      read (nunit,901) fulldate
 901  format(a)
      close(unit=nunit)
      datef=fulldate
      return
      end
      function user()
      character*80  command
      character*50  filename
      character*10  user
      nunit=91
      filename='.user'
      command='echo $user > '//filename
      call system(command)
      open(unit=nunit,file=filename,status='unknown')
      read (nunit,'(a)') user
      close(unit=nunit)
      return
      end

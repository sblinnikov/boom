      subroutine getargu(n,argu)
c     getargu yields in argu tne n'th argument (following the prog.name)
c
c     on H-P mashines arguments 1=calling prog.name 2=first arg. etc.
c     on Dec mashines arguments 0=calling prog.name 1=first arg. etc.
c     this is an Dec case
c     getargu yields in argu tne n'th argument (following the prog.name)
      character argu*(*)
      call getarg(n,argu)
c      write(*,*)' getargu.f n,argu:',n,argu ! used to debug -F compiler option be seb 02.11.2009
c      pause
      return
      end


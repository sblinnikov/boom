      subroutine numargu(lastarg)
c     on H-P mashines arguments 1=prog.name 2=first arg. ... n+1=last arg.
c     on Dec mashines arguments 0=prog.name 1=first arg. ...   n=last arg.
c     this is an Dec case getting the number of arguments following the
c                         prog.name
      lastarg=iargc()
      return
      end

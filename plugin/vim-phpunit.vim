" root of unit tests
if !exists('g:phpunit_testroot')
  let g:phpunit_testroot = 'tests'
endif
if !exists('g:phpunit_srcroot')
  let g:phpunit_srcroot = 'src'
endif

fun! g:PHPUnit.SwitchFile()
  let file = expand('%')
  let cmd = ''
  let isTest = expand('%:t') =~ "Test\.php$"

  if isTest
    " replace phpunit_testroot with libroot

    if file[0:len(g:phpunit_testroot)-1] ==# g:phpunit_testroot
      let file = substitute(file,''.g:phpunit_testroot.'/', '' . g:phpunit_srcroot . '/', '')
    else 
      let file = substitute(file,'/'.g:phpunit_testroot.'/', '/' . g:phpunit_srcroot . '/', '')
    endif

    " remove 'Test.' from filename
    let file = substitute(file,'Test\.php$','.php','')
    let cmd = 'abo '
  else
    let file = expand('%:r')
    
    if file[0:len(g:phpunit_srcroot)-1] ==# g:phpunit_srcroot
      let file = substitute(file,''.g:phpunit_srcroot.'/', '' . g:phpunit_testroot . '/', '')
    else 
      let file = substitute(file,'/'.g:phpunit_srcroot.'/', '/' . g:phpunit_testroot . '/', '')
    endif

    let file = file . 'Test.php'

    let cmd = 'bel '
  endif
  " exec 'tabe ' . f 

  " is there window with complent file open?
  let win = bufwinnr(file)
  if win > 0
    execute win . "wincmd w"
  else
    execute cmd . "vsplit " . file
    let dir = expand('%:h')
    if ! isdirectory(dir) 
      cal mkdir(dir,'p')
    endif
  endif
endf

command! -nargs=0 PHPUnitSwitchFile :call g:PHPUnit.SwitchFile()


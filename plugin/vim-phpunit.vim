" root of unit tests
if !exists('g:phpunit_testroot')
  let g:phpunit_testroot = 'tests'
endif
if !exists('g:phpunit_srcroot')
  let g:phpunit_srcroot = 'src'
endif

if !exists('g:php_bin')
  let g:php_bin = ''
endif

if !exists('g:phpunit_bin')
  let g:phpunit_bin = 'phpunit'
endif

if !exists('g:phpunit_use_bridge')
  let g:phpunit_use_bridge = '1'
endif

if !exists('g:phpunit_options')
  let g:phpunit_options = ['--stop-on-failure', '--columns=50'] 
endif

if !exists('g:phpunit_pos')
  let g:phpunit_pos = "quickui"
endif


" you can set there subset of tests if you do not want to run
" full set
if !exists('g:phpunit_tests')
  let g:phpunit_tests = g:phpunit_testroot
endif


let g:PHPUnit = {}

fun! g:PHPUnit.buildBaseCommand()
  let cmd = []
  if g:phpunit_use_bridge == "1"
    call add(cmd, 'SYMFONY_DEPRECATIONS_HELPER=verbose=0')
  endif

  if g:php_bin != ""
    call add(cmd, g:php_bin)
  endif
  call add(cmd, g:phpunit_bin)
  call add(cmd, join(g:phpunit_options, " "))
  return cmd
endfun

fun! g:PHPUnit.Run(cmd, title)
  redraw
  echohl Title
  echomsg "* Running PHP Unit test(s) [" . a:title . "] *"
  echohl None
  redraw
  echomsg "* Done PHP Unit test(s) [" . a:title . "] *"
  echohl None

  let command = join(a:cmd, " ")
  call asyncrun#run("!", { "mode": "term", "pos": g:phpunit_pos, "focus": 0, }, command)  
endfun

fun! g:PHPUnit.SwitchMode()
  if g:phpunit_pos == "bottom"
    let g:phpunit_pos = "quickui"
  else 
    let g:phpunit_pos = "bottom"
  endif 
endfun

" Returns the directory of the first file in `argv` or `cwd` if it's empty
fun! g:PHPUnit.FindSessionDirectory() abort
  if len(argv()) > 0
    return fnamemodify(argv()[0], ':p:h')
  endif
  return getcwd()
endfun


fun! g:PHPUnit.RunAll()
  let cmd = g:PHPUnit.buildBaseCommand()
  let cmd = cmd + [expand(g:phpunit_testroot)]
 
  silent call g:PHPUnit.Run(cmd, "RunAll") 
endfun

fun! g:PHPUnit.RunCurrentFile()
  let cmd = g:PHPUnit.buildBaseCommand()
  let cmd = cmd +  [bufname("%")]
  silent call g:PHPUnit.Run(cmd, bufname("%")) 
endfun
fun! g:PHPUnit.RunTestCase(filter)
  let cmd = g:PHPUnit.buildBaseCommand()
  let cmd = cmd + ["--filter", a:filter , bufname("%")]
  silent call g:PHPUnit.Run(cmd, bufname("%") . ":" . a:filter) 
endfun
fun! g:PHPUnit.RunCurrentMethod()

  let method = tagbar#currenttag('%s', '', 'f')
  let isTestMethod = method != ''
  if isTestMethod
    let testMethod = substitute(method, '.*\zs\\\\', "::", "")
    let testMethod = substitute(testMethod, '.*\zs(.*)', "", "")
     
    let cmd = g:PHPUnit.buildBaseCommand()
    let cmd = cmd + ["--filter", "'" . testMethod . "'"]
    silent call g:PHPUnit.Run(cmd, bufname("%"))
  endif
endfun
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

command! -nargs=0 PHPUnitRunAll :call g:PHPUnit.RunAll()
command! -nargs=0 PHPUnitRunCurrentFile :call g:PHPUnit.RunCurrentFile()
command! -nargs=1 PHPUnitRunFilter :call g:PHPUnit.RunTestCase(<f-args>)
command! -nargs=0 PHPUnitSwitchFile :call g:PHPUnit.SwitchFile()
command! -nargs=0 PHPUnitRunCurrentMethod :call g:PHPUnit.RunCurrentMethod() 
command! -nargs=0 PHPUnitSwitchMode :call g:PHPUnit.SwitchMode() 

nnoremap <Leader>ta :PHPUnitRunAll<CR>
nnoremap <Leader>tf :PHPUnitRunCurrentFile<CR>
nnoremap <Leader>ts :PHPUnitSwitchFile<CR>
nnoremap <Leader>tm :PHPUnitRunCurrentMethod<CR>
nnoremap <Leader>tc :PHPUnitSwitchMode<CR>

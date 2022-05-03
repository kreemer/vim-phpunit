# vim-phpunit


vim-phpunit is a plugin for vim that allows you to switch between the test and src file easily.


## Install via Bundle

```vim
Plug "kreemer/vim-phpunit"
```


## Dependencies

* [vim-test](https://github.com/vim-test/vim-test) for easier running the tests 

## Configurations

```vim
" the directory that contains your phpunit test cases.
let g:phpunit_testroot = 'tests'
```

```vim
" the directory that contains source files
let g:phpunit_srcroot = 'src'
```

## Commands

- `PHPUnitSwitchFile` - Switch file 

## License

MIT License

## Credits

* [vim-php/vim-phpunit](https://github.com/vim-php/vim-phpunit)
* [joonty/vim-phpunitqf](https://github.com/joonty/vim-phpunitqf)
* [c9s/phpunit.vim](https://github.com/c9s/phpunit.vim)

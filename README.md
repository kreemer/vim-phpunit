# vim-phpunit


vim-phpunit is a plugin for Vim that allows you to run PHPUnit tests easily from theVim windows.


## Install via Bundle

```vim
Plug "kreemer/vim-phpunit"
```


## Dependencies

* [Tagbar](https://preservim.github.io/tagbar/)
* [skywind3000/vim-quickui](https://github.com/skywind3000/vim-quickui) (Optional) 


## Configurations


```vim
" the directory that contains your phpunit test cases.
let g:phpunit_testroot = 'tests'
```

```vim
" the directory that contains source files
let g:phpunit_srcroot = 'src'
```

```vim
" the location of your phpunit file.
let g:phpunit_bin = 'phpunit'
```

```vim
" php unit command line options
let g:phpunit_options = ["--stop-on-failure"]
```

```vim
" php unit output bosition, valid options are: bottom, quickui
let g:phpunit_pos = 'quickui' 
```

## Key Mappings

- `<leader>ta` - Run all test cases
- `<leader>ts` - Switch between source & test file
- `<leader>tf` - Run current test case class
- `<leader>tc` - Run current method
- `<leader>tm` - Switch output between `quickui` and `bottom`

## Notice

Since vim doesn't support pipe output to a buffer, this plugin only renders the content to buffer when the command completed.

## License

MIT License

## Credits

* [vim-php/vim-phpunit](https://github.com/vim-php/vim-phpunit)
* [joonty/vim-phpunitqf](https://github.com/joonty/vim-phpunitqf)
* [c9s/phpunit.vim](https://github.com/c9s/phpunit.vim)

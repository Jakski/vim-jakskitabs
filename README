# vim-jakskitabs

Vim tabnames manager.

## Usage

Add the following to Vim configuration:

```
set tabline=%!JakskiTabs_line()
set sessionoptions+=tabpages,globals
```

Changing `sessionoptions` enables persisting tabnames across Vim sessions. It's
also recommended to bind `JakskiTabs_set_name` to some key for fast name
changing, e.g.:

```
nnoremap <F3> :call JakskiTabs_set_name()<CR>
```

vim-jakskitabs binds tabname to current working directory path. Names will be
duplicated, if you have 2 tabs opened on the same directory.

" Vim JakskiTabs plugin for tab names managment
" Author: Jakub Pieńkowski <jakub@jakski.name>
" Home: https://github.com/Jakski/vim-jakskitabs
" License: MIT

if exists("g:loaded_jakskitabs")
    finish
endif

let g:loaded_jakskitabs = 1

let s:save_cpo = &cpo
set cpo&vim

func! s:parse_tab_string() abort
	return map(split(g:JakskiTabs_tabnames, '\n'), "split(v:val, '\t')")
endfunc

func! s:save_tabs(tabnames) abort
	let tabnames = ''
	for [checksum, name] in items(a:tabnames)
		let tabnames .= checksum . "\t" . name . "\n"
	endfor
	let g:JakskiTabs_tabnames = tabnames
endfunc

func! JakskiTabs_load() abort
	let tabnames = {}
	for [checksum, name] in s:parse_tab_string()
		let tabnames[checksum] = name
	endfor
	let s:tabnames = tabnames
endfunc

func! JakskiTabs_set_name() abort
	let tabname = input('Enter tabname: ')
	if tabname =~ '\t'
		echoerr "Tabname can't contain tabs" 
	elseif !empty(tabname)
		let s:tabnames[sha256(getcwd(-1))[:15]] = tabname
		call s:save_tabs(s:tabnames)
	endif
	set showtabline=1
endfunc

func! JakskiTabs_line() abort
	let s = ''
	for i in range(tabpagenr('$'))
		let i += 1
		if i == tabpagenr()
			let s .= '%#TabLineSel#'
		else
			let s .= '%#TabLine#'
		endif
		let s .= ' ' . i . ' '
		let dir_checksum = sha256(getcwd(-1, i))[:15]
		if !empty(get(s:tabnames, dir_checksum, ''))
			let s .= s:tabnames[dir_checksum] . ' '
		endif
	endfor
	" after the last tab fill with TabLineFill and reset tab page nr
	let s .= '%#TabLineFill#%T'
	" right-align the label to close the current tab page
	if tabpagenr('$') > 1
		let s .= '%=%#TabLine#%999XX'
	endif
	return s
endfunc

if !exists('g:Jakskitabs_tabnames')
	let g:JakskiTabs_tabnames = ''
endif
call JakskiTabs_load()

autocmd SessionLoadPost * :call JakskiTabs_load()

let &cpo = s:save_cpo
unlet s:save_cpo

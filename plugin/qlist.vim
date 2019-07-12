" qlist.vim - Persist the result of :ilist and related commands via the quickfix list.
" Maintainer:	romainl <romainlafourcade@gmail.com>
" Version:	0.0.3
" License:	MIT
" Location:	plugin/qlist.vim
" Website:	https://github.com/romainl/vim-qlist

if exists("g:loaded_qlist") || v:version < 703 || &compatible
  finish
endif
let g:loaded_qlist = 1

let s:save_cpo = &cpo
set cpo&vim

" Add the :Ilist command.
command! -nargs=1 -bar -bang Ilist call qlist#Qlist("i", 1, 0, '<bang>' == '!', <f-args>)

" Add the :Dlist command.
command! -nargs=1 -bar -bang Dlist call qlist#Qlist("d", 1, 0, '<bang>' == '!', <f-args>)

" Internal mappings
" Override the built-in [I and ]I.
nnoremap <silent> <Plug>QlistIncludefromtop        :call qlist#Qlist("i", 0, 0, 0)<CR>
xnoremap <silent> <Plug>QlistIncludefromtopvisual  :<C-u>call qlist#Qlist("i", 1, 0, 0)<CR>

nnoremap <silent> <Plug>QlistIncludefromhere       :call qlist#Qlist("i", 0, 1, 0)<CR>
xnoremap <silent> <Plug>QlistIncludefromherevisual :<C-u>call qlist#Qlist("i", 1, 1, 0)<CR>

" Override the built-in [D and ]D.
nnoremap <silent> <Plug>QlistDefinefromtop         :call qlist#Qlist("d", 0, 0, 0)<CR>
xnoremap <silent> <Plug>QlistDefinefromtopvisual   :<C-u>call qlist#Qlist("d", 1, 0, 0)<CR>

nnoremap <silent> <Plug>QlistDefinefromhere        :call qlist#Qlist("d", 0, 1, 0)<CR>
xnoremap <silent> <Plug>QlistDefinefromherevisual  :<C-u>call qlist#Qlist("d", 1, 1, 0)<CR>

" Default, user-configurable, mappings
if !hasmapto('<Plug>QlistIncludefromtop')
    nmap <silent> [I <Plug>QlistIncludefromtop
endif

if !hasmapto('<Plug>QlistIncludefromtopvisual')
    xmap <silent> [I <Plug>QlistIncludefromtopvisual
endif

if !hasmapto('<Plug>QlistIncludefromhere')
    nmap <silent> ]I <Plug>QlistIncludefromhere
endif

if !hasmapto('<Plug>QlistIncludefromherevisual')
    xmap <silent> ]I <Plug>QlistIncludefromherevisual
endif

if !hasmapto('<Plug>QlistDefinefromtop')
    nmap <silent> [D <Plug>QlistDefinefromtop
endif

if !hasmapto('<Plug>QlistDefinefromtopvisual')
    xmap <silent> [D <Plug>QlistDefinefromtopvisual
endif

if !hasmapto('<Plug>QlistDefinefromhere')
    nmap <silent> ]D <Plug>QlistDefinefromhere
endif

if !hasmapto('<Plug>QlistDefinefromherevisual')
    xmap <silent> ]D <Plug>QlistDefinefromherevisual
endif

let &cpo = s:save_cpo

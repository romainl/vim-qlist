" qlist.vim - Persist the result of :ilist and related commands via the quickfix list.
" Maintainer:	romainl <romainlafourcade@gmail.com>
" Version:	0.0.1
" License:	Vim License (see :help license)
" Location:	plugin/qlist.vim
" Website:	https://github.com/romainl/vim-qlist

if exists("g:loaded_qlist") || v:version < 703 || &compatible
  finish
endif
let g:loaded_qlist = 1

let s:save_cpo = &cpo
set cpo&vim

function! s:Qlist(command, selection, start_at_cursor, ...)
    " Derive the commands used below from the first argument.
    let excmd   = a:command . "list"
    let normcmd = toupper(a:command)

    " If we are operating on a visual selection, redirect the output of '[I', ']I', '[D' or ']D'.
    " If we don't, redirect the output of ':ilist /argument' or ':dlist /argument'.
    let output  = ""
    if a:selection
        if a:0 > 0 && len(a:1) > 0
            let search_pattern = a:1
        else
            let old_reg = @v
            normal! gv"vy
            let search_pattern = substitute(escape(@v, '\/.*$^~[]'), '\\n', '\\n', 'g')
            let @v = old_reg
        endif
        redir => output
        silent! execute (a:start_at_cursor ? '+,$' : '') . excmd . ' /' . search_pattern
        redir END
        let feedback = excmd . ' /' . search_pattern
    else
        redir => output
        silent! execute 'normal! ' . (a:start_at_cursor ? ']' : '[') . normcmd
        redir END
        let feedback = (a:start_at_cursor ? ']' : '[') . normcmd
    endif

    " Clean up the output.
    let lines = split(output, '\n')

    " Bail out on errors.
    if lines[0] =~ '^Error detected'
        echomsg 'Could not find "' . (a:selection ? search_pattern : expand("<cword>")) . '".'
        return
    endif

    " Our results may span multiple files so we need to build a relatively complex list based on filenames.
    let filename   = ""
    let qf_entries = []
    for line in lines
        if line !~ '^\s*\d\+:'
            let filename = fnamemodify(line, ':p:.')
        else
            let lnum = split(line)[1]
            let text = substitute(line, '^\s*.\{-}:\s*\S\{-}\s', "", "")
            let col  = match(text, a:selection ? search_pattern : expand("<cword>")) + 1
            call add(qf_entries, {"filename" : filename, "lnum" : lnum, "col" : col, "vcol" : 1, "text" : text})
        endif
    endfor

    " Build the quickfix list from our results.
    call setqflist(qf_entries)

    " Open the quickfix window if there is something to show.
    cclose
    cwindow

    " Add proper feedback to the statusline.
    let w:quickfix_title = feedback
endfunction

" Add the :Ilist command.
command! -nargs=1 -bar Ilist call <sid>Qlist("i", 1, 0, <f-args>)

" Add the :Dlist command.
command! -nargs=1 -bar Dlist call <sid>Qlist("d", 1, 0, <f-args>)

" Internal mappings
" Override the built-in [I and ]I.
nnoremap <silent> <Plug>QlistIncludefromtop        :call <sid>Qlist("i", 0, 0)<CR>
xnoremap <silent> <Plug>QlistIncludefromtopvisual  :<C-u>call <sid>Qlist("i", 1, 0)<CR>

nnoremap <silent> <Plug>QlistIncludefromhere       :call <sid>Qlist("i", 0, 1)<CR>
xnoremap <silent> <Plug>QlistIncludefromherevisual :<C-u>call <sid>Qlist("i", 1, 1)<CR>

" Override the built-in [D and ]D.
nnoremap <silent> <Plug>QlistDefinefromtop         :call <sid>Qlist("d", 0, 0)<CR>
xnoremap <silent> <Plug>QlistDefinefromtopvisual   :<C-u>call <sid>Qlist("d", 1, 0)<CR>

nnoremap <silent> <Plug>QlistDefinefromhere        :call <sid>Qlist("d", 0, 1)<CR>
xnoremap <silent> <Plug>QlistDefinefromherevisual  :<C-u>call <sid>Qlist("d", 1, 1)<CR>

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

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

function! Qlist(command, selection, start_at_cursor, ...)
    " Derive the commands used below from the first argument.
    let excmd   = a:command . "list"
    let normcmd = toupper(a:command)

    " If we are operating on a visual selection, redirect the output of '[I', ']I', '[D' or ']D'.
    " If we don't, redirect the output of ':ilist argument' or ':dlist argument'.
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
    else
        redir => output
        silent! execute 'normal! ' . (a:start_at_cursor ? ']' : '[') . normcmd
        redir END
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
    cwindow
endfunction

" Override the built-in [I and ]I.
nnoremap <silent> [I :call Qlist("i", 0, 0)<CR>
nnoremap <silent> ]I :call Qlist("i", 0, 1)<CR>
" Add [I and ]I for visual mode.
xnoremap <silent> [I :<C-u>call Qlist("i", 1, 0)<CR>
xnoremap <silent> ]I :<C-u>call Qlist("i", 1, 1)<CR>
" Add the :Ilist command.
command! -nargs=1 -bar Ilist call Qlist("i", 1, 0, <f-args>)

" Override the built-in [D and ]D.
nnoremap <silent> [D :call Qlist("d", 0, 0)<CR>
nnoremap <silent> ]D :call Qlist("d", 0, 1)<CR>
" Add [D and ]D for visual mode.
xnoremap <silent> [D :<C-u>call Qlist("d", 1, 0)<CR>
xnoremap <silent> ]D :<C-u>call Qlist("d", 1, 1)<CR>
" Add the :Dlist command.
command! -nargs=1 -bar Dlist call Qlist("d", 1, 0, <f-args>)

let &cpo = s:save_cpo

" qlist.vim - Persist the result of :ilist and related commands via the quickfix list.
" Maintainer:	romainl <romainlafourcade@gmail.com>
" Version:	0.0.3
" License:	MIT
" Location:	autoload/qlist.vim
" Website:	https://github.com/romainl/vim-qlist

let s:save_cpo = &cpo
set cpo&vim

function! qlist#Qlist(command, selection, start_at_cursor, force, ...)
    " Derive the commands used below from the first argument.
    if a:force == 1
        let excmd = a:command . "list!"
    else
        let excmd = a:command . "list"
    endif
    let normcmd = toupper(a:command)

    " If we are operating on a visual selection, redirect the output of '[I', ']I', '[D' or ']D'.
    " If we don't, redirect the output of ':ilist /argument' or ':dlist /argument'.
    let output  = ""
    if a:selection
        if a:0 > 0 && len(a:1) > 0
            let search_pattern = a:1
        else
            let old_reg = getreg("v")
            normal! gv"vy
            let raw_search = getreg("v")
            let search_pattern = substitute(escape(raw_search, '\/.*$^~[]'), '\\n', '\\n', 'g')
            call setreg("v", old_reg)
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
    if (len(lines) == 3) && ((normcmd is# 'D' && lines[2] =~# '^E388:') || normcmd is# 'I' && (lines[2] =~# '^E389:'))
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
    if exists("g:loaded_qf")
        doautocmd QuickFixCmdPost cwindow
    else
        cclose
        execute min([ 10, len(getqflist()) ]) 'cwindow'
    endif

    " Add proper feedback to the statusline.
    if has("patch-7.4.2200")
        call setqflist([], 'r', {'title': feedback})
    else
        let w:quickfix_title = feedback
    endif
endfunction

let &cpo = s:save_cpo

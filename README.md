# vim-qlist

Vim-qlist is an updated, more powerful, version of the function discussed in [this /r/vim thread](http://www.reddit.com/r/vim/comments/1rzvsm/do_any_of_you_redirect_results_of_i_to_the/).

The purpose of this script is to make the results of "include-search" and "definition-search" easier to navigate and more persistant by using the quickfix list instead of the default list-like interface.

![screenshot](http://romainl.github.io/vim-qlist/images/qlist.png)

## Installation

Use your favorite plugin manager or dump `qlist.vim` in your `plugin` directory:

    # Unix-like systems
    ~/.vim/plugin/qlist.vim

    # Windows
    %userprofile%\vimfiles\plugin\qlist.vim

## Usage

This plugin adds two custom commands to your configuration, `:Ilist` and `:Dlist`, overrides these four normal mode commands: `[I`, `]I`, `[D`, `]D` and adds their visual mode counterparts.

Those commands still behave like the originals and share the same requirements. There are two differences, though:

* The first difference is the whole point of this humble plugin: instead of displaying the results as a non-interactive list, we use the quickfix list. The benefits are huge...

  * the results can be displayed in an interactive window where you can search and move around with regular Vim commands,
  * the results are still accessible even if the quickfix window is closed,
  * older searches can be re-called if needed.

* The second difference is minimal but worth noting...

  * `:Ilist foo` works like `:ilist /foo`,
  * `:Dlist bar` works like `:dlist /bar`.

The `/` forces vim to perform regular expression search instead of the default whole word search. This is actually a built-in feature that happens to be quite handy for quick searches:

    :ilist foo    " only finds exact word 'foo'
    :ilist /foo   " finds all words containing 'foo'

Here are explanations of all the commands:

    [I            " List every occurence of the word under the cursor
                  " in the current buffer and included files.
                  " Comments are skipped.
                  " Search starts from the top.

    ]I            " List every occurence of the word under the cursor
                  " in the current buffer and included files.
                  " Comments are skipped.
                  " Search starts after the current position.

    :Ilist foo    " List every word containing 'foo' in the current
                  " buffer and included files.
                  " Comments are skipped.
                  " Search starts from the top.

    [D            " List every definition of the symbol under the cursor
                  " in the current buffer and included files.
                  " Search starts from the top.

    ]D            " List every definition of the symbol under the cursor
                  " in the current buffer and included files.
                  " Search starts after the current position.

    :Dlist foo    " List every definition containing 'foo' in the current
                  " buffer and included files.
                  " Search starts from the top.

For more information, please read `:help include-search`.

## Configuration

If you don't want to override `[I`, `]D` and friends, you can still map each command to whatever works for you. Below are the default mappings that you can use as a basis for your own configuration:

    " normal mode
    nmap <silent> [I <Plug>QlistIncludefromtop
    nmap <silent> ]I <Plug>QlistIncludefromhere
    nmap <silent> [D <Plug>QlistDefinefromtop
    nmap <silent> ]D <Plug>QlistDefinefromhere

    " visual mode
    xmap <silent> [I <Plug>QlistIncludefromtopvisual
    xmap <silent> ]I <Plug>QlistIncludefromherevisual
    xmap <silent> [D <Plug>QlistDefinefromtopvisual
    xmap <silent> ]D <Plug>QlistDefinefromherevisual

`:help quickfix` is a recommended read if you are unfamiliar with the quickfix feature.

## TODO

* Add proper documentation.
* Add options?

## DONE

* Add a gifcast to the `README`. (sort of)

# vim-qlist

Vim-qlist is an updated, more powerful, version of the function discussed in [this /r/vim thread](http://www.reddit.com/r/vim/comments/1rzvsm/do_any_of_you_redirect_results_of_i_to_the/).

The purpose of this script is to make the results of "include-search" easier to navigate and more persistant by using the quickfix window instead of the default list-like interface.

## Installation

Use your favorite plugin manager or dump `qlist.vim` in your `plugin` directory:

    # Unix-like systems
    ~/.vim/plugin/qlist.vim

    # Windows
    %userprofile%\vimfiles\plugin\qlist.vim

## Why this plugin

This plugin adds two custom commands to your configuration, `:Ilist` and `:Dlist` and overrides these four normal mode commands: `[I`, `]I`, `[D`, `]D`.

Those commands still behave like the originals, minus two differences.

* The first difference is the whole point of this humble plugin: instead of displaying the search results as a non-interactive list, we use the quickfix window. The benefits are huge...

  * the results are displayed in an interactive window where you can search and move around with regular Vim commands,
  * the results are still accessible even if the quickfix window is closed,
  * older results can be re-called if needed.

* The second difference is minimal but worth noting...

  * `:Ilist foo` works like `:ilist /foo`,
  * `:Dlist bar` works like `:dlist /bar`.

## Usage

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

## Possible developments

* Add proper documentation.
* Add a gifcast to the `README`.
* Add options.

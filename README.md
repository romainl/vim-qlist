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

Don't forget to execute the following command to make the documentation
globally available:

on Unix-like systems...

    :helptags ~/.vim/doc

on Windows...

    :helptags %userprofile%\vimfiles\doc

## TODO

* Add options?

## DONE

* Add a gifcast to the `README`. (sort of)
* Add proper documentation.

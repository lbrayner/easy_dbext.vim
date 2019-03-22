function! DBextPostResult(db_type, buf_nr)
    " removing an undesirable mapping
    nunmap <buffer> q
    if a:db_type ==# "MYSQL"
        if b:dbext_extra =~# "vvv"
            syn region ResultFold start="^--------------$" end="^--------------$"
                        \ keepend transparent fold
            syn sync fromstart
            setlocal foldmethod=syntax
            normal! 2j
        endif
    endif
    setlocal nomodifiable
    setlocal nomodified
endfunction

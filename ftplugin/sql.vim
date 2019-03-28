" Mappings exclusive to sql buffers

inoremap <buffer> <f1> <c-o>:h easy_dbext.txt<cr>

inoremap <buffer> <silent> <Esc><Esc> <c-o>:only<CR>
inoremap <buffer> <silent> <f5> <c-o>:e<cr>

" match

autocmd BufEnter <buffer> match TrailingSpaces /^\s\+$/
autocmd BufLeave <buffer> match

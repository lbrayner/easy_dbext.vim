if exists("g:easy_dbext_disable") && g:easy_dbext_disable
    finish
endif

if !&insertmode || !has("gui_running")
    finish
endif

" highlight groups

highlight TrailingSpaces guibg=#ff0000

" dbext

" - Whether to use separate result buffers for each file
let g:dbext_default_use_sep_result_buffer = 1

" If you define a function, DBextPostResult, in your .vimrc (or elsewhere)
" it will be called automatically each time the Result buffer is updated.
function! DBextPostResult(db_type, buf_nr)
    if a:db_type ==# "MYSQL"
        if b:dbext_extra =~# "vvv"
            syn region ResultFold start="^--------------$" end="^--------------$"
                        \ keepend transparent fold
            syn sync fromstart
            setlocal foldmethod=syntax
            normal! 2j
        endif
    endif
    setlocal readonly
    setlocal nomodifiable
    setlocal nomodified
endfunction

function! s:PreserveViewPort(command)
    let winview = winsaveview()
    if type(a:command) == type(function("tr"))
        call a:command()
    else
        exe command
    endif
    call winrestview(winview)
endfunction

" Select paragraph

function! s:Do_SQL_SelectParagraph()
    exe "normal! vip:\<c-u>call dbext#DB_execSql(DB_getVisualBlock())\<cr>"
endfunction

function! s:SQL_SelectParagraph()
    call s:PreserveViewPort(funcref("<SID>Do_SQL_SelectParagraph"))
endfunction

" Describe table

function! s:Do_SQL_DescribeTable()
    exe "normal! :\<c-u>call dbext#DB_describeTable()\<cr>"
endfunction

function! s:SQL_DescribeTable()
    call s:PreserveViewPort(funcref("<SID>Do_SQL_DescribeTable"))
endfunction

" ToggleSizeOrOpenResults

let s:toggle_window_size = 0
let s:result_window_small_size = 10

function! s:ToggleSizeOrOpenResults()
    let last_winnr = winnr()
    call dbext#DB_openResults()

    " dbext code sets modified
    setlocal readonly
    setlocal nomodifiable
    setlocal nomodified

    let current_winnr = winnr()
    if last_winnr != current_winnr
        return
    endif
    if s:toggle_window_size == 0
        exe "res " . (&lines - 20)
    endif
    if s:toggle_window_size == 1
        exe "res " . s:result_window_small_size
    endif
    let s:toggle_window_size = (s:toggle_window_size+1)%2
endfunction

function! s:ResultsClose()
    if dbext#DB_isResultBufferVisible()
        call dbext#DB_openResults()
        quit
    endif
endfunction

" Mappings

inoremap <silent> <c-kMinus> <c-o>:res-5<cr>
inoremap <silent> <c-kPlus> <c-o>:res+5<cr>

inoremap <silent> <c-return> <c-o>:call <SID>SQL_SelectParagraph()<cr>
inoremap <silent> <S-return> <c-o>:call <SID>SQL_DescribeTable()<cr>

inoremap <f8> <c-o>:setlocal wrap! wrap?<CR>
inoremap <silent> <c-f9> <c-o><c-w>=
inoremap <silent> <f9> <c-o>:call <SID>ToggleSizeOrOpenResults()<cr>
inoremap <silent> <f10> <c-o>:call <SID>ResultsClose()<cr>

" after/ftplugin/scss.vim

call dko#TwoSpace()

" see after/ftplugin/css.vim
setlocal iskeyword+=-

"let b:current_syntax = 'scss'

let s:match_done = '<CR>:nohlsearch<CR>'
let s:matches = '\(#\|\.\|@\|\h\|&:\).\+\s*{'
execute 'nmap <silent><buffer> [[ ?' . escape(s:matches, '|?') . s:match_done
execute 'omap <silent><buffer> [[ ?' . escape(s:matches, '|?') . s:match_done
execute 'nmap <silent><buffer> ]] /' . escape(s:matches, '|') . s:match_done
execute 'omap <silent><buffer> ]] /' . escape(s:matches, '|') . s:match_done

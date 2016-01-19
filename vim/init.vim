" neovim init

let g:dko_nvim_dir = fnamemodify(resolve(expand("$MYVIMRC")), ":p:h")

" disable python2
let g:loaded_python_provider = 1

" set python3
let g:python3_host_prog = '/usr/local/bin/python3'

try
  " Neovim-qt Guifont command
  command -nargs=? Guifont call rpcnotify(0, 'Gui', 'SetFont', "<args>") | let g:Guifont="<args>"
  " Set the font to DejaVu Sans Mono:h13
  Guifont Fira Mono For Powerline:h8
endtry

execute 'source ' . g:dko_nvim_dir . '/vimrc'

if has('gui_running')
  set lines=60 columns=180              " 2 panes wide
  "execute 'source ' . g:dko_nvim_dir . '/gvimrc'
endif


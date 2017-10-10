" plugin/plug-neomake.vim
scriptencoding utf-8

if !dkoplug#plugins#IsLoaded('neomake') | finish | endif

" @param  {String} name of maker
" @param  {String} [a:1] ft of the maker, defaults to current buffers filetype
" @return {Boolean} true when the maker exe exists or was registered as a local
"         maker (so local exe exists)
function! dkoproject#neomake#IsMakerExecutable(name, ...) abort
  let l:ft = get(a:, 1, &filetype)
  if empty(l:ft) | return 0 | endif

  " dkoproject#neomake#LocalMaker successfully determined a project-local
  " bin was executable, return that instead
  if exists('b:neomake_' . l:ft . '_' . a:name . '_exe')
    return executable(b:neomake_{l:ft}_{a:name}_exe)
  endif

  " Use the default exe from maker definition
  let l:maker = neomake#GetMaker(a:name, l:ft)
  return !empty(l:maker) && executable(l:maker.exe)
endfunction

" ============================================================================
" Define makers
" This should run for EVERY buffer, even though it may be slow. This way
" mono-repos may use different makers when in different dirs.
" ============================================================================

" For using local npm based makers (e.g. eslint):
" Resolve the maker's exe relative to the project of the file in buffer, as
" opposed to using the result of `system('npm bin')` since that executes
" relative to vim's working path (and gives a fake result of not in a node
" project). Lotta people doin` it wrong ಠ_ಠ

" @param {dict} settings
" @param {string} [settings.exe] alternate exe path to use in the buffer
" @param {string} settings.ft filetype for the maker
" @param {Boolean} [settings.is_enabled] default true, auto-enable when defined
" @param {string} settings.maker name
" @param {string} [settings.when] eval()'d, add local maker only if true
function! dkoproject#neomake#LocalMaker(settings) abort
  " We eval this so it runs with the buffer context
  if has_key(a:settings, 'when') && !eval(a:settings['when']) | return | endif

  " Override maker's exe for this buffer?
  let l:exe = dkoproject#GetBin(get(a:settings, 'exe', ''))
  if !empty(l:exe)
    let b:neomake_{a:settings['ft']}_{a:settings['maker']}_exe = l:exe
  endif

  " Automatically enable the maker for this buffer?
  let l:is_enabled = get(a:settings, 'is_enabled', 1)
  let l:is_executable = !empty(l:exe)
        \ || dkoproject#neomake#IsMakerExecutable(a:settings['maker'], a:settings['ft'])

  if l:is_enabled && l:is_executable
    call add(
          \ dko#InitList('b:neomake_' . a:settings['ft'] . '_enabled_makers'),
          \ a:settings['maker'])
  endif
endfunction

function! dkoproject#neomake#MaybeRun() abort
  if dko#IsNonFile('%') || dko#IsHelp('%') | return | endif
  " File was never written
  if empty(glob(expand('%'))) | return | endif
  Neomake
endfunction

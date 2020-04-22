" ==============================================================
" Description:  Project specific settings
" Author:       Alexander Skachko <alexander.skachko@gmail.com>
" Homepage:     https://github.com/lucerion/vim-project-settings
" Version:      0.0.1 (2019-07-31)
" Licence:      BSD-3-Clause
" ==============================================================

if exists('g:loaded_project_settings') || &compatible || v:version < 700
  finish
endif
let g:loaded_project_settings = 1

if !exists('g:project_settings')
  let g:project_settings = {}
endif

if !exists('g:project_settings_file')
  let g:project_settings_file = '.settings.vim'
endif

autocmd! VimEnter,BufNewFile,BufRead * call s:apply_project_settings()

func s:apply_project_settings() abort
  " TODO: find recursively from current directory to project root
  call s:apply_file_with_settings('./' . g:project_settings_file)

  if empty(g:project_settings)
    return
  endif

  for [l:project_path, l:project_settings] in items(g:project_settings)
    if empty(l:project_settings)
      return
    endif

    let l:project_path = expand(l:project_path)
    let l:current_path = expand('%:p:h')

    if isdirectory(l:project_path) && l:current_path =~ l:project_path
      let l:settings = get(l:project_settings, 'settings')
      if !empty(l:settings)
        call s:apply_settings(l:settings)
      endif

      let l:file = get(l:project_settings, 'file')
      if !empty(l:file)
        call s:apply_file_with_settings(l:file)
      endif
    endif
  endfor
endfunc

func! s:apply_settings(settings) abort
  for [l:setting, l:value] in items(a:settings)
    silent exec 'setl ' . l:setting . '=' . l:value
  endfor
endfunc

func! s:apply_file_with_settings(file) abort
  let l:file = expand(a:file)

  if !filereadable(l:file)
    return
  endif

  silent exec 'source' l:file
endfunc

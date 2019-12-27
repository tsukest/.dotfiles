set backspace=indent,eol,start
set hlsearch
set cursorline
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4

au FileType json,yaml,sh,markdown set tabstop=2 shiftwidth=2
au FileType markdown set wrap

call plug#begin('~/.vim/plugged')
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'itchyny/lightline.vim'
Plug 'majutsushi/tagbar'
" lang
Plug 'mattn/vim-goimports'
" lsp
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
call plug#end()

syntax on
let g:dracula_italic = 0
colorscheme dracula

" lightline
set laststatus=2
let g:lightline = { 'colorscheme': 'dracula', }

" lsp
let g:lsp_async_completion = 1

if executable('gopls')
  augroup LspGo
    au!
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
        \ 'whitelist': ['go'],
        \ 'workspace_config': {'gopls': {
        \     'completeUnimported': v:true,
        \     'caseSensitiveCompletion': v:true,
        \     'usePlaceholders': v:true,
        \     'completionDocumentation': v:true,
        \     'watchFileChanges': v:true,
        \     'hoverKind': 'SingleLine',
        \   }},
        \ })
    autocmd BufWritePre *.go LspDocumentFormatSync
    autocmd FileType go call s:conf_lsp()
  augroup END
endif

if executable('bash-language-server')
  augroup LspBash
    au!
    au User lsp_setup call lsp#register_server({
      \ 'name': 'bash-language-server',
      \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
      \ 'whitelist': ['sh'],
      \ })
    autocmd FileType sh call s:conf_lsp()
  augroup END
endif
if executable('pyls')
  augroup LspPython
    au!
    au User lsp_setup call lsp#register_server({
      \ 'name': 'pyls',
      \ 'cmd': {server_info->['pyls']},
      \ 'whitelist': ['python'],
      \ })
    autocmd FileType python call s:conf_lsp()
  augroup END
endif
if executable('solargraph')
  augroup LspRuby
    au!
    au User lsp_setup call lsp#register_server({
      \ 'name': 'solargraph',
      \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
      \ 'initialization_options': {"diagnostics": "true"},
      \ 'whitelist': ['ruby'],
      \ })
    autocmd FileType ruby call s:conf_lsp()
  augroup END
endif
if executable('docker-langserver')
  augroup LspDockerfile
    au!
    au User lsp_setup call lsp#register_server({
      \ 'name': 'docker-langserver',
      \ 'cmd': {server_info->[&shell, &shellcmdflag, 'docker-langserver --stdio']},
      \ 'whitelist': ['dockerfile'],
      \ })
  augroup END
endif
function! s:conf_lsp() abort
  setlocal omnifunc=lsp#complete
  nmap <buffer> <C-]> <plug>(lsp-definition)
  nmap <buffer> ,n <plug>(lsp-next-error)
  nmap <buffer> ,p <plug>(lsp-previous-error)
endfunction

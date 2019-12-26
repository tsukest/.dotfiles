set encoding=utf-8
set cursorline
set laststatus=2
set showmatch
set title
set ruler
set tabstop=4
set shiftwidth=4
set incsearch
set hlsearch
set backspace=indent,eol,start
set noswapfile
set noshowmode


" ---------- Start setting up Vundle.vim ----------
call plug#begin('~/.vim/plugged')

Plug 'ctrlpvim/ctrlp.vim'
Plug 'cocopon/iceberg.vim'
Plug 'itchyny/lightline.vim'
" vim-lsp
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
" go
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
" rust
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
" elixir
Plug 'elixir-editors/vim-elixir'

call plug#end()
" ---------- End of Vundle.vim setting ----------


colorscheme iceberg
let g:lightline = {
      \ 'colorscheme': 'iceberg',
      \ }

" vim-lsp
if executable('gopls')
  augroup LspGo
    au!
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'whitelist': ['go'],
        \ 'workspace_config': {'gopls': {
        \     'hoverKind': 'SingleLine',
        \     'usePlaceholders': v:true,
        \     'completeUnimported': v:true,
        \   }},
        \ })
    autocmd FileType go setlocal omnifunc=lsp#complete
	autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
  augroup END
endif
if executable('rls')
  augroup LspRust
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'whitelist': ['rust'],
        \ })
    autocmd FileType rust setlocal omnifunc=lsp#complete
	autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
  augroup END
endif
let g:lsp_async_completion = 1
let g:lsp_diagnostics_enabled = 0

" vim-go
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_fmt_command = "goimports"

" rust.vim
let g:rustfmt_autosave = 1
" vim-racer
set hidden
let g:racer_cmd = "$HOME/.cargo/bin/racer"
autocmd FileType rust nmap <C-]> <Plug>(rust-def)
autocmd FileType rust nmap gs <Plug>(rust-def-split)
autocmd FileType rust nmap gx <Plug>(rust-def-vertical)
autocmd FileType rust nmap <leader>gd <Plug>(rust-doc)

" shell
autocmd BufNewFile,BufRead *.sh setlocal expandtab tabstop=2 shiftwidth=2
" markdown
autocmd BufNewFile,BufRead *.md setlocal expandtab tabstop=2 shiftwidth=2
" yaml
autocmd BufNewFile,BufRead *.yaml setlocal expandtab tabstop=2 shiftwidth=2
" html
autocmd BufNewFile,BufRead *.html setlocal expandtab tabstop=2 shiftwidth=2

" A minimal vimrc for new vim users to start with.
" Referenced here: http://vimuniversity.com/samples/your-first-vimrc-should-be-nearly-empty

call plug#begin('~/.local/share/nvim/plugged')
" Appearance
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'reedes/vim-colors-pencil'
" Text editing
Plug 'tpope/vim-surround'
Plug 'tommcdo/vim-exchange'
" Document writing
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'reedes/vim-pencil'
Plug 'vim-latex/vim-latex'
" File/buffer/layout management
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'mileszs/ack.vim'
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'Valloric/ListToggle' " supplements for YouCompleteMe
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'dhruvasagar/vim-zoom'
" ctags
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
" Keyword completion
Plug 'Valloric/YouCompleteMe'
" Code formatting
Plug 'Chiel92/vim-autoformat'
Plug 'rhysd/vim-clang-format'
Plug 'maksimr/vim-jsbeautify'
" Syntax checking
" Syntax highlighting
Plug 'tikhomirov/vim-glsl'
" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" Build
Plug 'neomake/neomake'
" Documentation
Plug 'KabbAmine/zeavim.vim', {'on': [
      \ 'Zeavim', 'Docset',
      \ '<Plug>Zeavim',
      \ '<Plug>ZVVisSelection',
      \ '<Plug>ZVKeyDocset',
      \ '<Plug>ZVMotion'
      \ ]}
call plug#end()

" Enable file type detection and do language-dependent indenting.
set nocompatible
filetype plugin indent on

set hidden " allow hidden buffers, don't limit to 1 file per window/split
set autoread " automatically read a file if it is changed

" Indentation
set expandtab
set shiftwidth=2
set softtabstop=2

" Editing
set backspace=indent,eol,start " allow backspacing over autoindent (indent)
                               " allow line-joining (eol)
                               " allow backspacing over the START of insert

" Appearance
set background=dark
" set background=light
colorscheme solarized
" colorscheme pencil

set listchars=tab:»-,trail:· " display tabs and trailing spaces
set list
syntax on " switch syntax highlighting on
set number " show line numbers

" filetype
filetype on
au BufNewFile,BufRead *.cuh set filetype=cpp
au BufNewFile,BufRead *.inc set filetype=tex
let g:tex_flavor = "latex"

let g:airline_theme = 'solarized'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

let g:gutentags_dont_load = 1
let g:buffergator_suppress_keymaps = 1
let g:clang_format#code_style = 'google'
let g:clang_format#style_options = {
  \ "Standard": "C++11" }
let g:ycm_always_populate_location_list = 1

let g:editorconfig_Beautifier='~/.editorconfig'

set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:zv_file_types = {
  \ 'cpp': 'cpp,boost'}

" xolox/vim-session
let g:session_autosave = 'no'
let g:session_autoload = 'no'

let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_ViewRule_pdf = 'okular --unique'

" Enforce good practice by disabling some keys
inoremap <C-C> <nop>
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

nnoremap <leader>ev :sp $MYVIMRC<cr> " shorthand for editing vimrc
nnoremap <leader>b :BuffergatorToggle<cr>
nnoremap <leader>tb :BuffergatorTabsToggle<cr>
nnoremap <leader>tg :TagbarToggle<cr>
nnoremap <leader>jd :YcmCompleter GoTo<cr>
nnoremap <leader>ji :YcmCompleter GoToInclude<cr>
nnoremap <leader>gt :YcmCompleter GetType<cr>
nnoremap <leader>f :YcmCompleter FixIt<cr>
nnoremap <leader>[ :lprevious<cr>
nnoremap <leader>] :lnext<cr>

" let g:tmux_navigator_no_mappings = 1
nnoremap è :TmuxNavigateLeft<cr>
nnoremap ê :TmuxNavigateDown<cr>
nnoremap ë :TmuxNavigateUp<cr>
nnoremap ì :TmuxNavigateRight<cr>
nnoremap Ü :TmuxNavigatePrevious<cr>

" for macOS SSH
nnoremap ˙ :TmuxNavigateLeft<cr>
nnoremap ∆ :TmuxNavigateDown<cr>
nnoremap ˚ :TmuxNavigateUp<cr>
nnoremap ¬ :TmuxNavigateRight<cr>
nnoremap « :TmuxNavigatePrevious<cr>

autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
autocmd FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
autocmd FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>

let g:pencil#wrapModeDefault = 'soft'
augroup pencil
  autocmd!
  autocmd FileType markdown,mkd,tex call pencil#init()
                            \ | setl spell spl=en_us fdl=4 noru nonu nornu
                            \ | setl fdo+=search
"  autocmd Filetype git,gitsendemail,*commit*,*COMMIT*
"                            \   call pencil#init({'wrap': 'hard', 'textwidth': 72})
"                            \ | setl spell spl=en_us et sw=2 ts=2 noai
  autocmd Filetype mail         call pencil#init({'wrap': 'hard', 'textwidth': 60})
                            \ | setl spell spl=en_us et sw=2 ts=2 noai nonu nornu
  autocmd Filetype html,xml     call pencil#init({'wrap': 'soft'})
                            \ | setl spell spl=en_us et sw=2 ts=2
augroup END

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!


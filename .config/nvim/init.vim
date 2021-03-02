" A minimal vimrc for new vim users to start with.
" Referenced here: http://vimuniversity.com/samples/your-first-vimrc-should-be-nearly-empty

call plug#begin('~/.local/share/nvim/plugged')
" Appearance
Plug 'romainl/flattened'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'reedes/vim-colors-pencil'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'machakann/vim-highlightedyank'
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
Plug 'kassio/neoterm'
" ctags
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'
Plug 'majutsushi/tagbar'
" Keyword completion
Plug 'Valloric/YouCompleteMe'
" Code formatting
Plug 'Chiel92/vim-autoformat'
" install yapf for python formatting
" Syntax checking
" Syntax highlighting
Plug 'tikhomirov/vim-glsl'
Plug 'vim-scripts/ShaderHighLight'
Plug 'voldikss/vim-mma'
" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'rickhowe/diffchar.vim'
" Build
Plug 'neomake/neomake'
" Test
Plug 'vim-test/vim-test'
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
set inccommand=split " shows the effects of :substitute incrementally
if $WSL == 'true'
  let g:clipboard = {
        \   'name': 'myClipboard',
        \   'copy': {
        \      '+': '/mnt/c/tools/neovim/Neovim/bin/win32yank.exe -i --crlf',
        \      '*': '/mnt/c/tools/neovim/Neovim/bin/win32yank.exe -i --crlf',
        \    },
        \   'paste': {
        \      '+': '/mnt/c/tools/neovim/Neovim/bin/win32yank.exe -o --lf',
        \      '*': '/mnt/c/tools/neovim/Neovim/bin/win32yank.exe -o --lf',
        \   },
        \   'cache_enabled': 1,
        \ }
endif

" Appearance
set background=dark
set termguicolors
set foldmethod=marker
colorscheme flattened_dark
if $UNAME == 'Darwin'
  language en_US.UTF-8
else
  language en_US.utf8
endif
" colorscheme pencil

set listchars=tab:»-,trail:· " display tabs and trailing spaces
set list
syntax on " switch syntax highlighting on
set number relativenumber " jeffkreeftmeijer/vim-numbertoggle

" filetype
filetype on
au BufNewFile,BufRead *.cu,*.cuh set filetype=cpp
au BufNewFile,BufRead *.inc set filetype=tex
au BufNewFile,BufRead *.cginc set filetype=shaderlab
let g:tex_flavor = "pdflatex"

let g:airline_theme = 'solarized'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

let g:DiffUnit = 'Word1'
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast, respects .gitignore
  " and .agignore. Ignores hidden files by default.
  let g:ctrlp_user_command = 'ag %s -l --nocolor -f -g ""'
else
  "ctrl+p ignore files in .gitignore
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
endif
let g:ackprg = 'ag --nogroup --nocolor --column'
let g:buffergator_suppress_keymaps = 1
let g:ycm_always_populate_location_list = 1

set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%{gutentags#statusline()}
set statusline+=%*

let g:zv_file_types = {
  \ 'cpp': 'cpp,boost'}

let g:neoterm_default_mod = 'belowright'
let test#strategy='neoterm'
" xolox/vim-session
let g:session_autosave = 'no'
let g:session_autoload = 'no'

let g:gutentags_modules = ['ctags', 'gtags_cscope']
let g:gutentags_cache_dir = expand('~/.cache/tags')

let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_Debug = 1
let g:Tex_MultipleCompileFormats = 'dvi,pdf'
if $WSL == 'true'
  let g:Tex_ViewRule_pdf = 'sumatrapdf'
  let g:Tex_ExecuteUNIXViewerInForeground = 1
elseif $UNAME == 'Darwin'
  let g:Tex_ViewRule_pdf = 'open -a Skim'
elseif $UNAME == 'Linux'
  let g:Tex_ViewRule_pdf = 'okular --unique'
endif
let g:Tex_IgnoredWarnings =
  \'Underfull'."\n".
  \'Overfull'."\n".
  \'specifier changed to'."\n".
  \'You have requested'."\n".
  \'Missing number, treated as zero.'."\n".
  \'There were undefined references'."\n".
  \'Package hyperref Warning'."\n".
  \'Citation %.%# undefined'
let g:Tex_IngnoreLevel = 8
function CompileXeTex()
    let oldCompileRule=g:Tex_CompileRule_pdf
    let g:Tex_CompileRule_pdf = 'xelatex --synctex=-1 -src-specials -interaction=nonstopmode $*'
    call Tex_RunLaTeX()
    let g:Tex_CompileRule_pdf=oldCompileRule
endfunction
nnoremap <leader>lx :<C-u>call CompileXeTex()<cr>

" Enforce good practice by disabling some keys
inoremap <C-c> <nop>
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
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-_> :Autoformat<cr>
com! FormatXML :%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"
nnoremap = :FormatXML<Cr>

" shorthand for escaping terminal mode
tnoremap <A-[> <C-\><C-n>

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

autocmd! User GoyoEnter Limelight | color flattened_light
autocmd! User GoyoLeave Limelight! | color flattened_dark

call plug#begin()
Plug 'preservim/nerdtree'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'Raimondi/delimitMate'
Plug 'SirVer/ultisnips'
Plug 'arthurxavierx/vim-caser'
Plug 'cespare/vim-toml'
Plug 'corylanou/vim-present', {'for' : 'present'}
Plug 'ekalinin/Dockerfile.vim', {'for' : 'Dockerfile'}
Plug 'elzr/vim-json', {'for' : 'json'}
Plug 'ervandew/supertab'
Plug 'fatih/molokai'
Plug 'fatih/vim-go'
Plug 'fatih/vim-hclfmt'
Plug 'fatih/vim-nginx' , {'for' : 'nginx'}
Plug 'godlygeek/tabular'
Plug 'hashivim/vim-hashicorp-tools'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'plasticboy/vim-markdown'
Plug 'roxma/vim-tmux-clipboard'
Plug 'scrooloose/nerdtree'
Plug 't9md/vim-choosewin'
Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-scriptease'
Plug 'joshdick/onedark.vim'
call plug#end()

if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

set number
set showcmd
set noerrorbells
set paste
set noswapfile
set nobackup
set conceallevel=0

let s:modes = {
      \ 'n': 'NORMAL', 
      \ 'i': 'INSERT', 
      \ 'R': 'REPLACE', 
      \ 'v': 'VISUAL', 
      \ 'V': 'V-LINE', 
      \ "\<C-v>": 'V-BLOCK',
      \ 'c': 'COMMAND',
      \ 's': 'SELECT', 
      \ 'S': 'S-LINE', 
      \ "\<C-s>": 'S-BLOCK', 
      \ 't': 'TERMINAL'
      \}

let s:prev_mode = ""
function! StatusLineMode()
  let cur_mode = get(s:modes, mode(), '')

  " do not update higlight if the mode is the same
  if cur_mode == s:prev_mode
    return cur_mode
  endif

  if cur_mode == "NORMAL"
    exe 'hi! StatusLine ctermfg=236'
    exe 'hi! myModeColor cterm=bold ctermbg=148 ctermfg=22'
  elseif cur_mode == "INSERT"
    exe 'hi! myModeColor cterm=bold ctermbg=23 ctermfg=231'
  elseif cur_mode == "VISUAL" || cur_mode == "V-LINE" || cur_mode == "V_BLOCK"
    exe 'hi! StatusLine ctermfg=236'
    exe 'hi! myModeColor cterm=bold ctermbg=208 ctermfg=88'
  endif

  let s:prev_mode = cur_mode
  return cur_mode
endfunction

function! StatusLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! StatusLinePercent()
  return (100 * line('.') / line('$')) . '%'
endfunction

function! StatusLineLeftInfo()
 let branch = fugitive#head()
 let filename = '' != expand('%:t') ? expand('%:t') : '[No Name]'
 if branch !=# ''
   return printf("%s | %s", branch, filename)
 endif
 return filename
endfunction

exe 'hi! myInfoColor ctermbg=240 ctermfg=252'

" start building our statusline
set statusline=

" mode with custom colors
set statusline+=%#myModeColor#
set statusline+=%{StatusLineMode()}               
set statusline+=%*

" left information bar (after mode)
set statusline+=%#myInfoColor#
set statusline+=\ %{StatusLineLeftInfo()}
set statusline+=\ %*

" go command status (requires vim-go)
set statusline+=%#goStatuslineColor#
set statusline+=%{go#statusline#Show()}
set statusline+=%*

" right section seperator
set statusline+=%=

" filetype, percentage, line number and column number
set statusline+=%#myInfoColor#
set statusline+=\ %{StatusLineFiletype()}\ %{StatusLinePercent()}\ %l:%v
set statusline+=\ %*

syntax on
colorscheme onedark

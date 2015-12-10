" 行番号の表示
set nu

" 右下に表示される行・列の番号を表示
set ruler

" yankをクリップボードへ
set clipboard=unnamed,autoselect

" 自動インデントを有効にする
set autoindent


" タブを表示する時の幅
set tabstop=4

" 自動で挿入されるインデントの幅
set shiftwidth=4

" タブ入力時の幅を4に設定
set softtabstop=4

" 閉じ括弧入力時に対応する括弧の強調
set showmatch

" showmatch設定の表示秒数(0.1秒単位)
set matchtime=4

" インクリメンタルサーチを行う(検索文字入力中から検索)
set incsearch

" 文字列検索で大文字小文字を区別しない
set ignorecase

" 文字列検索でマッチするものをハイライト表示する
set hlsearch

" 検索文字に大文字が含まれる場合にignorecaseをOFFにする(大文字小文字を区別する)
set smartcase

" コマンドラインにおける補完候補の表示
set wildmenu

" Deleteキーを有効にする
set t_kD=^?

" バックスペースキーの動作を普通のテキストエディタと同じようにする
set backspace=indent,eol,start

" 見た目によるカーソル移動をする(1行が複数行に渡って表示されている時に表示上の行ごとに上下移動させる)
nnoremap j gj
nnoremap k gk

" シンタックスを有効にする(コードをカラーを付けて見やすくする)
syntax enable

" カラー設定
colorscheme molokai
set t_Co=256

" エンコーディングをutf8に設定
set encoding=utf8

" ファイルエンコードをutf8に設定
set fileencoding=utf-8

" 編集中のファイル名を表示
set title

" ウィンドウの幅より長い行は折り返して表示
set wrap

"light.vimの設定
set laststatus=2

"============NeoBundole============
if has('vim_starting')
   " 初回起動時のみruntimepathにneobundleのパスを指定する
   set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" NeoBundleを初期化
call neobundle#begin(expand('~/.vim/bundle/'))

" インストールするプラグインをここに記述
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
"vimfilerを標準のファいらに
let g:vimfiler_as_default_explorer = 1
"ディレクトリに移動せず子を表示
autocmd FileType vimfiler nmap <buffer> <CR> <Plug>(vimfiler_expand_or_edit)

"vimの下のファイルのとこ綺麗にする
NeoBundle 'itchyny/lightline.vim'

"インデントに色をつける
NeoBundle 'nathanaelkane/vim-indent-guides'
" indent guid setting
let g:indent_guides_auto_colors=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   ctermbg=110
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=140
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=1

"emmet
NeoBundle 'mattn/emmet-vim'
autocmd FileType html imap <buffer><expr><tab>
    \ emmet#isExpandable() ? "\<plug>(emmet-expand-abbr)" :
    \ "\<tab>"
call neobundle#end()

" ファイルタイプ別のプラグイン/インデントを有効にする
filetype plugin indent on
"============NeoBundole============

"============light.vim=============
let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
        \ },
        \ 'component_function': {
        \   'modified': 'LightLineModified',
        \   'readonly': 'LightLineReadonly',
        \   'fugitive': 'LightLineFugitive',
        \   'filename': 'LightLineFilename',
        \   'fileformat': 'LightLineFileformat',
        \   'filetype': 'LightLineFiletype',
        \   'fileencoding': 'LightLineFileencoding',
        \   'mode': 'LightLineMode'
        \ }
        \ }

function! LightLineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! LightLineFilename()
  return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      return fugitive#head()
    endif
  catch
  endtry
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction
"============light.vim end==========

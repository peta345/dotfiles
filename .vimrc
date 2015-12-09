""""""""""""""""""""""""""""""""""""""""""""
" 基本設定
""""""""""""""""""""""""""""""""""""""""""""
set nocompatible                                 " viとの互換性無効 タブ補完などが使えるようになる
syntax on                                        " コードの色分けをON
set history=2000                                 " 履歴保存件数(コマンド、検索パターンの保存数)
set viminfo='100,/50,%,<1000,f50,s100,:100,c,h,! " 履歴に保存する各種設定
set display=lastline                             " 一行の内容を行末の最後まで表示する
set notitle                                      " ウィンドウタイトルを変更しない
"set title                                        " ウインドウタイトルを設定する
set shortmess+=I                                 " 起動時のメッセージを消す
"set hidden                                       " ファイル：複数ファイルの編集を可能にする
"set autoread                                     " ファイル：内容が変更されたら自動的に再読み込み
set encoding=utf-8                               " ファイル：vimの文字コード 
set fileformats=unix,dos                         " ファイル：ファイルフォーマット
set nobackup                                     " ファイル：バックアップを作成しない
set updatetime=0                                 " ファイル：Swapを作るまでの時間m秒
set hlsearch                                     " サーチ：検索結果をハイライトする
set incsearch                                    " サーチ：インクリメンタルサーチ（検索中に文字を打つと自動で検索していく）
set ignorecase                                   " サーチ：大文字小文字を区別しない
set smartcase                                    " サーチ：大文字で検索されたら対象を大文字限定にする
set nowrapscan                                   " サーチ：検索がファイル末尾まで進んだらそこで先頭に戻らず止まる
"set wrapscan                                     " サーチ：行末まで検索したら行頭に戻る
set showmatch                                    " カーソル：括弧にカーソルを合わせた時、対応した括弧を表示する
set matchtime=1                                  " カーソル：カーソルが飛ぶ時間を0.1秒で飛ぶようにする
set whichwrap=b,s,h,l,<,>,[,]                    " カーソル：行をまたいで左右のカーソル移動できるようにする
set backspace=start,eol,indent                   " カーソル：バックスペースで消せるようにする
set nostartofline                                " カーソル：括弧を閉じたとき対応する括弧に一時的に移動
set ttyfast                                      " ターミナル：ターミナル接続を高速にする
set t_Co=256                                     " ターミナル：ターミナルで256色表示を使う
"set paste                                        " ターミナル：ターミナル上からの張り付けを許可
set expandtab                                    " タブを半角スペースに置き換える
set tabstop=4                                    " タブ幅をスペース4つ分にする
set shiftwidth=4                                 " 自動インデントの幅
set cmdheight=1                                  " コマンドラインの高さ
set laststatus=2                                 " ステータスバーを表示する位置
"set ruler                                        " ルーラの表示
"set number                                       " 行番号の表示
set showtabline=2                                " タブページを常に表示
"set autoindent                                   " 自動インデント
"set cursorline                                   " カーソルラインを表示する
"set list                                         " タブ文字など特殊文字を可視化

" タブ、行末スペースなどを可視化した時に表示する記号
set listchars=eol:$,tab:>\-,trail:-,extends:>,precedes:<,nbsp:% 

"行番号を表示する
set number
" 全角スペースの可視化(行末スペースの可視化と同時に設定できない)
hi ZenkakuSpace cterm=underline ctermfg=lightblue ctermbg=white
match ZenkakuSpace /　/

" 行末スペースの可視化(全角スペースの可視化と同時に設定できない)
"augroup HighlightTrailingSpaces
"  autocmd!
"  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
"  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
"augroup END

" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" カーソルラインがONの時、行全体をハイライトする
hi CursorLine cterm=NONE ctermfg=Black ctermbg=Blue

" カーソルラインがONの時、行番号をハイライトする
hi CursorColumn cterm=NONE ctermbg=Blue ctermfg=black
""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""
" ステータスバー関連
""""""""""""""""""""""""""""""""""""""""""""
" 自動文字数カウント
augroup WordCount
    autocmd!
    autocmd BufWinEnter,InsertLeave,CursorHold * call WordCount('char')
augroup END
let s:WordCountStr = ''
let s:WordCountDict = {'word': 2, 'char': 3, 'byte': 4}
function! WordCount(...)
    if a:0 == 0
        return s:WordCountStr
    endif
    let cidx = 3
    silent! let cidx = s:WordCountDict[a:1]
    let s:WordCountStr = ''
    let s:saved_status = v:statusmsg
    exec "silent normal! g\<c-g>"
    if v:statusmsg !~ '^--'
        let str = ''
        silent! let str = split(v:statusmsg, ';')[cidx]
        let cur = str2nr(matchstr(str, '\d\+'))
        let end = str2nr(matchstr(str, '\d\+\s*$'))
        if a:1 == 'char'
            " ここで(改行コード数*改行コードサイズ)を'g<C-g>'の文字数から引く
            let cr = &ff == 'dos' ? 2 : 1
            let cur -= cr * (line('.') - 1)
            let end -= cr * line('$')
        endif
        let s:WordCountStr = printf('%d/%d', cur, end)
    endif
    let v:statusmsg = s:saved_status
    return s:WordCountStr
endfunction

" 挿入モード時、ステータスラインの色を変更
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=black ctermbg=white cterm=none'
if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif
let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction
function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction
if has('unix') && !has('gui_running')
  " ESC後にすぐ反映されない対策
"  inoremap <silent> <ESC> <ESC>
  " なぜか矢印キーが効かなくなるのでコメントアウト
endif

" ステータスバー設定
set statusline=%F                                                 " [ステータスバー]ファイル名表示
set statusline+=%m                                                " [ステータスバー]変更のチェック表示
set statusline+=%r                                                " [ステータスバー]読み込み専用かどうか表示 
set statusline+=%h                                                " [ステータスバー]ヘルプページなら[HELP]と表示
set statusline+=%w\                                               " [ステータスバー]プレビューウインドウなら[Prevew]と表示 
set statusline+=%=                                                " [ステータスバー]ここからツールバー右側
set statusline+=[FORMAT=%{&ff}]\                                  " [ステータスバー]ファイルフォーマット表示
set statusline+=[%{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding}] " [ステータスバー]文字コードの表示
set statusline+=[%l行,%v桁]                                       " [ステータスバー]列位置、行位置の表示
set statusline+=[%p%%]                                            " [ステータスバー]現在行が全体行の何%目か表示
set statusline+=[WC=%{exists('*WordCount')?WordCount():[]}]       " [ステータスバー]現在のファイルの文字数をカウント
""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""
" マッピング
""""""""""""""""""""""""""""""""""""""""""""
"ファンクションキーの割り当て
" F1:前のタブ
nnoremap <F1> gT
inoremap <F1> <Esc>gTi
" F2:次のタブ
nnoremap <F2> gt
inoremap <F2> <Esc>gt<Insert>
" F3:下候補
nnoremap <F3> n
inoremap <F3> <Esc>n<Insert>
" F4:上候補
nnoremap <F4> N
inoremap <F4> <Esc>N<Insert>
" F5:マークの下検索
nnoremap <F5> ]'zz
inoremap <F5> <Esc>]'zz<Insert>
" F6:マークの上検索
nnoremap <F6> ['zz
inoremap <F6> <Esc>['zz<Insert>
" F7:マーク一覧
nnoremap <F7> :marks<CR>
inoremap <F7> <Esc>:marks<CR>
" F8:マーク一括削除
nnoremap <F8> :delmarks!<CR>
inoremap <F8> <Esc>:delmarks!<CR><Insert>
" F9:マーク位置保存
nnoremap <F9> :<C-u>call <SID>AutoMarkrement()<CR>
inoremap <F9> <Esc>:<C-u>call <SID>AutoMarkrement()<CR><Insert>
" F10:行番号表示／非表示
nnoremap <F10> :<C-u>setlocal number!<CR>
inoremap <F10> <Esc>:<C-u>setlocal number!<CR><Insert>
" F11:カーソルラインの表示／非表示
nnoremap <F11> :<C-u>setlocal cursorline!<CR>
inoremap <F11> <Esc>:<C-u>setlocal cursorline!<CR><Insert>
" F12:タブ、空白、改行などの可視化ON／OFF
nnoremap <F12> :<C-u>setlocal list!<CR>
inoremap <F12> <Esc>:<C-u>setlocal list!<CR><Insert>

" Y: Yを行末までのヤンクにする
nnoremap Y y$

" x:削除でヤンクしない
nnoremap x "_x

" Ctrl+k:行削除（ヤンクしない）
nnoremap <C-k> "_dd
inoremap <C-k> <Esc>"_ddi

" 最後に編集した位置に飛ぶ
nnoremap <C-l> `.
inoremap <C-l> <Esc>`.<Insert>

" mを押すことで自動でマーク位置をレジストリに保存する
nnoremap <silent>m :<C-u>call <SID>AutoMarkrement()<CR>

" サーチした検索語を画面中央に持ってくる
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

" ---ノーマルモード---
" [Esc] + [Esc]で検索のハイライトを消す
nnoremap <Esc><Esc> :noh<CR>
" 「+」でsplitリサイズ幅を増やす
nnoremap + <C-W>k<C-W>+<C-W>p
" 「-」でsplitリサイズ幅を減らす
nnoremap - <C-W>k<C-W>-<C-W>p
" 「)」でVsplitリサイズ幅を増やす
nnoremap ) <C-W>h<C-W>><C-W>p
" 「(」でVsplitリサイズ幅を減らす
nnoremap ( <C-W>h<C-W><LT><C-W>p
" 「tt」でタブを新しく作る
nnoremap tt :<C-u>tabnew<CR>
" 「tc」でタブを閉じる
nnoremap tc :<C-u>tabclose<CR>
" 「tf」で最初のタブへ
nnoremap tf :<C-u>tabfirst<CR>
" 「tl」で最後のタブへ
nnoremap tl :<C-u>tablast<CR>

" ---挿入モード---
" 「^?」は挿入モードで[Ctrl]+[Delete]を押す（この設定はDeleteが反応しない場合のみに行う）
" deleteキーを反応するようにする
inoremap <silent> ^? <Del>
" カーソル前の文字削除
inoremap <silent> <C-h> <C-g>u<C-h>
" カーソル後の文字削除
inoremap <silent> <C-d> <Del>
" カーソルから行頭まで削除
inoremap <silent> <C-d>e <Esc>lc^
" カーソルから行末まで削除
inoremap <silent> <C-d>0 <Esc>lc$
" [Ctrl]+zでアンドゥ
inoremap <C-z> <Esc>ui
" [Ctrl]+yでリドゥ
inoremap <C-y> <Esc><C-r><Insert>

" ---コマンドモード---
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-d> <Delete>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>

" ---カンマコマンドモード---
" 「,」を打ってから各キーを打つと各コマンドを実行
let mapleader=","
" 「,r」：.vimrcのリロード
noremap <Leader>r :source ~/.vimrc<CR>:noh<CR>
" 「,,」：ファイルの上書き保存
nnoremap <Leader>, :<C-u>update<CR>
" 「,q」：ファイルを閉じる
nnoremap <Leader>q :<C-u>q<CR>
" 「,Q」：ファイルを強制的に閉じる
nnoremap <Leader>Q :<C-u>q!<CR>
" 「,p」：ペースト
nnoremap <Leader>p :<C-u>set invpaste<CR>
" 「,k」：make
noremap <Leader>k :<C-u>make!<CR><CR>:<C-u>make! clean<CR><CR>
" 「,m」：マウスモードOFF
noremap <Leader>m :<C-u>set mouse=<CR>:set nonumber<CR>
" 「,M」：マウスモードON
noremap <Leader>M :<C-u>set mouse=a<CR>:set number<CR>
" 「,e」：メニューの表示(タブで各項目を選んでいく)
nnoremap <Leader>e :<C-u>emenu Commands.<TAB>
" 「,s」：ウィンドウを縦分割
nnoremap <Leader>s :<C-u>sp<CR>
" 「,v」：ウィンドウを横分割
nnoremap <Leader>v :<C-u>vs<CR>
" 「,S」：ウィンドウを縦分割(ファイルを選択)
nnoremap <Leader>S :<C-u>sp <TAB>
" 「,V」：ウィンドウを横分割（ファイルを選択）
nnoremap <Leader>V :<C-u>vs <TAB>
" 「,t」：新規タブを作成
nnoremap <Leader>t :<C-u>tabnew<cr>
" 「,T」：新規タブを作成（ファイルを選択）
nnoremap <Leader>T :<C-u>tabnew <TAB>
" 「,n」：行番号表示／非表示
noremap <Leader>n :<C-u>:setlocal number!<CR>
" 「,c」：カーソルラインの表示／非表示
noremap <Leader>c :<C-u>:setlocal cursorline!<CR>
" 「,C」：カーソルカラムの表示／非表示
noremap <Leader>C :<C-u>:setlocal cursorcolumn!<CR>
" 「,l」：タブ、空白、改行などの可視化ON／OFF
noremap <Leader>l :<C-u>:setlocal list!<CR>
"""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""
" コマンド
""""""""""""""""""""""""""""""""""""""""""""
" 最後に編集した行への移動
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END

" バッファ読み込み時にマークを初期化
au BufReadPost * delmarks!

" 「:Cs」と打つとカーソルの一時保存
function! SaveCursor()
   let g:now_flg = 0
   let g:seve_cursor_pos = getpos(".")
endfunction
command! Cs :call SaveCursor()

" 「:Cc」と打つと一時保存したカーソルへ移動
function! SetCursor()
   let g:now_seve_cursor_pos = get(g:, 'now_seve_cursor_pos', getpos("."))
   let g:now_flg = get(g:, 'now_flg', 0)
   if !exists('g:seve_cursor_pos')
      echo ":Csでカーソル位置を保存してください"
   else
      if g:now_flg == 0
         let g:now_seve_cursor_pos = getpos(".")
         call setpos('.', g:seve_cursor_pos)
         let g:now_flg = 1
      else
         if getpos(".") == g:now_seve_cursor_pos
            call setpos('.', g:seve_cursor_pos)
            let g:now_flg = 1
         else
            call setpos('.', g:now_seve_cursor_pos)
            let g:now_flg = 0
         endif
      endif
   endif
endfunction
command! Cc :call SetCursor()

" csvファイルハイライト「:Csv [数値]」 と打つと、csvファイルでnカラム目のハイライトをしてくれる
function! CSVH(x)
   execute 'match Keyword /^\([^,]*,\)\{'.a:x.'}\zs[^,]*/'
   execute 'normal ^'.a:x.'f,'
endfunction
command! -nargs=1 Csv :call CSVH(<args>)

" 「:Csvs」と打つと、現在のカラムをハイライトにしてくれる
command! Csvs :call CSVH(strlen(substitute(getline('.')[0:col('.')-1], "[^,]", "", "g")))

" 「:Csvn」と打つと、Csv系のコマンドのハイライトを消す
command! Csvn execute 'match none'

" 「:Csva」と打つと、リアルタイムに現在のカラムをハイライトにしてくれるもう一度打つと停止
function! CSVH_SAVE_CURSOR()
   let g:CsvaFlg = get(g:, 'CsvaFlg', 0)
   if g:CsvaFlg == 1
      execute 'match Keyword /^\([^,]*,\)\{'.strlen(substitute(getline('.')[0:col('.')-1], "[^,]", "", "g")).'}\zs[^,]*/'
   endif
endfunction
augroup CsvCursorHighlight
    autocmd!
    autocmd BufWinEnter,InsertLeave,CursorHold * call CSVH_SAVE_CURSOR() 
augroup END
function! CSVA()
   let g:CsvaFlg = get(g:, 'CsvaFlg', 0)
   if g:CsvaFlg == 0
      let g:CsvaFlg = 1
   else
      execute 'match none'
      let g:CsvaFlg = 0
   endif
endfunction
command! Csva :call CSVA()

" csvファイルを読み込んだ時に自動でCsvaコマンドを実行する
autocmd BufNewFile,BufRead *.csv execute'Csva'

" 無限undo Vimを終了しても復元する
if has('persistent_undo')
    set undodir=./.vimundo,~/.vimundo
    set undofile
endif

" エンコード設定
if has('unix')
    set fileformat=unix
    set fileformats=unix,dos,mac
    set fileencoding=utf-8
    set fileencodings=utf-8,iso-2022-jp,cp932,euc-jp
    set termencoding=
elseif has('win32')
    set fileformat=dos
    set fileformats=dos,unix,mac
    set fileencoding=utf-8
    set fileencodings=iso-2022-jp,utf-8,euc-jp,cp932
    set termencoding=
endif

" .binファイルがある場合、HEXエディタとしてvimを使う
if has('unix')
    augroup Binary
        au!
        au BufReadPre  *.bin let &bin=1
        au BufReadPost *.bin if &bin | silent %!xxd -g 1
        au BufReadPost *.bin set ft=xxd | endif
        au BufWritePre *.bin if &bin | %!xxd -r
        au BufWritePre *.bin endif
        au BufWritePost *.bin if &bin | silent %!xxd -g 1
        au BufWritePost *.bin set nomod | endif
    augroup END
endif

" mを押すことで自動で現在のマーク位置をレジストリに格納する
if !exists('g:markrement_char')
    let g:markrement_char = [
    \     'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    \     'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
    \ ]
endif
function! s:AutoMarkrement()
    if !exists('b:markrement_pos')
        let b:markrement_pos = 0
    else
        let b:markrement_pos = (b:markrement_pos + 1) % len(g:markrement_char)
    endif
    execute 'mark' g:markrement_char[b:markrement_pos]
    echo 'marked' g:markrement_char[b:markrement_pos]
endfunction

" アクティブウィンドウに限りカーソル行(列)を強調する
"augroup vimrc_set_cursorline_only_active_window
"  autocmd!
"  autocmd VimEnter,BufWinEnter,WinEnter * setlocal cursorline
"  autocmd WinLeave * setlocal nocursorline
"augroup END

" インサートモードに入った時にカーソル行(列)の色を変更する
"augroup vimrc_change_cursorline_color
"  autocmd!
"  " インサートモードに入った時にカーソル行の色をブルーグリーンにする
"  autocmd InsertEnter * highlight CursorLine ctermbg=24 guibg=#005f87 | highlight CursorColumn ctermbg=24 guibg=#005f87
"  " インサートモードを抜けた時にカーソル行の色を黒に近いダークグレーにする
"  autocmd InsertLeave * highlight CursorLine ctermbg=236 guibg=#303030 | highlight CursorColumn ctermbg=236 guibg=#303030
"augroup END
""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""
" emenu、マウス操作、GUIなどその他
""""""""""""""""""""""""""""""""""""""""""""
" CUI時は[Esc]-l→[Tab]でメニューを開いていく
" CUI時にメニューを[ESC]-eでメニュー表示する
" Commandsは「,e」で開いていく
set wildcharm=<TAB>
if has('gui')
    nmap <M-l> :emenu <TAB>
else
    nmap <ESC>e :emenu <TAB>
endif
" コマンドメニュー
menu Commands.Edit\ \.vimrc                         :e $MYVIMRC<cr>
menu Commands.-sep-                                 :
menu Commands.\.vimrcを再読み込みする。             :so $MYVIMRC<cr>
menu Commands.-sep-                                 :
menu Commands.ウィンドウ.縦分割                     :<C-u>sp<CR>
menu Commands.ウィンドウ.横分割                     :<C-u>vs<CR>
menu Commands.ウィンドウ.縦分割(ファイルを選択)     :<C-u>sp <TAB>
menu Commands.ウィンドウ.横分割(ファイルを選択)     :<C-u>vs <TAB>
menu Commands.タブ.新規タブを作成                   :<C-u>tabnew<cr>
menu Commands.タブ.新規タブを作成（ファイルを選択） :<C-u>tabnew <TAB>
menu Commands.表示.行番号表示／非表示               :<C-u>setlocal number!<CR>
menu Commands.表示.カーソルラインの表示／非表示     :<C-u>setlocal cursorline!<CR>
menu Commands.表示.改行などの特殊記号表示／非表示   :<C-u>setlocal list!<CR>
menu Commands.Csv.カーソル位置のカラムを強調        :Csvs<cr>
menu Commands.Csv.リアルタイムにカラムを強調        :Csva<cr>
menu Commands.Csv.強調されたカラムの色を消す        :Csvn<cr>

" SSHを通してファイルオープン
menu User.Open.SCP.NonSprit :e! scp:///<LEFT>
menu User.Open.SCP.VSprit :vsp<CR>:wincmd w<CR>:e! scp:///<LEFT>
menu User.Open.SCP.Sprit :sp<CR>:wincmd w<CR>:e! scp:///<LEFT>
" 分割してファイルブラウザを起動
menu User.Open.Explolr.NonSprit :vsp<CR>:wincmd w<CR>:e! ./<CR>
menu User.Open.Explolr.VSprit :vsp<CR>:wincmd w<CR>:e! ./<CR>
menu User.Open.Explolr.Sprit :sp<CR>:wincmd w<CR>:e! ./<CR>
" 各種VIMの記録情報を表示する
menu User.Buffur.RegisterList :dis<CR>
menu User.Buffur.BuffurList :ls<CR>
menu User.Buffur.HistoryList :his<CR>
menu User.Buffur.MarkList :marks<CR>
menu User.Buffur.JumpList :jumps<CR>
" エンコードを指定して再読み込み
menu User.Encode.reload.SJIS :e ++enc=cp932<CR>
menu User.Encode.reload.EUC :e ++enc=euc-jp<CR>
menu User.Encode.reload.ISO :e ++enc=iso-2022-jp<CR>
menu User.Encode.reload.UTF :e ++enc=utf-8<CR>
" 保存エンコードを指定
menu User.Encode.convert.SJIS :set fenc=cp932<CR>
menu User.Encode.convert.EUC :set fenc=euc-jp<CR>
menu User.Encode.convert.ISO :set fenc=iso-2022-jp<CR>
menu User.Encode.convert.UTF :set fenc=utf-8<CR>
" フォーマットを指定して再読み込み
menu User.Format.Unix :e ++ff=unix<CR>
menu User.Format.Dos :e ++ff=dos<CR>
menu User.Format.Mac :e ++ff=mac<CR>
" 行番号をファイルに挿入
menu User.Global.No :%!awk '{print NR, $0}'<CR>
" TABをSPACEに変換する
menu User.Global.Space :set expandtab<CR>:retab<CR>
" 空白行を削除する
menu User.Global.Delete :g/^$/d<CR>
" カーソル上の単語を全体から検索し、別ウインドウで表示
menu User.Cursor.Serch.Show [I
menu User.Cursor.Serch.Top [i
menu User.Cursor.Serch.Junp [<tab>
" カーソル上のファイルのオープン
menu User.Cursor.FileOpen gf
" コピー、ペーストモード
menu User.Cursor.Paste :call Indent()<CR>
" 全体置き換えモード
menu User.Cursor.Replace :%s/
" C-C,C-Rと同様
menu User.Cursor.Delete yw:%v:<C-R>0

"ワイルドメニューを使う
set wildmenu
set wildmode=longest,list,full

"OSのクリップボードを使用する(vim --version | grep clipboardで+clipboardになっている場合)
set clipboard+=unnamed

"ターミナルでマウスを使用できるようにする
"if has ("mouse")
"    set mouse=a
"    set guioptions+=a
"    set ttymouse=xterm2
"endif

if has('gui')
    "ツールバーを消す
"    set guioptions=egLta
    "既に開いているGVIMがあるときはそのVIMを前面にもってくる
    runtime macros/editexisting.vim
    "gp gyで+レジスタに入出力
    nmap gd "+d
    nmap gy "+y
    nmap gp "+p
    nmap gP "+P
endif
""""""""""""""""""""""""""""""""""""""""""""

# dotfiles
cd -> git clone "ここ"  

cd dotfiles -> sh dotfilesLink.sh で.vimrcのエイリアスを作っておく
//NeoBundleのダウンロード
mkdir -p ~/.vim/bundle  
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim  

//color molokai.vim を~/.vim/colors　にもってくる  
cd ~/.vim  
mkdir colors
cd colors
git clone https://github.com/tomasr/molokai  

mv milokai/colors/molokai.vim ~/.vim/colors  


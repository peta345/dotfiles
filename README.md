# dotfiles
cd -> git clone "ここ"  

//NeoBundleのダウンロード
mkdir -p ~/.vim/bundle  
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim  

//color  
cd ~/.vim  
mkdir colors
cd colors
git clone https://github.com/tomasr/molokai
mv milokai/colors/molokai.vim ~/.vim/colors  


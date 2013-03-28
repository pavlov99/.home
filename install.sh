(
  [ ! -d $HOME/.home ] &&
  git clone git@github.com:pavlov99/.home.git &&
  cd $HOME/.home &&
  make && make install
) || ( 
  echo "remove your "$HOME"/.home directory" && exit 1
)

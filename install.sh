(
  [ -d $HOME/.home ] &&
  echo "remove your "$HOME"/.home directory" &&
  exit 1
) || ( 
  git clone https://github.com/pavlov99/.home.git &&
  cd $HOME/.home &&
  make && make install
)

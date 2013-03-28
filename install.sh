(
  [ -d $HOME/.home ] &&
  echo "remove your "$HOME"/.home directory first"
) || ( 
  git clone https://github.com/pavlov99/.home.git
)

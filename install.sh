apt-get install curl bash git-core mercurial

# Git settings
git config --global user.email "kirill.pavlov@phystech.edu"
git config --global user.name "Kirill Pavlov"

git config --global color.branch auto
git config --global color.diff auto
git config --global color.interactive auto
git config --global color.status auto

hg clone https://vim.googlecode.com/hg/ vim

# Install rvm and stable version of ruby for vim plugins
curl -L https://get.rvm.io | bash -s stable --ruby

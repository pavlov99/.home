USERNAME := "Kirill Pavlov"
EMAIL := "kirill.pavlov@phystech.edu"

__BASH_USERNAME__ := $(USERNAME)
__BASH_EMAIL__ := $(EMAIL)
__BASH_DEBFULLNAME__ := $(USERNAME)
__BASH_DEBEMAIL__ := $(EMAIL)
__GIT_NAME__ := $(USERNAME)
__GIT_EMAIL__ := $(EMAIL)

BINDIR=$(CURDIR)/bin
CONFIGDIR=$(CURDIR)/configs


all: clean bash $(HOME)/.gitconfig $(HOME)/.hgrc $(HOME)/.eslintrc $(HOME)/.smartcd $(HOME)/bin
	@git submodule init && git submodule update
	@echo "build is finished"

$(HOME)/.bashrc:
	cat dotfiles/bash/.bashrc \
	    | sed "s/__BASH_USERNAME__/"$(__BASH_USERNAME__)"/g" \
	    | sed "s/__BASH_EMAIL__/"$(__BASH_EMAIL__)"/g" \
	    | sed "s/__BASH_DEBFULLNAME__/"$(__BASH_DEBFULLNAME__)"/g" \
	    | sed "s/__BASH_DEBEMAIL__/"$(__BASH_DEBEMAIL__)"/g" > $(HOME)/.bashrc

$(HOME)/.bash_aliases:
	ln -s $(CURDIR)/dotfiles/bash/.bash_aliases $(HOME)/.

$(HOME)/.bash_profile:
	ln -s $(CURDIR)/dotfiles/bash/.bash_profile $(HOME)/.

$(HOME)/.bash_logout:
	ln -s $(CURDIR)/dotfiles/bash/.bash_logout $(HOME)/.

$(HOME)/.bash_login:
	ln -s $(CURDIR)/dotfiles/bash/.bash_login $(HOME)/.

bash: $(HOME)/.bashrc $(HOME)/.bash_aliases $(HOME)/.bash_login \
	$(HOME)/.bash_logout $(HOME)/.bash_profile

vim:
	rm -rf $(HOME)/.vim
	git clone git@github.com:pavlov99/.vim.git $(HOME)/.vim
	cd  $(HOME)/.vim && make && make install

$(HOME)/.gitconfig:
	cat $(CURDIR)/dotfiles/.gitconfig \
	    | sed "s/__GIT_NAME__/"$(__GIT_NAME__)"/g" \
	    | sed "s/__GIT_EMAIL__/"$(__GIT_EMAIL__)"/g" > $(HOME)/.gitconfig

$(HOME)/.hgrc:
	ln -s $(CURDIR)/dotfiles/.hgrc $(HOME)/.

$(HOME)/.eslintrc:
	ln -s $(CURDIR)/dotfiles/.eslintrc $(HOME)/.

$(HOME)/bin:
	mkdir -p $(HOME)/bin
	cp -r $(BINDIR)/* $(HOME)/bin

$(HOME)/.smartcd:
	@echo "Setup smartcd configuration"
	cp -r $(CONFIGDIR)/smartcd $(HOME)/.smartcd

clean:
	rm -rf $(HOME)/.bash_aliases
	rm -rf $(HOME)/.bash_login
	rm -rf $(HOME)/.bash_logout
	rm -rf $(HOME)/.bash_profile
	rm -rf $(HOME)/.bashrc
	rm -rf $(HOME)/.gitconfig
	rm -rf $(HOME)/.hgrc
	rm -rf $(HOME)/.eslintrc
	rm -rf $(HOME)/.smartcd

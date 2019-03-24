USERNAME := "Kirill Pavlov"
EMAIL := "k@p99.io"

__BASH_USERNAME__ := $(USERNAME)
__BASH_EMAIL__ := $(EMAIL)
__BASH_DEBFULLNAME__ := $(USERNAME)
__BASH_DEBEMAIL__ := $(EMAIL)
__GIT_NAME__ := $(USERNAME)
__GIT_EMAIL__ := $(EMAIL)

BINDIR=$(CURDIR)/bin
CONFIGDIR=$(CURDIR)/configs


all: clean bash $(HOME)/.gitconfig $(HOME)/.hgrc $(HOME)/bin
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

$(HOME)/.gitconfig:
	cat $(CURDIR)/dotfiles/.gitconfig \
	    | sed "s/__GIT_NAME__/"$(__GIT_NAME__)"/g" \
	    | sed "s/__GIT_EMAIL__/"$(__GIT_EMAIL__)"/g" > $(HOME)/.gitconfig

$(HOME)/.hgrc:
	cat $(CURDIR)/dotfiles/.hgrc \
	    | sed "s/__GIT_NAME__/"$(__GIT_NAME__)"/g" \
	    | sed "s/__GIT_EMAIL__/"$(__GIT_EMAIL__)"/g" > $(HOME)/.hgrc

$(HOME)/bin:
	mkdir -p $(HOME)/bin
	cp -r $(BINDIR)/* $(HOME)/bin

clean:
	rm -rf $(HOME)/.bash_aliases
	rm -rf $(HOME)/.bash_login
	rm -rf $(HOME)/.bash_logout
	rm -rf $(HOME)/.bash_profile
	rm -rf $(HOME)/.bashrc
	rm -rf $(HOME)/.gitconfig
	rm -rf $(HOME)/.hgrc


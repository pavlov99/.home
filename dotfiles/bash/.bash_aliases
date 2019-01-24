
# $HOME/.bash_aliases for bash-3.0 (or later)


# Common
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias less='less -r'

function trash () {
    if [ ! -d /tmp/.Trash ]; then
        mkdir /tmp/.Trash
    fi
    mv -f $1 /tmp/.Trash/.
}

# dir listing
alias ls='ls -FG'
alias la='ls -lah'
alias l='ls -CF'
alias lstree='ls -R | grep ":$" | sed -e '"'"'s/:$//'"'"' -e '"'"'s/[^-][^\/]*\//--/g'"'"' -e '"'"'s/^/   /'"'"' -e '"'"'s/-/|/'"'"

# deb packages
# alias dch='dch --distributor=debian'  # brakes dch in some cases
alias debinstall='sudo apt-get install --reinstall'
alias debinfo='apt-cache policy'
alias debclean='sudo apt-get autoremove && sudo apt-get autoclean'
alias debremove='sudo apt-get remove --purge'
alias debsearch='apt-cache search'
alias debupdate='sudo apt-get update && sudo apt-get upgrade'

alias vi='vim'
alias pbcopy='xclip -sel clip'

# Color ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

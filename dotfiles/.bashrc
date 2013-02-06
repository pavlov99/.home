# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# add local bin path
PATH=$HOME/bin:$PATH
PATH=/usr/local/bin:$PATH
PATH=/usr/local/sbin:$PATH
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export DEBFULLNAME="Kirill Pavlov"
export DEBEMAIL="kp@multichannel.net"
export HISTTIMEFORMAT="%h/%d - %H:%M:%S "
export LANG="en_US.UTF-8"

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=2000

# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# correct minor errors in the spelling of a directory component in a cd command
shopt -s cdspell
# save all lines of a multiple-line command in the same history entry (allows
# easy re-editing of multi-line commands)
shopt -s cmdhist

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# Color definition
# setup color variables
color_is_on=
color_red='\[\e[0;31m\]'
color_red_='\[\e[4;31m\]'
color_RED='\[\e[1;31m\]'
color_green=
color_yellow=
color_blue='\[\e[0;34m\]'
color_BLUE='\[\e[1;34m\]'
color_cyan='\[\e[0;36m\]'
color_cyan_='\[\e[4;36m\]'
color_CYAN='\[\e[1;36m\]'
color_white=
color_gray=
color_bg_red=
color_off='\[\e[0m\]'
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_is_on=true
	color_red="\[$(/usr/bin/tput setaf 1)\]"
	color_green="\[$(/usr/bin/tput setaf 2)\]"
	color_yellow="\[$(/usr/bin/tput setaf 3)\]"
	color_blue="\[$(/usr/bin/tput setaf 6)\]"
	color_white="\[$(/usr/bin/tput setaf 7)\]"
	color_gray="\[$(/usr/bin/tput setaf 8)\]"
	color_off="\[$(/usr/bin/tput sgr0)\]"
	color_error="$(/usr/bin/tput setab 1)$(/usr/bin/tput setaf 7)"
	color_error_off="$(/usr/bin/tput sgr0)"
fi

function get_xserver ()
{
    case $TERM in
        xterm )
            XSERVER=$(who am i | awk '{print $NF}' | tr -d ')''(' )
            XSERVER=${XSERVER%%:*}
            ;;
        aterm | rxvt)
        # your code here.....
            ;;
    esac
}

if [ -z ${DISPLAY:=""} ]; then
    get_xserver
    if [[ -z ${XSERVER}  || ${XSERVER} == $(hostname) || ${XSERVER} == "unix" ]]; then
        DISPLAY=":0.0"          # for localhost
    else
        DISPLAY=${XSERVER}:0.0  # remote host
    fi
fi
export DISPLAY

# get git status
function parse_git_status {
	# clear git variables
	GIT_BRANCH=
	GIT_DIRTY=

	# exit if no git found in system
	local GIT_BIN=$(which git 2>/dev/null)
	[[ -z $GIT_BIN ]] && return

	# check we are in git repo
	local CUR_DIR=$PWD
	while [ ! -d ${CUR_DIR}/.git ] && [ ! $CUR_DIR = "/" ]; do CUR_DIR=${CUR_DIR%/*}; done
	[[ ! -d ${CUR_DIR}/.git ]] && return

	# 'git repo for dotfiles' fix: show git status only in home dir and other git repos
	[[ $CUR_DIR == $HOME ]] && [[ $PWD != $HOME ]] && return

	# get git branch
	GIT_BRANCH=$($GIT_BIN symbolic-ref HEAD 2>/dev/null)
	[[ -z $GIT_BRANCH ]] && return
	GIT_BRANCH=${GIT_BRANCH#refs/heads/}

	# get git status
	local GIT_STATUS=$($GIT_BIN status --porcelain 2>/dev/null)
	[[ -n $GIT_STATUS ]] && GIT_DIRTY=1
}

function prompt_command {
	local PS1_GIT=
	local PS1_VENV=
	local PS1_TIME="[$(date +%H:%M:%S)]"
	local PWDNAME=$PWD

	# beautify working firectory name
	if [ $HOME == $PWD ]; then
		PWDNAME="~"
	elif [ $HOME ==  ${PWD:0:${#HOME}} ]; then
		PWDNAME="~${PWD:${#HOME}}"
	fi

	# parse git status and get git variables
	parse_git_status

	# build b/w prompt for git and vertial env
	[[ ! -z $GIT_BRANCH ]] && PS1_GIT=" (git: ${GIT_BRANCH})"
	[[ ! -z $VIRTUAL_ENV ]] && PS1_VENV=" (venv: ${VIRTUAL_ENV#$WORKON_HOME})"

	# calculate fillsize
	local fillsize=$(($COLUMNS-$(printf "${USER}@${HOSTNAME}:${PWDNAME}${PS1_GIT}${PS1_VENV}${PS1_TIME} " | wc -c | tr -d " ")))

	local FILL=$color_gray
	while [ $fillsize -gt 0 ]; do FILL="${FILL}─"; fillsize=$(($fillsize-1)); done
	FILL="${FILL}${color_off}"

	local color_user=
	if $color_is_on; then
		# set user color
		case `id -u` in
			0) color_user=$color_red ;;
			*) color_user=$color_green ;;
		esac

		# build git status for prompt
		if [ ! -z $GIT_BRANCH ]; then
			if [ -z $GIT_DIRTY ]; then
				PS1_GIT=" (git: ${color_green}${GIT_BRANCH}${color_off})"
			else
				PS1_GIT=" (git: ${color_red}${GIT_BRANCH}${color_off})"
			fi
		fi

		# build python venv status for prompt
		[[ ! -z $VIRTUAL_ENV ]] && PS1_VENV=" (venv: ${color_blue}${VIRTUAL_ENV#$WORKON_HOME}${color_off})"
	fi

	# set new color prompt
	PS1="${color_user}${USER}${color_off}@${color_yellow}${HOSTNAME}${color_off}:${color_white}${PWDNAME}${color_off}${PS1_GIT}${PS1_VENV} ${FILL}${PS1_TIME}\n➜ "

	# get cursor position and add new line if we're not in first column
	# cool'n'dirty trick (http://stackoverflow.com/a/2575525/1164595)
	# XXX FIXME: this hack broke ssh =(
#	exec < /dev/tty
#	local OLDSTTY=$(stty -g)
#	stty raw -echo min 0
#	echo -en "\033[6n" > /dev/tty && read -sdR CURPOS
#	stty $OLDSTTY
	echo -en "\033[6n" && read -sdR CURPOS
	[[ ${CURPOS##*;} -gt 1 ]] && echo "${color_error}↵${color_error_off}"

	# set title
	echo -ne "\033]0;${USER}@${HOSTNAME}:${PWDNAME}"; echo -ne "\007"
}

# set prompt command (title update and color prompt)
PROMPT_COMMAND=prompt_command
# set new b/w prompt (will be overwritten in 'prompt_command' later for color prompt)
PS1='\u@\h:\w\$ '

# python virtualenv
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
	export PROJECT_HOME=~/work/
	export WORKON_HOME=~/work/.venv/
	export VIRTUAL_ENV_DISABLE_PROMPT=1
	source /usr/local/bin/virtualenvwrapper.sh
fi



# Для начала определить некоторые цвета:
red='\[\e[0;31m\]'
red_='\[\e[4;31m\]'
RED='\[\e[1;31m\]'
blue='\[\e[0;34m\]'
BLUE='\[\e[1;34m\]'
cyan='\[\e[0;36m\]'
cyan_='\[\e[4;36m\]'
CYAN='\[\e[1;36m\]'
NC='\[\e[0m\]'              # No Color (нет цвета)

# Лучше выглядит на черном фоне.....
echo "${CYAN}bash ${RED}${BASH_VERSION%.*}${CYAN} - DISPLAY on ${RED}$DISPLAY${NC}" | sed -e 's/\\\[//g;s/\\\]//g;s/\\e/\x1b/g'
ncal -M


if [[ "${DISPLAY#$HOST}" != ":0.0" &&  "${DISPLAY}" != ":0" ]]; then
    HILIT=${cyan}   # на удаленной системе: prompt будет частично красным
else
    HILIT=${NC}     # на локальной системе: prompt будет частично циановым
fi







### Alias definitions. ###
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# dep packages
alias dch='dch --distributor=debian'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands. Use like so: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# # bash completion
# Mac OS
# if [ -f `brew --prefix`/etc/bash_completion ]; then
# 	. `brew --prefix`/etc/bash_completion
# fi

# this is for delete words by ^W
tty -s && stty werase ^- 2>/dev/null

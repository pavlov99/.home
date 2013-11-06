# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

[ -r "$HOME/.smartcd_config" ] && ( [ -n $BASH_VERSION ] || [ -n $ZSH_VERSION ] ) && source ~/.smartcd_config

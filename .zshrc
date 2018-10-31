OS="`uname`"
# auto: only use color when printing to stdout 
case $OS in
  'Linux')
    alias ls='ls -aF --color=auto'
    ;;
  'Darwin')
    alias ls='ls -aGF'
    ;;
  *) ;;
esac
alias grep='grep --color=auto'
alias startsddm='sudo systemctl start sddm'
export EDITOR='nvim'

# Appends every command to the history file once it is executed
setopt inc_append_history
# Reloads the history whenever you use it
setopt share_history

zmodload zsh/complist

#POWERLEVEL9K_MODE='awesome-fontconfig'
#POWERLEVEL9K_MODE='awesome-patched'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(vi_mode ram dir_writable dir vcs)
POWERLEVEL9K_VI_INSERT_MODE_STRING="\u03bb"
POWERLEVEL9K_VI_COMMAND_MODE_STRING="\u27a4"

case $OS in
  'Linux')
    eval `dircolors ~/.dircolors.256dark`
    ;;
  *) ;;
esac

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# allow v to edit the command line (standard behaviour)
zle -N edit-command-line
autoload -Uz edit-command-line
bindkey -M vicmd 'v' edit-command-line

# allow ctrl-p, ctrl-n for navigate history (standard behaviour)
bindkey '^P' up-history
bindkey '^N' down-history

# allow ctrl-r to perform backward search in history
bindkey '^r' history-incremental-search-backward

# update vi mode indicator (required by powerlevel9k vi-mode segment)
function zle-keymap-select() {
  zle reset-prompt
  zle -R
}
zle -N zle-keymap-select

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
# the following contradicts with vim-tmux-navigator
#bindkey "^K" up-line-or-beginning-search
#bindkey "^J" up-line-or-beginning-search

# menu completion
#zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' menu select
zstyle ':completion:*' menu select
# enable vi-style navigation keys in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'o' accept-line

bindkey '^F' autosuggest-accept

case $OS in
  'Linux')
    source ~/.zplug/init.zsh
    ;;
  'Darwin')
    source /usr/local/opt/zplug/init.zsh
    ;;
  *) ;;
esac

[[ -n "$SSH_CLIENT" || "$TERM" == "linux" ]] && \
  zplug "eendroroy/alien-minimal" || \
  zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

zplug  "zsh-users/zsh-autosuggestions", use:zsh-autosuggestions.zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load # --verbose
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

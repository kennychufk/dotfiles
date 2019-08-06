########## Environment detection
UNAME="`uname`"
WSL=false
SSH=false
[[ "$UNAME" == "Linux" ]] && grep -qE "(Microsoft|WSL)" /proc/version && \
  WSL=true
[[ -n "$SSH_CLIENT" || "$TERM" == "linux" ]] && \
  SSH=true

########## Alias / function
alias grep='grep --color=auto'
alias startsddm='sudo systemctl start sddm'
[ "$WSL" = true ] && \
  alias start='/mnt/c/Windows/System32/cmd.exe /c start'
# -a: only use color when printing to stdout 
case $UNAME in
  'Linux')
    alias ls='ls -aF --color=auto'
    ;;
  'Darwin')
    alias ls='ls -aGF'
    ;;
  *) ;;
esac
function ii(){
  powershell.exe -Command "ii $@"
}
function psh(){
  powershell.exe -Command $@
}
function pshf(){
  powershell.exe -File $@
}

########## Environment setting
[[ "$UNAME" == "Linux" ]] && eval `dircolors ~/.dircolors.256dark`

########## zsh options
# Appends every command to the history file once it is executed
setopt inc_append_history
# Reloads the history whenever you use it
setopt share_history
zmodload zsh/complist

########## Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v

########## Lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'
autoload -Uz compinit
compinit

########## VI mode
# allow v to edit the command line (standard behaviour)
zle -N edit-command-line
autoload -Uz edit-command-line
bindkey -M vicmd 'v' edit-command-line
# update vi mode indicator (required by powerlevel9k vi-mode segment)
function zle-keymap-select() {
  zle reset-prompt
  zle -R
}
zle -N zle-keymap-select

########## History navigation
# allow ctrl-p, ctrl-n for navigate history (standard behaviour)
bindkey '^P' up-history
bindkey '^N' down-history
# allow ctrl-r to perform backward search in history
bindkey '^r' history-incremental-search-backward

########## History searching
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

########## Menu completion
#zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' menu select
zstyle ':completion:*' menu select
# enable vi-style navigation keys in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'o' accept-line

source "${HOME}/.zgen/zgen.zsh"
########## powerlevel9k
zgen load bhilburn/powerlevel9k powerlevel9k
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(vi_mode ram dir_writable dir vcs)
if [ "$WSL" = true ] ; then
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(vi_mode dir_writable dir)
  POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status)
fi
if [ "$SSH" = true ] ; then
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(vi_mode dir_writable)
fi
POWERLEVEL9K_VI_INSERT_MODE_STRING="\u03bb"
POWERLEVEL9K_VI_COMMAND_MODE_STRING="\u27a4"

########## grey text as auto-suggestion
zgen load zsh-users/zsh-autosuggestions
bindkey '^F' autosuggest-accept
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

########## Environment variables
export WSL
export UNAME
export SSH
export PATH=/mnt/c/texlive/2018/bin/win32:$PATH
export PATH="/mnt/c/Program Files/SumatraPDF:$PATH"
export PATH="/mnt/c/Windows/System32:$PATH"
export PATH="/mnt/c/Windows/System32/WindowsPowerShell/v1.0:$PATH"
export PATH="/mnt/c/ProgramData/chocolatey/bin:$PATH"
export PATH="/usr/local/cuda-10.1/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda-10.1/lib64:$LD_LIBRARY_PATH"
export EDITOR='nvim'
export GIT_TERMINAL_PROMPT=1

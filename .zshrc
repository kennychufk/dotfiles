########## Environment detection
UNAME="`uname`"
UNAME_MACHINE="`uname -m`"
WSL=false
SSH=false
RPI=false
[[ "$UNAME" == "Linux" ]] && grep -qE "(Microsoft|WSL)" /proc/version && \
  WSL=true
[[ -n "$SSH_CLIENT" || "$TERM" == "linux" ]] && \
  SSH=true
[[ "$UNAME_MACHINE" == arm* ]] && \
  RPI=true

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
function cmdf(){
  cmd.exe /c $@
}
function mlenv(){
  cmd.exe /c "call activate.bat ml && $@"
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
# update vi mode indicator (required by powerlevel10k vi-mode segment)
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
########## powerlevel10k
zgen load romkatv/powerlevel10k powerlevel10k
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(vi_mode dir_writable dir)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status)
POWERLEVEL9K_VI_INSERT_MODE_STRING="\u03bb"
if [ "$WSL" = true ] ; then
  POWERLEVEL9K_VI_INSERT_MODE_STRING="\u03c9"
else
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS+=(ram vcs)
fi
if [ "$SSH" = true ] ; then
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS+=(context)
fi
POWERLEVEL9K_VI_COMMAND_MODE_STRING="\u03bd"

########## grey text as auto-suggestion
zgen load zsh-users/zsh-autosuggestions
bindkey '^F' autosuggest-accept
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

########## Environment variables
export WSL
export UNAME
export SSH
[[ "$WSL" = true ]] && export PATH=/mnt/c/texlive/2019/bin/win32:$PATH
[[ "$WSL" = true ]] && export PATH="/mnt/c/Program Files/SumatraPDF:$PATH"
[[ "$WSL" = true ]] && export PATH="/mnt/c/Windows/System32:$PATH"
[[ "$WSL" = true ]] && export PATH="/mnt/c/Windows/System32/WindowsPowerShell/v1.0:$PATH"
[[ "$WSL" = true ]] && export PATH="/mnt/c/ProgramData/chocolatey/bin:$PATH"
[[ "$UNAME" == "Linux" ]] && export PATH="/usr/local/cuda/bin:$PATH"
[[ "$UNAME" == "Darwin" ]] && export PATH=/opt/local/bin:/opt/local/sbin:$PATH # for MacPorts
[[ "$UNAME" == "Linux" ]] && export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
[[ "$UNAME" == "Linux" ]] && export PATH="/usr/local/texlive/2022/bin/x86_64-linux:$PATH"
[[ "$UNAME" == "Linux" ]] && export MANPATH="/usr/local/texlive/2022/texmf-dist/doc/man:$MANPATH"
[[ "$UNAME" == "Linux" ]] && export INFOPATH="/usr/local/texlive/2022/texmf-dist/doc/info:$INFOPATH"
export EDITOR='nvim'
export GIT_TERMINAL_PROMPT=1

# >>> conda initialize >>>
if [ "$RPI" = true ] ; then
  alias python=python3
  alias pip=pip3
  export VIRTUALENVWRAPPER_PYTHON=$(which python3)
  source "$HOME/.local/bin/virtualenvwrapper.sh"
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS+=(virtualenv)
else
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
          . "$HOME/miniconda3/etc/profile.d/conda.sh"
      else
          export PATH="$HOME/miniconda3/bin:$PATH"
      fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<
  [[ "$UNAME" == "Linux" ]] && conda activate ml
  [[ "$UNAME" == "Darwin" ]] && conda activate ml
fi

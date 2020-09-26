# Create subfolders as neccessary
alias 'mkdir=mkdir -p'


#########################
# History Configuration #
#########################
HISTSIZE=5000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000               #Number of history entries to save to disk
HISTDUP=erase               #Erase duplicates in the history file
HISTORY_IGNORE="(ls|[bf]g|exit|reset|clear|cd|cd ..|cd..)"
setopt    HIST_IGNORE_ALL_DUPS
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed

# Push Maxwell Rules to remote
alias update_maxwell='git push --set-upstream web master'

# Specify default editor. Possible values: vim, nano, ed etc.
export EDITOR=nvim

# Autocompletion
autoload -Uz compinit; compinit
zstyle ':completion:*' menu select

# Prepare to use pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Launch Starship (at the end of file)
eval "$(starship init zsh)"

# Prep fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

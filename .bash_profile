export CLICOLOR=1
export LSCOLORS=FxGACxDxCxegedabagacad
export EDITOR='vim'

export TERM='xterm-256color'

# Default machine type, used for picking colors for prompt, tmux colors
MACHINE_TYPE="desktop"

# Look for a file that contains this, should be set up by dotfiles install.sh
if [ -f "$HOME/.machine-type" ]; then
    MACHINE_TYPE=$(cat "$HOME/.machine-type")
fi


TMUX_STATUS_BG="light cyan"
TMUX_STATUS_FG="black"
PS1_HOST_COLOR="1;36m"

case $MACHINE_TYPE in
    "desktop")
        TMUX_STATUS_BG="cyan"
        TMUX_STATUS_FG=black
        PS1_HOST_COLOR="1;36m"
        ;;

    "server")
        TMUX_STATUS_BG=yellow
        TMUX_STATUS_FG=black
        PS1_HOST_COLOR="1;33m"
        ;;

    "home-server")
        TMUX_STATUS_BG="green"
        TMUX_STATUS_FG=black
        PS1_HOST_COLOR="1;32m"
        ;;

    "android")
        TMUX_STATUS_BG="magenta"
        TMUX_STATUS_FG=white
        PS1_HOST_COLOR="1;35m"
        ;;
esac

# Configure TMUX colors based on those vars just determined
if [ ! -z $TMUX ]; then
    tmux set-option -g status-bg "$TMUX_STATUS_BG"
    tmux set-option -g status-fg "$TMUX_STATUS_FG"
    tmux set-option -g pane-active-border-style "fg=$TMUX_STATUS_BG"
    tmux set-option -g window-status-current-format "#[bg=$TMUX_STATUS_FG,fg=$TMUX_STATUS_BG] #I:#W "
fi

# Make a directory and change to it
function mkcd() {
  mkdir -p $1
  cd $1
}

# Bookmark folders - thanks http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
export MARKPATH=$HOME/.marks
function jump { 
  cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark { 
  mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark { 
  rm -i "$MARKPATH/$1"
}
function marks {
  ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

_completemarks() {
  local curw=${COMP_WORDS[COMP_CWORD]}
  local wordlist=$(find $MARKPATH -type l -printf "%f\n")
  COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
  return 0
}

complete -F _completemarks jump j unmark

# PS1 status line with git status
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \1/'
}

parse_git_dirty() {
  _gst_output=$(git status --porcelain 2> /dev/null)
  _output=""
  if [[ ! "$_gst_output" = "" ]]; then
    if [[ ! $(git status --porcelain 2> /dev/null | grep ^\ M\ ) = "" ]]; then
      _output="M"
    fi
    if [[ ! $(git status --porcelain 2> /dev/null | grep ^??) = "" ]]; then
      _old_output=$_output
      _output="?$_old_output"
    fi
    if [[ ! $(git status --porcelain 2> /dev/null | grep ^Unmerged\ paths:) = "" ]]; then
      _old_output=$_output
      _output="%$_old_output"
    fi
    echo " $_output"
  fi
}

#Format a nice command line prefix including current git branch
PS1="\
\u\
\e[1;30m\]@\e[0m\
\e[$PS1_HOST_COLOR\h\e[0m \
\e[37m\w\e[0m\
\e[33m\$(parse_git_branch)\[\e[0m\
\e[31m\]\$(parse_git_dirty)\e[0m\
\n> "

# Documenting that:
# - username
# - @ symbol in subtle grey
# - hostname is color set by PS1_HOST_COLOR + space
# - working directory
# - git branch
# - And git status flags
# - newline and >

# Include any domain-specific additions from the ~/.bash_profile_ext folder
if [ -d "$HOME/.bash_profile_ext" ]; then
  for script in $HOME/.bash_profile_ext/*; do
    source $script
  done
fi

# useful productivity aliases
alias gitrmdeleted='git rm $(git ls-files --deleted)'
alias cdgitroot='cd $(git rev-parse --show-toplevel)'
alias invertscreen='xcalib -i -a'
alias j='jump'
alias m='mark'

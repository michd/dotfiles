export CLICOLOR=1
export LSCOLORS=FxGACxDxCxegedabagacad
export EDITOR='vim'

export TERM='xterm-256color'

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
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\|\1/'
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
    echo "|$_output"
  fi
}

#Format a nice command line prefix including current git branch
PS1="\033[01;36m\]\u\[\033[00m\]\[\033[01;30m\]@\h\[\033[00m\]:\[\033[00;37m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\]\[\033[00;31m\]\$(parse_git_dirty)\[\033[00m\]\n> "

# Include any domain-specific additions from the ~/.bash_profile_ext folder
if [ -d "$HOME/.bash_profile_ext" ]; then
  for script in $HOME/.bash_profile_ext/*; do
    source $script
  done
fi

# useful productivity aliases
alias gitrmdeleted='git rm $(git ls-files --deleted)'
alias invertscreen='xcalib -i -a'
alias j='jump'
alias m='mark'

export CLICOLOR=1
export LSCOLORS=FxGACxDxCxegedabagacad
export EDITOR='vim'

export TERM='xterm-256color'

quickscript() {
  local scriptName
  local keep="0"
  local startLine="2"
  mkdir -p ~/tmp

  if [ "$1" = "--help" ]; then
    cat <<- EOF
	usage: quickscript [--keep] [--last] [--clean] [--help]

	OPTIONS:
	    --keep   Don't discard script after execution. Re-edit with --keep afterwards.
	    --last   Edit and execute the last script you did with --keep
	    --clean  Delete all lingering quickscripts that you may have kept with --keep
	    --help   Show this help

	Examples:
	    Write script, execute, and discard:
	    quickscript
	        (edit the script, save and quit)

	    Write script, execute and keep for edits:
	    quickscript --keep
	        (edit the script, save and quit)

	    Edit last script saved with --keep, execute, and discard:
	    quickscript --last
	        (edit the script, save and quit)

	    Edit last script saved with --keep, execute, and keep for edits again:
	    quickscript --last --keep
	        (edit the script, save and quit)

	    Tidy up all quickscripts kept with --keep:
	    quickscript --clean
	EOF
    return
  fi

  if [ "$1" = "--clean" ]; then
    echo "Deleting any leftover quickscripts..."
    rm $HOME/tmp/quickscript-*
    echo "Done."
    return
  fi

  if [ "$1" = "--keep" ] || [ "$2" = "--keep" ]; then
    keep="1"
  fi

  if [ "$1" = "--last" ] || [ "$2" = "--last" ]; then
    if [ -f "$HOME/tmp/quickscript-last" ]; then
      scriptName="$(cat "$HOME/tmp/quickscript-last")"
      rm $HOME/tmp/quickscript-last
    else
      echo "No maintained script found."
      return
    fi
  else
    scriptName="quickscript-$(date +%s)"
    if [ "$keep" = "1" ]; then
      echo -e "#!/bin/bash\n" > "$HOME/tmp/$scriptName"
    else
      echo -e "#!/bin/bash\n# Note: this file will be executed and then deleted.\n# Save it elsewhere if you want to keep it and use --keep next time.\n# See \`quickscript --help\` for details.\n" > "$HOME/tmp/$scriptName"
      startLine="5"
    fi
  fi

  vim +"$startLine" "$HOME/tmp/$scriptName"

  chmod +x $HOME/tmp/$scriptName

  $HOME/tmp/./$scriptName

  if [ ! "$1" = "--keep" ] && [ ! "$2" = "--keep" ]; then
    rm $HOME/tmp/$scriptName
  else
    echo "$scriptName" > $HOME/tmp/quickscript-last
  fi
}

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
complete -F _completemarks jump unmark

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
PS1="\[\033[01;36m\]\u\[\033[00m\]\[\033[01;30m\]@\h\[\033[00m\]:\[\033[00;37m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\]\[\033[00;31m\]\$(parse_git_dirty)\[\033[00m\]\n>> "

# useful productivity aliases
alias canhas="sudo apt-get install"
alias cd..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../../"
alias ..4="cd ../../../../"
alias ..5="cd ../../../../../"
alias ..6="cd ../../../../../../"
alias gitrmdeleted='git rm $(git ls-files --deleted)'
alias clear='echo "You know better than that. (Ctrl+L)"'
alias invertscreen='xcalib -i -a'

alias qs='quickscript'

alias e=$EDITOR

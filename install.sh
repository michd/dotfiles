#!/bin/bash

dotfiles="$(pwd)/"
destination="$HOME/"

main() {
  pushd $destination

  make_symlink ".gitconfig"
  make_symlink ".vimrc"
  make_symlink ".bash_profile"
  make_symlink ".tmux.conf"
  make_symlink ".vim"
  make_symlink ".dotfile-assets"

  read -p "Install .config folder? (Y/n): " config_yn
  if [ $(is_yes "$config_yn") = true ]; then
    make_symlink ".config"

    echo "Would you like to assemble an i3 config now?"
    echo "If not, go to ~/.config/i3 and run ./make-i3-config later."
    read -p "Make i3 config? (Y/n): " conf_yn

    if [ $(is_yes "$conf_yn") = true ]; then
      pushd ".config/i3"
      ./make-i3-config
      popd
    else
      "Skipped making i3 config file"
    fi
  else
    echo "Skipped .config folder."
  fi

  read -p "Install ruby-related dotfiles? (Y/n): " ruby_yn

  if [ $(is_yes "$ruby_yn") = true ]; then
    make_symlink ".irbrc"
    make_symlink ".gemrc"
  else
    echo "Skipped ruby-related dotfiles."
  fi

  echo "source ~/.bash_profile" >> .bashrc

  popd
  echo "Dotfiles installed."
}

make_symlink() {
  local symlinkName=$1
  local originPath="$dotfiles""$1"
  local destPath="./$1"

  if [ -L "$destPath" ]; then
    # A symlink already exists like this

    if [ "$(readlink $destPath)" -ef "$originPath" ]; then
      # It points at the thing we were going to point it at anyway, so never
      # mind.
      echo "$destPath was already symlinked, skipping."
    else
      resolve_file_conflict $symlinkName
    fi

  elif [ -d "$destPath" ]; then
    # A directory with this name already exists

    resolve_conflict $1 "folder"

  elif [ -f "$destPath" ]; then
    # Destination file already exists, ask what to do

    resolve_conflict $1 "file"

  else
    # No conflicting existing file

    ln -s "$originPath" ./
    echo "Installed symlink $destPath"

  fi
}

resolve_conflict() {
  local symlinkName=$1
  local type=$2
  local originPath="$dotfiles""$1"
  local destPath="./$1"

  echo "$type $destPath already exists. What would you like to do?"
  echo "(O)verwrite, renaming the $type as backup, (K)eep existing $type,"
  echo "(A)bort further installation"
  read -p "Default = Overwrite; your choice: " conflict_a

  if [ -z "$conflict_a" ] || [ "o" = "$conflict_a" ] \
    || [ "O" = "$conflict_a" ]; then

    # Overwrite option
    echo "Backing up existing $type $destPath as $destPath.bak"
    mv "$destPath" "$destPath.bak"
    echo "Adding symlink for $destPath"
    ln -s "$originPath" ./

    if [ "$type" = "folder" ]; then
      echo "
IMPORTANT: since an existing folder was moved, please manually ensure any of
its contents are copied or moved to the appropriate place."
    fi

  elif [ "k" = "$conflict_a" ] || [ "K" = "$conflict_a" ]; then

    # Keep option
    echo "Keeping existing $type $destPath as-is."

  elif [ "a" = "$conflict_a" ] || [ "A" = "$conflict_a" ]; then

    # Abort option
    echo "Aborting further installation, $destPath kept as-is."
    exit 1

  else

    # User didn't enter anything sensible
    echo "Invalid input; keeping existing $type $destPath as-is."

  fi
}

is_yes() {
  if [ -z "$1" ] || [ "y" = "$1" ] || [ "Y" = "$1" ]; then
    echo true
  else
    echo false
  fi
}

# Invoke main function
main


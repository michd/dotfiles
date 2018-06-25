#!/bin/bash

dotfiles="$(pwd)/"
pushd $HOME
ln -s "$dotfiles"".gitconfig" ./
ln -s "$dotfiles"".vimrc" ./
ln -s "$dotfiles"".bash_profile" ./
ln -s "$dotfiles"".tmux.conf" ./
ln -s "$dotfiles"".vim/" ./
ln -s "$dotfiles"".irbrc" ./
ln -s "$dotfiles"".gemrc" ./

echo "source ~/.bash_profile" >> .bashrc
popd
echo "Dotfiles installed."

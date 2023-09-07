#!/bin/bash

# Install
sudo apt install -y zsh vim neofetch gcc make nasm python3 python3-pip

# Setup zsh
chsh -s $(which zsh)
cp .zshrc ~/.zshrc

# Setup vim
cp .vimrc ~/.vimrc




#!/bin/bash

set -e

echo "Starting dotfiles installation..."

if ! command -v npm &> /dev/null; then
    echo "npm is not installed. Please install npm first."
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "git is not installed. Please install git first."
    exit 1
fi

if ! command -v fortune &> /dev/null; then
    echo "fortune is not installed. Please install fortune first."
    exit 1
fi

echo "Installing yarn globally..."
npm i -g yarn@latest

echo "Cloning dotfiles repository..."
git clone git@github.com:dorukozerr/dotfiles.git ~/kawaiDotfiles

backup_dir="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
echo "Creating backup directory at $backup_dir"
mkdir -p "$backup_dir"

for file in ~/.vim ~/.vimrc ~/.config/tmux ~/.scripts ~/.zshrc; do
    if [ -e "$file" ]; then
        echo "Backing up $file"
        mv "$file" "$backup_dir/"
    fi
done

echo "Setting up Vim..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "source ~/kawaiDotfiles/vim/config/plugins.vim" > ~/.vimrc

echo "Installing Vim plugins..."
TERM=xterm-256color vim -E -s -u ~/.vimrc +PlugInstall +qall || true

echo "Installing CoC extensions..."
TERM=xterm-256color vim -E -s -u ~/.vimrc -c 'CocInstall -sync coc-tsserver coc-eslint coc-vimlsp coc-json coc-css @yaegassy/coc-tailwindcss3 coc-go' -c 'qall!' || true

echo "Setting up full Vim configuration..."
mv ~/kawaiDotfiles/vim/* ~/.vim

echo "Cleaning up preinstall vimrc file"
rm ~/.vimrc

echo "Setting up airline theme..."
mv ~/.vim/keta.vim ~/.vim/plugged/vim-airline-themes/autoload/airline/themes

echo "Setting up Tmux..."
mkdir -p ~/.config
mv ~/kawaiDotfiles/tmux ~/.config/

echo "Setting up scripts..."
mv ~/kawaiDotfiles/scripts ~/.scripts
chmod +x ~/.scripts/commit.sh
chmod +x ~/.scripts/lazygrep.sh

echo "Setting up Zsh..."
mv ~/kawaiDotfiles/zsh/.zshrc ~/

echo "Cleaning up..."
rm -rf ~/kawaiDotfiles

echo "Installation complete! A backup of your previous configuration can be found in $backup_dir"
echo "Please restart your terminal for all changes to take effect."
#!/bin/bash

set -e
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

echo "=> Starting dotfiles installation..."

echo "=> Installing yarn globally..."
npm i -g yarn@latest > /dev/null

echo "=> Cloning dotfiles repository..."
git clone git@github.com:dorukozerr/dotfiles.git ~/kawaiDotfiles &> /dev/null

backup_dir="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "=> Creating backup directory at $backup_dir"
mkdir -p "$backup_dir"
for file in ~/.vim ~/.vimrc ~/.config/tmux ~/.scripts ~/.zshrc ~/.zprofile ~/.gitconfig ~/.config/wezterm; do
    if [ -e "$file" ]; then
        echo "=> Backing up $file"
        mv "$file" "$backup_dir/"
    fi
done

echo "=> Setting up Tmux..."
mkdir -p ~/.config
mv ~/kawaiDotfiles/tmux ~/.config/

echo "=> Setting up scripts..."
mv ~/kawaiDotfiles/scripts ~/.scripts
chmod +x ~/.scripts/commit.sh
chmod +x ~/.scripts/lazy_grep.sh
chmod +x ~/.scripts/update_vim_plugins.sh
chmod +x ~/.scripts/kill_process.sh
chmod +x ~/.scripts/tmux_save_session.sh
chmod +x ~/.scripts/tmux_restore_session.sh

echo "=> Setting up Zsh..."
mv ~/kawaiDotfiles/zsh/.zshrc ~/
mv ~/kawaiDotfiles/zsh/.zprofile ~/

echo "=> Setting up WezTerm..."
mv ~/kawaiDotfiles/wezterm ~/.config

echo "=> Setting up .gitconfig"
mv ~/kawaiDotfiles/git/.gitconfig ~/

echo "=> Setting up temp Vim config"
mkdir -p ~/.vim/pack/plugins/start

cat > ~/.vim/temp.vimrc << 'EOF'
set nocompatible
set hidden
set updatetime=100
let g:coc_disable_startup_warning = 1
EOF

cd ~/.vim/pack/plugins/start

echo "=> Setting up Vim plugins..."
git clone https://github.com/tpope/vim-fugitive.git &> /dev/null
git clone https://github.com/junegunn/fzf.git &> /dev/null
git clone https://github.com/junegunn/fzf.vim.git &> /dev/null
git clone https://github.com/neoclide/coc.nvim.git &> /dev/null
git clone https://github.com/vim-airline/vim-airline.git &> /dev/null
git clone https://github.com/vim-airline/vim-airline-themes.git &> /dev/null
git clone https://github.com/ryanoasis/vim-devicons.git &> /dev/null
git clone git@github.com:dorukozerr/kisuke.vim.git &> /dev/null
git clone https://github.com/MaxMEllon/vim-jsx-pretty.git &> /dev/null
git clone https://github.com/Konfekt/FastFold.git &> /dev/null
git clone git@github.com:adelarsq/vim-matchit.git &> /dev/null
git clone https://github.com/mg979/vim-visual-multi.git &> /dev/null
echo "=> Vim plugins base installation finished..."

cd coc.nvim
echo "=> Finishing CoC installation..."
npm ci &> /dev/null
cd ..
cd fzf
echo "=> Finishing FZF installation..."
./install --all &> /dev/null
cd ..
cd kisuke.vim
echo "=> Building Kisuke..."
yarn build &> /dev/null
cd ~

echo "=> Installing CoC extensions..."
yes | vim -u ~/.vim/temp.vimrc -c 'CocInstall -sync coc-vimlsp coc-sh coc-tsserver coc-go coc-html coc-css @yaegassy/coc-tailwindcss3 coc-json coc-yaml coc-prettier coc-eslint coc-dotenv coc-sql coc-lua coc-svg' -c 'qall!' > /dev/null 2>&1

echo "=> Setting up full Vim configuration..."
mv ~/kawaiDotfiles/vim/* ~/.vim
mv ~/.vim/keta.vim ~/.vim/pack/plugins/start/vim-airline-themes/autoload/airline/themes
mv ~/.vim/psychosis.vim ~/.vim/pack/plugins/start/vim-airline-themes/autoload/airline/themes

echo "=> Cleaning up..."
rm ~/.vim/temp.vimrc
rm -rf ~/kawaiDotfiles

echo "=> Installation complete! A backup of your previous configuration can be found in $backup_dir"
echo "=> Please restart your terminal or source config files"

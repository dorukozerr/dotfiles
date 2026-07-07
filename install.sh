#!/usr/bin/env bash
#
# Doruk Özer <dorukozer@protonmail.com>
# ---
# - relatively lite setup for vim, zsh, tmux, wezterm, i3 WM for arch and git,
# + some shell scripts.
# - vim, tmux, zsh plugins added as submodules, after clone they detach from
# dotfiles repo

set -e

BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
DOTFILES_DIR="$HOME/kawaiDotfiles"
PLUGINS_ROOT_PATHS=( 
  $HOME/.config/tmux/plugins
  $HOME/.config/zsh/plugins
  $HOME/.vim/pack/plugins/start
)

detach_submodule() {
  mkdir -p "$(dirname "$2")"
  mv "$DOTFILES_DIR/$1" "$2"
  rm "$2/.git"
  mv "$DOTFILES_DIR/.git/modules/$1" "$2/.git"
  git config --file "$2/.git/config" --unset core.worktree
}

finalize_plugins() {
  for ROOT_DIR in ${PLUGINS_ROOT_PATHS[@]}; do
    for PLUGIN in $(\ls -d "$ROOT_DIR/"*); do
      git -C $PLUGIN switch - 2>&1 &
    done
  done
  wait
  COC="$HOME/.vim/pack/plugins/start/coc.nvim"
  bun install --cwd $COC && bun run --cwd $COC build
}

main() {
  [ -d "$DOTFILES_DIR" ] && rm -rf "$DOTFILES_DIR"

  git clone git@github.com:dorukozerr/dotfiles.git "$DOTFILES_DIR" --depth 1
  git -C "$DOTFILES_DIR" submodule update --init --depth 1

  mkdir -p "$BACKUP_DIR"

  for file in \
    "$HOME/.zshenv" "$HOME/.zprofile" "$HOME/.zshrc" \
    "$HOME/.config/zsh/.zprofile" "$HOME/.config/zsh/.zshrc" \
    "$HOME/.config/zsh/zsh.d" "$HOME/.config/zsh/plugins" \
    "$HOME/.gitconfig" "$HOME/.vim" "$HOME/.vimrc" \
    "$HOME/.config/tmux" "$HOME/.config/wezterm" \
    "$HOME/.config/htop" "$HOME/.scripts"; \
  do
    [ -e "$file" ] && mv "$file" "$BACKUP_DIR/"
  done

  cd "$(dirname "$DOTFILES_DIR")"

  for pair in \
    "vim/pack/plugins/start:$HOME/.vim/pack/plugins/start" \
    "zsh/plugins:$HOME/.config/zsh/plugins" \
    "tmux/plugins:$HOME/.config/tmux/plugins"; \
  do
    src="${pair%%:*}"; dest="${pair##*:}"

    for d in "$DOTFILES_DIR/$src"/*/; do
      p=$(basename "$d")
      detach_submodule "$src/$p" "$dest/$p"
    done
  done

  chmod +x "$DOTFILES_DIR/scripts/bin/"*

  mkdir -p "$HOME/.local/bin/"
  mkdir -p "$HOME/.config/zsh/"

  mv "$DOTFILES_DIR/scripts/bin/"* "$HOME/.local/bin"
  mv "$DOTFILES_DIR/git/.gitconfig" "$DOTFILES_DIR/zsh/.zshenv" "$HOME/"
  mv "$DOTFILES_DIR/zsh/.zshrc" "$DOTFILES_DIR/zsh/zsh.d" "$HOME/.config/zsh/"
  mv "$DOTFILES_DIR/wezterm" "$DOTFILES_DIR/htop" "$HOME/.config/"
  mv "$DOTFILES_DIR/tmux/snapshot.conf" "$DOTFILES_DIR/tmux/tmux.conf" "$DOTFILES_DIR/tmux/tmux-nerd-font-window-name.yml" "$HOME/.config/tmux/"
  mv "$DOTFILES_DIR/vim/coc-settings.json" "$DOTFILES_DIR/vim/vimrc" "$DOTFILES_DIR/vim/config" "$HOME/.vim/"

  yes | vim -c "CocInstall -sync coc-vimlsp coc-sh coc-tsserver coc-go coc-html coc-css @yaegassy/coc-tailwindcss3 coc-json coc-yaml coc-prettier coc-eslint coc-dotenv coc-sql coc-lua coc-toml coc-svg coc-zshell coc-oxc coc-pyright coc-snippets" -c "qall!"

  rm -f "$HOME/.vim/temp.vimrc" && rm -rf "$DOTFILES_DIR" && cd

  finalize_plugins

  echo "done"
}

main

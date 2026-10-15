#!/usr/bin/env bash
#
# Doruk Özer <dorukozer@protonmail.com>
#
# vim, tmux, zsh plugins added as submodules, after clone they detach from
# dotfiles repo

set -euo pipefail

BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
DOTFILES_DIR="$(mktemp -d)"
LOG_DIR="$DOTFILES_DIR/.install-logs"

trap 'rm -rf "$DOTFILES_DIR"' EXIT

PLUGINS=(
  "vim/pack/plugins/start:$HOME/.vim/pack/plugins/start"
  "zsh/plugins:$HOME/.config/zsh/plugins"
  "tmux/plugins:$HOME/.config/tmux/plugins"
)

CONFIGS=(
  "git/.gitconfig:$HOME/.gitconfig"
  "zsh/.zshenv:$HOME/.zshenv"
  "zsh/.zshrc:$HOME/.config/zsh/.zshrc"
  "zsh/.zprofile:$HOME/.config/zsh/.zprofile"
  "vim/vimrc:$HOME/.vim/vimrc"
  "vim/config:$HOME/.vim/config"
  "vim/coc-settings.json:$HOME/.vim/coc-settings.json"
  "tmux/tmux.conf:$HOME/.config/tmux/tmux.conf"
  "tmux/snapshot.conf:$HOME/.config/tmux/snapshot.conf"
  "tmux/tmux-nerd-font-window-name.yml:$HOME/.config/tmux/tmux-nerd-font-window-name.yml"
  "wezterm:$HOME/.config/wezterm"
  "htop:$HOME/.config/htop"
  "sketchybar:$HOME/.config/sketchybar"
  "skhd:$HOME/.config/skhd"
)

# backed up as a whole (stale leftovers) or legacy locations, listed before
# CONFIGS/PLUGINS targets so parent dirs move first
EXTRA_BACKUPS=(
  "$HOME/.vim"
  "$HOME/.config/tmux"
  "$HOME/.vimrc"
  "$HOME/.zshrc"
  "$HOME/.zprofile"
  "$HOME/.scripts"
)

COC_EXTENSIONS=(
  coc-vimlsp coc-sh coc-tsserver coc-go coc-html coc-css
  @yaegassy/coc-tailwindcss3 coc-json coc-yaml coc-prettier coc-eslint
  coc-dotenv coc-sql coc-lua coc-toml coc-svg coc-zshell coc-oxc coc-pyright
  coc-snippets coc-rust-analyzer
)

detach_submodule() {
  mkdir -p "$(dirname "$2")"
  mv "$DOTFILES_DIR/$1" "$2"
  rm "$2/.git"
  mv "$DOTFILES_DIR/.git/modules/$1" "$2/.git"
  git config --file "$2/.git/config" --unset core.worktree
}

git clone git@github.com:dorukozerr/dotfiles.git "$DOTFILES_DIR" --depth 1
git -C "$DOTFILES_DIR" submodule update --init --depth 1

mkdir -p "$LOG_DIR"
mkdir -p "$BACKUP_DIR"

for file in "${EXTRA_BACKUPS[@]}" "${CONFIGS[@]##*:}" "${PLUGINS[@]##*:}"; do
  [[ -e $file || -L $file ]] || continue
  rel="${file#"$HOME"/}"
  mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
  mv "$file" "$BACKUP_DIR/$rel"
done

for pair in "${PLUGINS[@]}"; do
  src="${pair%%:*}"; dest="${pair##*:}"
  for d in "$DOTFILES_DIR/$src"/*/; do
    p="$(basename "$d")"
    detach_submodule "$src/$p" "$dest/$p"
  done
done

pids=(); names=()
for pair in "${PLUGINS[@]}"; do
  for plugin in "${pair##*:}"/*/; do
    plugin="${plugin%/}"
    git -C "$plugin" switch - >"$LOG_DIR/$(basename "$plugin").log" 2>&1 &
    # git -C "$plugin" fetch --unshallow
    pids+=("$!"); names+=("$plugin")
  done
done

failed=()
for i in "${!pids[@]}"; do
  wait "${pids[$i]}" || failed+=("${names[$i]}")
done

if (( ${#failed[@]} )); then
  echo "branch switch failed for ${#failed[@]} plugin(s):" >&2
  for plugin in "${failed[@]}"; do
    echo "  $plugin" >&2
    sed 's/^/    /' "$LOG_DIR/$(basename "$plugin").log" >&2
  done
  read -rp "continue anyway? [y/N] " answer </dev/tty || answer=n
  [[ $answer == [yY]* ]] || exit 1
fi

for pair in "${CONFIGS[@]}"; do
  src="${pair%%:*}"; dest="${pair##*:}"
  mkdir -p "$(dirname "$dest")"
  mv "$DOTFILES_DIR/$src" "$dest"
done

mkdir -p "$HOME/.local/bin"
chmod +x "$DOTFILES_DIR/scripts/bin/"*
mv "$DOTFILES_DIR/scripts/bin/"* "$HOME/.local/bin/"

COC="$HOME/.vim/pack/plugins/start/coc.nvim"
bun install --cwd "$COC" && bun run --cwd "$COC" build

{ yes || :; } | vim -c "CocInstall -sync ${COC_EXTENSIONS[*]}" -c "qall!"

echo "done, backup at $BACKUP_DIR"

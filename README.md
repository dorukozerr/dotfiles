# Dotfiles

```bash
brew install stow
git clone --recurse-submodules --shallow-submodules \
  https://github.com/dorukozerr/dotfiles.git ~/Repositories/personal/dotfiles
cd ~/Repositories/personal/dotfiles
mkdir -p ~/.config ~/.local/bin # so stow links into these instead of replacing them
stow */
```

https://github.com/user-attachments/assets/9a1e50a4-641a-4013-bfe3-900a2ef55d6d

`.stowrc` sets `--dotfiles --target=~`. Stow aborts without touching anything
if a file is already in the way, move it out and rerun.

## Layout

Every top-level dir is a [GNU Stow](https://www.gnu.org/software/stow/)
package that mirrors `$HOME`, with `dot-` standing in for a leading `.`:

```
zsh/dot-zshenv              -> ~/.zshenv
zsh/dot-config/zsh/.zshrc   -> ~/.config/zsh/.zshrc
```

```bash
stow -R zsh                             # relink a package
stow -D zsh                             # unlink it
git submodule update --remote --depth 1 # bump plugins
```

if [ -d "/opt/homebrew/share/zsh/site-functions" ]; then
    FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"
fi

if [ -d "${ASDF_DATA_DIR:-$HOME/.asdf}/completions" ]; then
    fpath=("${ASDF_DATA_DIR:-$HOME/.asdf}/completions" $fpath)
fi

if [ -d "$HOME/.local/share/zsh-comp" ]; then
    fpath=("$HOME/.local/share/zsh-comp" $fpath)
fi

if [ -d "$HOME/.bun" ]; then
    fpath=("$HOME/.bun" $fpath)
fi

fpath=(/Users/suqoi/.docker/completions $fpath)

autoload -Uz compinit

for dump in ~/.zcompdump(N.mh+24); do
    compinit
done

compinit -C

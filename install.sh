#!/bin/bash

# Source personal dotfiles
for f in ~/.dotfiles/personal/*.sh; do
    [[ -f "$f" ]] && echo "source $f" >> ~/.bashrc
done

# Source work dotfiles conditionally
if [[ -d ~/.dotfiles/work ]]; then
    for f in ~/.dotfiles/work/*.sh; do
        [[ -f "$f" ]] && echo "source $f" >> ~/.bashrc
    done
fi

# Same for zsh if it exists
[[ -f ~/.zshrc ]] && {
    for f in ~/.dotfiles/personal/*.sh; do
        [[ -f "$f" ]] && echo "source $f" >> ~/.zshrc
    done
    if [[ -d ~/.dotfiles/work ]]; then
        for f in ~/.dotfiles/work/*.sh; do
            [[ -f "$f" ]] && echo "source $f" >> ~/.zshrc
        done
    fi
}

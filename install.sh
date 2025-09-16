#!/bin/bash

# Source personal dotfiles
for f in ~/.dotfiles/personal/*.sh; do
    [[ -f "$f" ]] && echo "source $f" >> ~/.bashrc
done

# Source work dotfiles
for f in ~/.dotfiles/work/*.sh; do
    [[ -f "$f" ]] && echo "source $f" >> ~/.bashrc
done

# Same for zsh if it exists
[[ -f ~/.zshrc ]] && {
    for f in ~/.dotfiles/personal/*.sh; do
        [[ -f "$f" ]] && echo "source $f" >> ~/.zshrc
    done
    for f in ~/.dotfiles/work/*.sh; do
        [[ -f "$f" ]] && echo "source $f" >> ~/.zshrc
    done
}

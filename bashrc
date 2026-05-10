# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# bun
export BUN_INSTALL="$HOME/.bun"
[[ -d "$BUN_INSTALL/bin" ]] && export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# direnv
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook bash)"

# Personal dotfiles — sourced last so they can override anything above
for f in "$HOME/.dotfiles/personal/"*.sh; do
    [[ -f "$f" ]] && source "$f"
done

# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
if [[ -d "$ZSH" ]]; then
    ZSH_THEME="robbyrussell"
    plugins=(git)
    source "$ZSH/oh-my-zsh.sh"
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Auto-switch Node when entering a folder with .nvmrc (and back to default when leaving)
load-nvmrc() {
  local nvmrc_path="$(nvm_find_nvmrc)"            # nearest .nvmrc, searching upward
  if [ -n "$nvmrc_path" ]; then
    local wanted="$(nvm version "$(cat "$nvmrc_path")")"
    if [ "$wanted" = "N/A" ]; then
      nvm install                                  # pinned version isn't installed yet
    elif [ "$wanted" != "$(nvm version)" ]; then
 nvm use    
fi
  elif [ "$(nvm version)" != "$(nvm version default)" ]; then
    nvm use default                                # left a pinned project: back to default
  fi
}
autoload -U add-zsh-hook # load zsh's built-in hook helper
add-zsh-hook chpwd load-nvmrc # run load-nvmrc after every directory change
load-nvmrc # ...and run it once right now

# bun
export BUN_INSTALL="$HOME/.bun"
[[ -d "$BUN_INSTALL/bin" ]] && export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# direnv
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# Personal dotfiles — sourced last so they can override anything above
for f in "$HOME/.dotfiles/personal/"*.sh; do
    [[ -f "$f" ]] && source "$f"
done

# pnpm
export PNPM_HOME="/Users/christopherlong/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="/Users/christopherlong/.gdvm/bin/current_godot:/Users/christopherlong/.gdvm/bin:$PATH"
export PATH="$HOME/bin:$PATH"

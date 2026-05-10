#!/usr/bin/env bash
#
# Idempotent installer. Safe to re-run.
# Symlinks shell config and ~/.dotfiles into place; sets up ~/.gitconfig
# without overwriting existing identity.

set -euo pipefail

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

log()  { printf '\033[1;34m[install]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[install]\033[0m %s\n' "$*"; }

detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "mac" ;;
        Linux*)
            if grep -qi microsoft /proc/version 2>/dev/null; then
                echo "wsl"
            else
                echo "linux"
            fi
            ;;
        *) echo "unknown" ;;
    esac
}

# Replace $dst with a symlink to $src. Backs up any existing non-matching target.
symlink_safe() {
    local src="$1" dst="$2"

    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        log "ok    $dst -> $src"
        return
    fi

    if [[ -e "$dst" || -L "$dst" ]]; then
        local backup="${dst}.backup-${TIMESTAMP}"
        log "backup $dst -> $backup"
        mv "$dst" "$backup"
    fi

    ln -sfn "$src" "$dst"
    log "link  $dst -> $src"
}

ensure_dotfiles_symlink() {
    local target="$HOME/.dotfiles"

    if [[ -L "$target" && "$(readlink "$target")" == "$DOTFILES_DIR" ]]; then
        log "ok    $target -> $DOTFILES_DIR"
        return
    fi

    if [[ -e "$target" || -L "$target" ]]; then
        local backup="${target}.backup-${TIMESTAMP}"
        log "backup $target -> $backup"
        mv "$target" "$backup"
    fi

    ln -sfn "$DOTFILES_DIR" "$target"
    log "link  $target -> $DOTFILES_DIR"
}

# Three-case install for ~/.gitconfig:
#   - missing       -> copy from template, prompt user to fill identity
#   - has include   -> no-op
#   - lacks include -> append include, leave existing identity intact
setup_gitconfig() {
    local target="$HOME/.gitconfig"
    local template="$DOTFILES_DIR/personal/gitconfig.local.template"
    local marker="path = ~/.dotfiles/personal/.gitconfig"

    if [[ ! -f "$target" ]]; then
        cp "$template" "$target"
        log "create ~/.gitconfig from template"
        warn "      -> fill in [user] name and email in ~/.gitconfig"
        return
    fi

    if grep -qF "$marker" "$target"; then
        log "ok    ~/.gitconfig already includes dotfiles preferences"
        return
    fi

    cat >> "$target" <<'EOF'

[include]
	path = ~/.dotfiles/personal/.gitconfig
EOF
    log "patch ~/.gitconfig (appended [include]; identity preserved)"
}

install_shell_files() {
    symlink_safe "$DOTFILES_DIR/zshrc"    "$HOME/.zshrc"
    symlink_safe "$DOTFILES_DIR/bashrc"   "$HOME/.bashrc"
    symlink_safe "$DOTFILES_DIR/zprofile" "$HOME/.zprofile"
    symlink_safe "$DOTFILES_DIR/zshenv"   "$HOME/.zshenv"
}

main() {
    local os
    os="$(detect_os)"
    log "repo: $DOTFILES_DIR"
    log "os:   $os"

    ensure_dotfiles_symlink

    case "$os" in
        mac)
            install_shell_files
            ;;
        wsl|linux)
            warn "WSL/Linux path stubbed for Phase 1. Mac is the primary target."
            warn "TODO: install apt packages, decide which shell files apply."
            install_shell_files
            ;;
        *)
            warn "unsupported OS: $(uname -s). skipping shell-file install."
            ;;
    esac

    setup_gitconfig

    log "done. open a new shell to pick up changes."
}

main "$@"

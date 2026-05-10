# dotfiles

Reproducible personal-environment setup for macOS (WSL and devcontainer support coming later). One command turns a fresh Mac into a working machine — and re-running it is always safe.

## Quick start

```bash
git clone git@github.com:cvalong/dotfiles.git ~/dev/dotfiles
~/dev/dotfiles/install.sh
```

After install, edit `~/.gitconfig` and fill in your name and email.

## What `install.sh` does

- Symlinks `~/.dotfiles` to wherever you cloned the repo
- Symlinks `~/.zshrc`, `~/.bashrc`, `~/.zprofile`, `~/.zshenv` to the committed shell files (existing files backed up to `~/.<name>.backup-<timestamp>`)
- Sets up `~/.gitconfig` with three-case logic:
  - missing → copies from template, prompts you to fill in identity
  - already references the dotfiles include → no-op
  - exists without the include → appends `[include]`, leaves your identity untouched
- Idempotent: running it twice does nothing the second time

The script never overwrites your `~/.gitconfig` once it has identity in it. Re-running on an existing machine is safe.

## Layout

```
dotfiles/
├── install.sh          # idempotent installer, OS-aware
├── zshrc               # symlinked to ~/.zshrc
├── bashrc              # symlinked to ~/.bashrc
├── zprofile            # symlinked to ~/.zprofile
├── zshenv              # symlinked to ~/.zshenv
├── Brewfile            # `brew bundle install` packages
└── personal/
    ├── .gitconfig                    # universal git preferences (no identity)
    ├── gitconfig.local.template      # template copied to ~/.gitconfig on first install
    ├── functions.sh                  # `rebase_onto`, `delete_merged_branches`
    └── aliases.sh
```

## Design principles

- **Symlinks for everything.** Edit a file in this repo, change applies everywhere. No drift between repo and `$HOME`.
- **Identity stays out of the repo.** `personal/.gitconfig` carries aliases and behavior; the per-machine `~/.gitconfig` shim carries name/email. Same idea as `.env.example` vs `.env.local`.
- **Idempotent install.** Codespaces re-runs `install.sh` on every container spin-up, so non-idempotency is a real bug, not a smell.
- **Re-runnable everywhere.** Existing files get backed up before being replaced. Existing `~/.gitconfig` identity is never overwritten.

## Roadmap

- [ ] Phase 1.5 — SSH commit signing (`gpg.format=ssh`)
- [ ] Phase 2 — wire `brew bundle install` into `install.sh`; capture editor settings/extensions
- [ ] Phase 3 — capture `~/.config/{nvim,ghostty}`, `.tmux.conf`, `.ssh/config`
- [ ] Phase 4 — Codespaces / devcontainer integration
- [ ] Phase 5 — Windows / WSL support (chezmoi for cross-OS templating if needed)

## License

[MIT](LICENSE)

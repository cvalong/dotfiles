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

## Day-to-day usage

Most edits don't require re-running `install.sh` — symlinks mean every change is immediately live. Just reload your shell.

| Change | What to run |
|---|---|
| Edit a symlinked file (`zshrc`, `personal/functions.sh`, etc.) | `exec zsh` (or open a new tab) |
| Edit `personal/.gitconfig` | nothing — git reads it on every invocation |
| Add a new file under `personal/*.sh` | `exec zsh` — the glob picks it up |
| Edit `Brewfile` | `brew bundle install --file=~/.dotfiles/Brewfile` (add `--cleanup --force` to also uninstall removed entries) |
| Add a new top-level config file (e.g. `tmux.conf`) | edit `install.sh` to add a `symlink_safe` call, then re-run it |

The mental model: **`install.sh` is for structural changes** (the set of symlinks the installer manages). **Content changes are immediate** — just reload.

### Syncing across machines

```bash
cd ~/.dotfiles
git pull
brew bundle install --file=Brewfile   # if Brewfile changed
exec zsh                              # if any shell file changed
~/.dotfiles/install.sh                # only if install.sh / file set changed
```

### Iterating on a single file

```bash
$EDITOR ~/.dotfiles/personal/functions.sh
source ~/.dotfiles/personal/functions.sh   # reload just this file
# test in current shell, commit when satisfied
```

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
    └── functions.sh                  # `rebase_onto`, `delete_merged_branches`
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

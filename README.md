# Mac Setup 2026

Automated Mac setup for developers with AI coding agents. Designed for Intel MacBook Pro but works on Apple Silicon too.

## What's Included

**CLI Tools**: git, gh, delta, fd, fzf, bat, tmux, htop, ffmpeg, ripgrep, wget, tree, pnpm

**Shell**: Oh My Zsh + Powerlevel10k + autosuggestions + syntax-highlighting + you-should-use

**Runtimes**: Node.js (via fnm), Python (via uv)

**Editors**: Cursor, VS Code (optional)

**AI Agents**: Claude Code, Codex CLI, Gemini CLI, Hermes Agent

**Apps**: Warp, Raycast, Obsidian, Stats, Tailscale, AlDente, TablePlus, Bitwarden, AppCleaner, VLC, Arc, Ice

## Quick Start

```bash
git clone https://github.com/mnttnm/mac-setup-2026.git
cd mac-setup-2026
./setup.sh
```

The script is interactive — it will ask before each phase and skip what's already installed.

## Manual Quick Start (Brewfile only)

If you just want the apps and CLI tools:

```bash
brew bundle --file=Brewfile
```

## Files

| File | Purpose |
|------|---------|
| `setup.sh` | Main automated setup script |
| `Brewfile` | Homebrew packages and casks |
| `dotfiles/.zshrc` | Shell config with plugins, aliases, fnm |
| `dotfiles/.gitconfig` | Git defaults (delta, rebase, main branch) |
| `dotfiles/.fzf.zsh` | fzf shell integration |
| `macos-defaults.sh` | macOS system preference tweaks |
| `GUIDE.md` | Full checklist guide with all steps |

## Customization

1. Edit `Brewfile` to add/remove packages
2. Edit `dotfiles/.zshrc` to change aliases and plugins
3. Edit `macos-defaults.sh` to change system preferences
4. Edit `setup.sh` to skip phases you don't need

## Reproduce on a New Mac

1. Install Xcode CLI Tools: `xcode-select --install`
2. Install Homebrew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
3. Clone and run:
   ```bash
   git clone https://github.com/mnttnm/mac-setup-2026.git
   cd mac-setup-2026
   ./setup.sh
   ```

## Always-On Agent Runner

If using this Mac as a 24/7 agent runner (Hermes, OpenClaw, etc.):

```bash
# Prevent sleep on AC power
sudo pmset -c disablesleep 1 && sudo pmset -c sleep 0 && sudo pmset -c displaysleep 5 && sudo pmset -c autorestart 1

# Start agents in tmux
tmux new-session -d -s hermes "hermes start"
tmux new-session -d -s claude "claude"

# Reattach later
tmux attach -t hermes
```

Use AlDente to cap charging at 80% and Tailscale for remote SSH access.

## License

MIT

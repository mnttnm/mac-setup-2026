# Mac Setup Guide 2026 — Checklist Edition
### For: Intel MacBook Pro 16" (2019) · 16 GB RAM · macOS 26 Tahoe
### Terminal: Warp · No Local AI · No Docker

*Compiled from the most popular setup guides of 2025–2026, tailored for this machine.*

---

## How to Use This Guide

- Work through each phase in order — later phases depend on earlier ones
- `[x]` = completed, `[ ]` = still pending / do when needed
- Items marked `[SKIP]` are excluded for your hardware/preferences
- Commands are copy-paste ready

---

## Phase 1: System Preferences
*Time: ~10 min · No installs needed*

### Dock & Desktop
- [x] Move Dock to the left: `System Settings → Desktop & Dock → Position on screen → Left`
- [x] Enable auto-hide: `System Settings → Desktop & Dock → Automatically hide and show the Dock`
- [x] Remove all default apps from Dock (right-click → Options → Remove from Dock) — keep only Finder

### Keyboard & Input
- [x] Disable autocorrect: `System Settings → Keyboard → Input Sources → Edit… → disable all corrections`
- [x] Set fast key repeat (run in terminal):
  ```bash
  defaults write NSGlobalDomain KeyRepeat -int 1
  defaults write NSGlobalDomain InitialKeyRepeat -int 10
  ```
- [x] Log out and back in for key repeat settings to take effect

### Trackpad
- [x] Enable tap to click: `System Settings → Trackpad → Tap to Click`
- [ ] (Optional) Disable "Natural" scrolling if you prefer traditional direction

### Finder
- [x] Show filename extensions: `Finder → Settings → Advanced → Show all filename extensions`
- [x] Show path bar: `Finder → View → Show Path Bar`
- [x] Learn the shortcut: `Cmd + Shift + .` toggles hidden files in any Finder window

### Display
- [x] Disable True Tone: `System Settings → Displays → True Tone → Off`

### Accessibility (macOS 26 Tahoe)
- [x] Reduce Liquid Glass transparency: `System Settings → Accessibility → Display → Reduce Transparency`

### Spotlight
- [x] Disable all Spotlight categories except Applications and System Settings (Raycast will replace it)
- [x] `System Settings → Spotlight → Search Results` — uncheck everything except those two
- [ ] Add indexing exclusions to reduce CPU overhead: `System Settings → Spotlight → Privacy` — add:
  - `~/node_modules`
  - Any `dist`, `.next`, `build` directories
  - `~/.hermes`

### Energy (Important for your battery)
- [x] `System Settings → Battery → Options → Optimized Battery Charging → On`
- [x] Keep the machine plugged in whenever possible (battery at 80.8% health, 1015 cycles)

### Performance Tweaks (Intel-specific)
- [x] Reduce GPU work for snappier UI:
  ```bash
  defaults write com.apple.universalaccess reduceMotion -bool true
  ```

---

## Phase 2: Foundation
*Time: ~15 min · Requires internet*

### Xcode Command Line Tools
- [x] Installed ✓

### Homebrew
- [x] Installed (v5.1.2) ✓
- [x] Intel Mac — Homebrew installed to `/usr/local` ✓

### Essential CLI tools
- [x] All installed via `brew install git gh ripgrep fd fzf bat jq tree wget htop tmux` ✓

  | Tool | Version | Why |
  |------|---------|-----|
  | `git` | 2.53.0 | Version control |
  | `gh` | 2.89.0 | GitHub CLI |
  | `ripgrep` | 15.1.0 | Fast code search — used by Claude Code & Hermes |
  | `fd` | 10.4.2 | Fast file finder (better `find`) |
  | `fzf` | 0.70.0 | Fuzzy finder — `Ctrl+R` for history search |
  | `bat` | 0.26.1 | Better `cat` with syntax highlighting |
  | `tmux` | 3.6a | Keep agent sessions alive after disconnect |
  | `htop` | 3.4.1 | Interactive process viewer |
  | `jq` | 1.7.1 | JSON parsing from the terminal |
  | `tree` | 2.3.2 | Directory tree view |
  | `wget` | 1.25.0 | File downloader |

- [x] ffmpeg 8.1 installed (needed by Hermes Agent) ✓
- [x] git-delta 0.19.2 installed (better git diffs) ✓
- [x] pnpm 10.33.0 installed ✓
- [x] fzf key bindings configured (`Ctrl+R`, `Ctrl+T`, `Alt+C`) ✓

---

## Phase 3: Terminal & Shell
*Time: ~15 min*

### Warp Terminal
- [x] Installed via brew ✓
- [x] Signed in ✓
- [x] Set as default terminal ✓

### Oh My Zsh
- [x] Installed ✓

### Zsh Plugins
- [x] zsh-autosuggestions ✓
- [x] zsh-syntax-highlighting ✓
- [x] you-should-use ✓
- [x] Plugins enabled in `~/.zshrc`:
  ```bash
  plugins=(git git-prompt zsh-autosuggestions zsh-syntax-highlighting you-should-use)
  ```

### Theme: Powerlevel10k
- [x] Installed ✓
- [x] Configured via `p10k configure` ✓
- [x] MesloLGS Nerd Font installed ✓
- [x] Warp font set to MesloLGS NF ✓
- [x] Instant prompt set to `quiet` to suppress warnings ✓

### Shell Aliases
- [x] Configured in `~/.zshrc` ✓:
  ```bash
  alias ll='ls -alF'
  alias la='ls -A'
  alias gs='git status'
  alias gc='git commit'
  alias gp='git push'
  alias gpl='git pull'
  alias gco='git checkout'
  alias gd='git diff'
  alias glog='git log --oneline --graph --decorate -20'
  ```

---

## Phase 4: Git & GitHub
*Time: ~10 min*

### Git Configuration
- [x] Identity set: `mnttnm` / `mohittater.iiita@gmail.com` ✓
- [x] Defaults set: `init.defaultBranch=main`, `pull.rebase=true` ✓
- [x] Delta configured as git pager (side-by-side diffs) ✓

### SSH Key for GitHub
- [x] Ed25519 key generated ✓
- [x] Added to GitHub ✓
- [x] Connection tested: `Hi mnttnm!` ✓

### GitHub CLI
- [x] Authenticated as `mnttnm` ✓

---

## Phase 5: Programming Languages & Runtimes
*Time: ~10 min*

### Node.js via fnm
- [x] fnm 1.39.0 installed ✓
- [x] Node v24.14.1 installed and set as default ✓
- [x] `eval "$(fnm env --use-on-cd)"` added to `~/.zshrc` ✓
- [x] pnpm 10.33.0 installed ✓

### Python via uv
- [x] uv 0.11.2 installed (from Hermes setup) ✓

### Rust (Optional — install when needed)
- [ ] Install Rust:
  ```bash
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  ```

### Go (Optional — install when needed)
- [ ] Install Go:
  ```bash
  brew install go
  ```

---

## Phase 6: Code Editors
*Time: ~10 min*

### Cursor (Primary — AI-native IDE)
- [x] Installed ✓
- [ ] Enable CLI: `Cmd + Shift + P` → "Install 'cursor' command in PATH"
- [x] Signed in for AI features ✓
- [ ] Install key extensions:
  - [ ] GitLens
  - [ ] Prettier
  - [ ] ESLint
  - [ ] Error Lens
  - [ ] Thunder Client (API testing)

### VS Code (Optional — backup/specific workflows)
- [ ] Install:
  ```bash
  brew install --cask visual-studio-code
  ```

### Key Cursor Shortcuts to Learn
| Shortcut | Action |
|----------|--------|
| `Cmd + K` | Generate or edit code inline |
| `Cmd + L` | Chat with AI about your codebase |
| `Cmd + I` | Composer — multi-file edits |
| `@folder` | Reference entire folders for context |

---

## Phase 7: AI Coding Tools
*Time: ~10 min*

### Claude Code (Terminal AI Agent)
- [x] Installed (v2.1.87) ✓
- [x] Authenticated ✓

### Codex CLI (OpenAI)
- [x] Installed (v0.117.0) ✓
- [ ] Run `codex` and sign in (requires ChatGPT Plus/Pro or `OPENAI_API_KEY`)

### Gemini CLI (Google — generous free tier)
- [x] Installed ✓
- [ ] Run `gemini` and sign in with Google account
- [ ] Free tier: 60 requests/min, 1000 requests/day

### GitHub Copilot (Optional)
- [ ] Install the extension in Cursor: search "GitHub Copilot" in extensions
- [ ] Sign in with your GitHub account

### Hermes Agent
- [x] Installed (v0.6.0) ✓
- [x] Setup completed ✓

### API Keys Quick Reference

| Agent | Env Var / Config | Where to get it |
|-------|-----------------|-----------------|
| Claude Code | `ANTHROPIC_API_KEY` or login | console.anthropic.com |
| Codex CLI | `OPENAI_API_KEY` or ChatGPT login | platform.openai.com |
| Gemini CLI | `GEMINI_API_KEY` or Google login | aistudio.google.com/apikey |
| Hermes | Keys in `~/.hermes/.env` | Varies by configured channels |

### The 2026 AI Coding Workflow

| Task | Tool |
|------|------|
| Writing new code | Cursor (`Cmd+K`) |
| Multi-file refactors | Claude Code or Cursor Composer |
| Complex debugging | Claude Code |
| Quick autocomplete | Copilot or Cursor Tab |
| Architecture decisions | Claude Code |
| Git operations | Claude Code |

---

## Phase 8: Containers & Cloud
*Time: ~5 min · Install only what you need*

### [SKIP] Docker / OrbStack / Colima
> Skipped — 16GB Intel Mac. Use cloud services or remote dev environments instead.
> If you ever need containers, **OrbStack** (`brew install --cask orbstack`) is the lightest option for Intel Macs.

### Cloud CLIs (Install as needed)
- [ ] AWS CLI:
  ```bash
  brew install awscli
  aws configure
  ```
- [ ] Google Cloud SDK:
  ```bash
  brew install --cask google-cloud-sdk
  gcloud init
  ```
- [ ] Azure CLI:
  ```bash
  brew install azure-cli
  az login
  ```

---

## Phase 9: Databases
*Time: ~5 min · Install only what your projects need*

### PostgreSQL (Most common)
- [ ] Install:
  ```bash
  brew install postgresql@16
  brew services start postgresql@16
  ```

### Redis
- [ ] Install:
  ```bash
  brew install redis
  brew services start redis
  ```

### Database GUI
- [x] TablePlus installed ✓

---

## Phase 10: Productivity & Utilities
*Time: ~15 min*

### Raycast (Essential — Spotlight replacement)
- [x] Installed ✓
- [x] Hotkey set to `Option + Space` ✓
- [x] Clipboard History enabled ✓
- [x] Window Management enabled ✓

### Note-Taking
- [x] Obsidian installed ✓

### System Monitoring
- [x] Stats installed ✓

### Menubar Cleanup
- [x] Ice installed ✓

### App Cleanup
- [x] AppCleaner installed ✓

### Screenshot Tool
- [ ] Install Shottr (screenshot + OCR): download from [shottr.cc](https://shottr.cc/)

### Media
- [x] VLC installed ✓

### Voice Input (Optional — 2026 trend)
- [ ] Wispr Flow — AI-powered voice dictation
- [ ] VoiceInk — Local whisper-based voice input

---

## Phase 11: Browser Setup
*Time: ~5 min*

### Primary Browser
- [x] Arc installed ✓

### Recommended Extensions
- [ ] uBlock Origin — ad blocker
- [ ] Bitwarden — password autofill
- [ ] Video Speed Controller — speed up any video
- [ ] Refined GitHub — better GitHub UI
- [ ] React DevTools (if doing React work)
- [ ] Privacy Badger — tracker blocking

---

## Phase 12: Security & Passwords
*Time: ~5 min*

### Password Manager
- [x] Bitwarden installed ✓

### GPG Commit Signing (Optional)
- [ ] Install GPG:
  ```bash
  brew install gpg
  ```
- [ ] Generate a key:
  ```bash
  gpg --full-generate-key
  ```
- [ ] Configure Git to sign commits:
  ```bash
  gpg --list-secret-keys --keyid-format=long
  git config --global user.signingkey YOUR_KEY_ID
  git config --global commit.gpgsign true
  ```

---

## Phase 13: Remote Access
*Time: ~10 min*

### Tailscale (Access your Mac from anywhere)
- [x] Installed ✓
- [x] Signed in ✓
- [x] Remote Login enabled: `System Settings → General → Sharing → Remote Login → On`
- [x] SSH accessible from any Tailscale-connected device ✓

---

## Phase 14: Always-On Agent Runner (Intel Desktop Mode)
*Time: ~10 min · For running agents 24/7 while plugged in*

### Battery Management
- [x] AlDente installed ✓
- [x] Charge limit set to 80% ✓

### Prevent Sleep (when plugged in)
- [x] Power management configured ✓:
  ```bash
  sudo pmset -c disablesleep 1       # prevent sleep on AC power
  sudo pmset -c sleep 0              # never sleep on AC
  sudo pmset -c displaysleep 5       # display sleeps after 5 min (agents keep running)
  sudo pmset -c autorestart 1        # auto-restart after power failure
  ```

### Running Agents in tmux
- [ ] Start persistent agent sessions:
  ```bash
  # Start Hermes in background
  tmux new-session -d -s hermes "hermes start"

  # Start any other agent
  tmux new-session -d -s claude "claude"

  # Reattach later
  tmux attach -t hermes

  # List all sessions
  tmux ls
  ```

### Tips for Always-On Operation
- AlDente at 80% since it stays plugged in permanently
- Use Safari over Chrome when browsing on battery (lower power draw)
- Monitor thermals via Stats menubar app
- Tailscale + SSH lets you manage agents from your phone or another machine

---

## Phase 15: Backup & Dotfiles
*Time: ~10 min*

### Dotfiles Repo
- [x] Created at `~/dotfiles` ✓
- [x] Contains: `.zshrc`, `.gitconfig`, `.p10k.zsh`, `.fzf.zsh`, `Brewfile` ✓
- [ ] Push to GitHub:
  ```bash
  cd ~/dotfiles && gh repo create dotfiles --private --source=. --push
  ```

---

## Phase 16: Brewfile for Future Reinstalls
*Time: ~2 min*

- [x] Brewfile generated and saved to `~/dotfiles/Brewfile` ✓
- [ ] To reinstall everything on a new machine:
  ```bash
  brew bundle --file=~/Brewfile
  ```

---

## What Was Skipped (and Why)

| Item | Reason |
|------|--------|
| Local AI / Ollama / LM Studio | Intel Mac — no unified memory, CPU-only inference is impractical |
| Docker / OrbStack / Colima | 16GB RAM constraint; use cloud or install OrbStack later if needed |
| Ghostty / iTerm2 | Warp with subscription |
| Zed editor | Less benefit on Intel; Cursor covers AI-native editing |

---

## Post-Setup Verification

Run these to confirm everything is working:

```bash
echo "=== Homebrew ===" && brew --version
echo "=== Git ===" && git --version
echo "=== Node ===" && node --version
echo "=== pnpm ===" && pnpm --version
echo "=== Python ===" && python3 --version
echo "=== uv ===" && uv --version
echo "=== gh ===" && gh --version | head -1
echo "=== Claude Code ===" && claude --version
echo "=== Codex ===" && codex --version 2>/dev/null || echo "Not installed"
echo "=== Gemini ===" && which gemini > /dev/null 2>&1 && echo "Installed" || echo "Not installed"
echo "=== ripgrep ===" && rg --version | head -1
echo "=== fd ===" && fd --version
echo "=== bat ===" && bat --version | head -1
echo "=== delta ===" && delta --version
echo "=== tmux ===" && tmux -V
echo "=== fzf ===" && fzf --version
echo "=== Hermes ===" && hermes --version 2>/dev/null || echo "Run: hermes setup"
echo "=== Tailscale ===" && tailscale version 2>/dev/null || echo "Not installed"
```

---

## Quick Reference: What Goes Where

| Config | File |
|--------|------|
| Shell config | `~/.zshrc` |
| Git config | `~/.gitconfig` |
| SSH keys | `~/.ssh/` |
| Powerlevel10k | `~/.p10k.zsh` |
| Hermes Agent | `~/.hermes/` |
| Homebrew | `/usr/local/` (Intel) |
| fnm Node versions | `~/.local/state/fnm/` |
| uv Python envs | `.venv/` per project |
| Dotfiles backup | `~/dotfiles/` |
| Brewfile | `~/dotfiles/Brewfile` |

---

*Sources: [Syntackle](https://syntackle.com/blog/mac-setup-for-developers/), [swyx](https://www.swyx.io/new-mac-setup), [jonathansblog](https://jonathansblog.co.uk/setting-up-the-perfect-mac-development-environment-in-2026), [VibeCheetah](https://vibecheetah.com/blog/complete-guide-ai-coding-tools-2026), [TLDL](https://www.tldl.io/resources/ai-coding-tools-2026), [marc0.dev](https://www.marc0.dev/en/blog/ai-agents/openclaw-mac-mini-the-complete-guide-to-running-your-own-ai-agent-in-2026-1770057455419), [sb2nov/mac-setup](https://github.com/sb2nov/mac-setup)*

# New Mac Setup Guide — Dev + AI Agent Runner

A progressive setup guide for an Intel Mac used for fullstack JS/Node development
and as an always-on AI agent runner (Claude Code, Codex CLI, Gemini CLI, Hermes, OpenClaw).

---

## Phase 1: Foundation

### Homebrew (package manager)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Git & GitHub CLI
```bash
brew install git gh
git config --global user.name "Mohit Tater"
git config --global user.email "your@email.com"
git config --global core.pager delta
git config --global init.defaultBranch main
gh auth login
```

---

## Phase 2: Languages & Runtimes

### Node.js (via mise — version manager)
```bash
brew install mise
mise use --global node@22    # Node 22+ required by OpenClaw, works for everything else
```

### Python (needed by Hermes)
Hermes installs its own Python 3.11 via `uv`, but if you need a system Python:
```bash
mise use --global python@3.12
```

---

## Phase 3: Core CLI Tools

```bash
brew install ripgrep fd fzf jq bat delta curl wget tmux
```

| Tool     | Why                                              |
|----------|--------------------------------------------------|
| ripgrep  | Fast code search — used by Claude Code & Hermes  |
| fd       | Fast file finder                                 |
| fzf      | Fuzzy finder for terminal                        |
| jq       | JSON parsing (agents use this)                   |
| bat      | Better `cat` with syntax highlighting            |
| delta    | Better git diffs                                 |
| curl/wget| HTTP requests, downloading files                 |
| tmux     | Keep agent sessions alive after SSH disconnect   |

### Optional (Hermes recommends)
```bash
brew install ffmpeg    # for TTS/voice messages in Hermes
```

---

## Phase 4: Editor & Browser

```bash
brew install --cask visual-studio-code
brew install --cask google-chrome    # needed for Puppeteer/Playwright headless browsing
```

---

## Phase 5: AI Coding Agents

### Claude Code
```bash
npm install -g @anthropic-ai/claude-code
```
Requires `ANTHROPIC_API_KEY` env var or login via `claude` command.

### Codex CLI (OpenAI)
```bash
npm install -g @openai/codex
```
Requires ChatGPT Plus/Pro/Business account or `OPENAI_API_KEY`.
Run `codex` and follow the sign-in prompt.

### Gemini CLI (Google)
```bash
npm install -g @google/gemini-cli
```
Run `gemini` and sign in with Google account (free tier: 60 req/min, 1000 req/day).
Or set `GEMINI_API_KEY` from https://aistudio.google.com/apikey.

### Hermes Agent
```bash
curl -fsSL https://hermes.bot/install | bash
```
**Auto-installs the following into `~/.hermes/`:**
- uv (Python package manager) + Python 3.11
- Node.js 22 (its own copy)
- Playwright Chromium + FFmpeg
- hermes-agent v0.6.0 + 79 Python packages
- 96 bundled skills

**Config files:**
- `~/.hermes/.env` — API keys
- `~/.hermes/config.yaml` — configuration
- `~/.hermes/SOUL.md` — personality
- `~/.hermes/skills/` — skill definitions

### OpenClaw
```bash
# Install via the official installer (requires Node 22+)
# Visit https://github.com/openclaw/openclaw for latest instructions
npx openclaw init
```
**Requirements:** Node.js 22.16+, 2GB RAM minimum (16GB recommended).
Runs as a persistent Node.js daemon.

---

## Phase 6: Productivity & Remote Access

### Raycast (Spotlight replacement)
```bash
brew install --cask raycast
```

### Tailscale (remote access)
```bash
brew install --cask tailscale
```
After install, open Tailscale and sign in. Then enable SSH on the Mac:
**System Settings → General → Sharing → Remote Login → On**

Access from anywhere: `ssh mohit@<tailscale-hostname>`

---

## Phase 7: Intel Mac — Battery & Performance

### Apps
```bash
brew install --cask aldente                # cap charge at 80% for battery longevity
brew install --cask turbo-boost-switcher   # disable Turbo Boost = less heat, more battery
brew install --cask stats                  # menubar system monitor
```

### macOS performance tweaks
```bash
# Faster key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Reduce GPU work
defaults write com.apple.universalaccess reduceTransparency -bool true
defaults write com.apple.universalaccess reduceMotion -bool true
```

### Spotlight exclusions (reduce indexing overhead)
Go to **System Settings → Spotlight → Privacy** and add:
- `~/node_modules`
- Any `dist`, `.next`, `build` directories
- `~/.hermes`

---

## Phase 8: Always-On Agent Runner Config

### Prevent sleep (when plugged in)
```bash
sudo pmset -c disablesleep 1
sudo pmset -c sleep 0
sudo pmset -c displaysleep 5     # display sleeps after 5 min (agents keep running)
sudo pmset -c autorestart 1      # auto-restart after power failure
```

### Running agents in tmux
```bash
# Start a named session
tmux new-session -d -s hermes "hermes start"
tmux new-session -d -s openclaw "openclaw start"

# Reattach later
tmux attach -t hermes

# List sessions
tmux ls
```

### Tips for always-on operation
- Set AlDente charge cap to **80%** since it will be plugged in permanently
- Use **Safari over Chrome** when browsing on battery (lower power draw)
- Disable Turbo Boost via Turbo Boost Switcher when not running heavy builds
- Monitor thermals via Stats menubar app

---

## Quick Reference: API Keys Needed

| Agent       | Env Var / Config                     | Where to get it                          |
|-------------|--------------------------------------|------------------------------------------|
| Claude Code | `ANTHROPIC_API_KEY`                  | console.anthropic.com                    |
| Codex CLI   | `OPENAI_API_KEY` or ChatGPT login    | platform.openai.com                      |
| Gemini CLI  | `GEMINI_API_KEY` or Google login     | aistudio.google.com/apikey               |
| Hermes      | Keys in `~/.hermes/.env`            | Varies by configured channels            |
| OpenClaw    | Configured during `openclaw init`   | github.com/openclaw/openclaw             |

---

## Post-Install Checklist

- [ ] Run `gh auth login` to authenticate GitHub
- [ ] Enable Remote Login in System Settings
- [ ] Set up Tailscale and log in
- [ ] Set AlDente charge cap to 80%
- [ ] Add Spotlight privacy exclusions
- [ ] Configure API keys for each agent
- [ ] Test agents: `claude`, `codex`, `gemini`, `hermes`, `openclaw`
- [ ] Set up tmux sessions for always-on agents

#!/usr/bin/env bash
# Mac Setup 2026 — Automated Setup Script
# Usage: ./setup.sh
#
# This script is interactive — it asks before each phase.
# It detects what's already installed and skips accordingly.
# Safe to run multiple times (idempotent).

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Helpers ---

info()  { echo -e "${BLUE}→${NC} $1"; }
ok()    { echo -e "${GREEN}✓${NC} $1"; }
warn()  { echo -e "${YELLOW}⚠${NC} $1"; }
fail()  { echo -e "${RED}✗${NC} $1"; }

ask() {
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}  $1${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "Proceed? [Y/n] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]
}

has() { command -v "$1" &>/dev/null; }
has_app() { [ -d "/Applications/$1.app" ]; }

# --- Phase 1: Xcode CLI Tools ---

if ! xcode-select -p &>/dev/null; then
    if ask "Phase 1: Install Xcode Command Line Tools?"; then
        xcode-select --install
        echo "Waiting for Xcode CLI tools to install... Press Enter when done."
        read -r
    fi
else
    ok "Xcode CLI Tools already installed"
fi

# --- Phase 2: Homebrew ---

if ! has brew; then
    if ask "Phase 2: Install Homebrew?"; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add to PATH for Apple Silicon
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        ok "Homebrew installed"
    fi
else
    ok "Homebrew already installed ($(brew --version | head -1))"
fi

# --- Phase 3: Brewfile (CLI tools + GUI apps) ---

if ask "Phase 3: Install packages from Brewfile? (CLI tools + GUI apps)"; then
    brew bundle --file="$SCRIPT_DIR/Brewfile" || warn "Some packages may have failed (this is often OK)"
    ok "Brewfile packages installed"

    # Setup fzf key bindings
    if [ -f /usr/local/opt/fzf/install ]; then
        /usr/local/opt/fzf/install --all --no-update-rc 2>/dev/null || true
    elif [ -f /opt/homebrew/opt/fzf/install ]; then
        /opt/homebrew/opt/fzf/install --all --no-update-rc 2>/dev/null || true
    fi
    ok "fzf key bindings configured"
fi

# --- Phase 4: Oh My Zsh + Plugins + Theme ---

if ask "Phase 4: Setup Oh My Zsh + Powerlevel10k + plugins?"; then
    # Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        ok "Oh My Zsh installed"
    else
        ok "Oh My Zsh already installed"
    fi

    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # Plugins
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        ok "zsh-autosuggestions installed"
    else
        ok "zsh-autosuggestions already installed"
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        ok "zsh-syntax-highlighting installed"
    else
        ok "zsh-syntax-highlighting already installed"
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/you-should-use" ]; then
        git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "$ZSH_CUSTOM/plugins/you-should-use"
        ok "you-should-use installed"
    else
        ok "you-should-use already installed"
    fi

    # Powerlevel10k
    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
        ok "Powerlevel10k installed"
    else
        ok "Powerlevel10k already installed"
    fi

    # Copy dotfiles
    if [ -f "$SCRIPT_DIR/dotfiles/.zshrc" ]; then
        if ask "  Copy .zshrc from this repo? (backs up existing)"; then
            [ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.backup.$(date +%s)
            cp "$SCRIPT_DIR/dotfiles/.zshrc" ~/.zshrc
            ok ".zshrc installed (backup saved)"
        fi
    fi

    if [ -f "$SCRIPT_DIR/dotfiles/.fzf.zsh" ]; then
        cp "$SCRIPT_DIR/dotfiles/.fzf.zsh" ~/.fzf.zsh
        ok ".fzf.zsh installed"
    fi

    echo ""
    warn "Run 'p10k configure' to set up your Powerlevel10k theme"
fi

# --- Phase 5: Git ---

if ask "Phase 5: Configure Git?"; then
    read -p "Git user name (e.g. mnttnm): " GIT_NAME
    read -p "Git email: " GIT_EMAIL

    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
    git config --global init.defaultBranch main
    git config --global pull.rebase true
    git config --global core.pager delta
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.side-by-side true
    ok "Git configured for $GIT_NAME <$GIT_EMAIL>"

    if [ -f "$SCRIPT_DIR/dotfiles/.gitconfig" ]; then
        info "Note: .gitconfig template available at dotfiles/.gitconfig"
    fi
fi

# --- Phase 6: SSH Key ---

if [ ! -f ~/.ssh/id_ed25519 ]; then
    if ask "Phase 6: Generate SSH key for GitHub?"; then
        GIT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
        read -p "Email for SSH key [$GIT_EMAIL]: " SSH_EMAIL
        SSH_EMAIL="${SSH_EMAIL:-$GIT_EMAIL}"

        ssh-keygen -t ed25519 -C "$SSH_EMAIL" -f ~/.ssh/id_ed25519 -N ""
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_ed25519
        ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null

        echo ""
        ok "SSH key generated. Public key:"
        echo ""
        cat ~/.ssh/id_ed25519.pub
        echo ""
        info "Add this key at: https://github.com/settings/keys"
        read -p "Press Enter after adding the key to GitHub..."

        ssh -T git@github.com 2>&1 || true
    fi
else
    ok "SSH key already exists"
fi

# --- Phase 7: GitHub CLI ---

if has gh; then
    if ! gh auth status &>/dev/null 2>&1; then
        if ask "Phase 7: Authenticate GitHub CLI?"; then
            gh auth login
            ok "GitHub CLI authenticated"
        fi
    else
        ok "GitHub CLI already authenticated"
    fi
fi

# --- Phase 8: Node.js ---

if ask "Phase 8: Setup Node.js via fnm?"; then
    if has fnm; then
        eval "$(fnm env)"
        if ! fnm list | grep -q "v2"; then
            fnm install --lts 2>/dev/null || fnm install 24
            fnm default "$(fnm list | grep -o 'v[0-9.]*' | head -1)"
            ok "Node $(node --version) installed and set as default"
        else
            ok "Node already installed: $(fnm list | grep default || fnm list | head -1)"
        fi
    else
        warn "fnm not found — install via: brew install fnm"
    fi
fi

# --- Phase 9: AI Coding Agents ---

if ask "Phase 9: Install AI coding agents?"; then
    eval "$(fnm env)" 2>/dev/null

    # Claude Code
    if ! has claude; then
        info "Installing Claude Code..."
        npm install -g @anthropic-ai/claude-code
        ok "Claude Code installed"
    else
        ok "Claude Code already installed ($(claude --version 2>/dev/null))"
    fi

    # Codex CLI
    if ! has codex; then
        info "Installing Codex CLI..."
        npm install -g @openai/codex
        ok "Codex CLI installed"
    else
        ok "Codex CLI already installed ($(codex --version 2>/dev/null))"
    fi

    # Gemini CLI
    if ! has gemini; then
        info "Installing Gemini CLI..."
        npm install -g @google/gemini-cli
        mkdir -p ~/.gemini
        ok "Gemini CLI installed"
    else
        ok "Gemini CLI already installed"
    fi

    # Hermes Agent
    if [ ! -d "$HOME/.hermes" ]; then
        if ask "  Install Hermes Agent?"; then
            curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash || warn "Hermes install may need interactive setup — run: hermes setup"
        fi
    else
        ok "Hermes Agent already installed"
    fi
fi

# --- Phase 10: macOS Defaults ---

if ask "Phase 10: Apply macOS system preferences?"; then
    bash "$SCRIPT_DIR/macos-defaults.sh"
fi

# --- Phase 11: Always-On Agent Runner ---

if ask "Phase 11: Configure always-on agent runner (pmset)?"; then
    echo "This requires sudo for power management settings."
    sudo pmset -c disablesleep 1
    sudo pmset -c sleep 0
    sudo pmset -c displaysleep 5
    sudo pmset -c autorestart 1
    ok "Power management configured for always-on operation"
    warn "Open AlDente and set charge cap to 80%"
fi

# --- Done ---

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Setup complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Remaining manual steps:"
echo "  1. Run 'p10k configure' to setup your terminal theme"
echo "  2. Set Warp font to 'MesloLGS NF' in Warp Settings → Appearance"
echo "  3. Set Raycast hotkey to Option+Space"
echo "  4. Open AlDente and set charge cap to 80%"
echo "  5. Open Tailscale and sign in"
echo "  6. Run 'hermes setup' to configure Hermes Agent"
echo "  7. Install browser extensions (uBlock Origin, Bitwarden, etc.)"
echo ""
echo "See GUIDE.md for the full checklist."
echo ""

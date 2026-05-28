#!/bin/bash

set -euo pipefail

# cd to script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Update package database first
sudo pacman -Sy --noconfirm

# Pacman Packages
PACMAN=(
  "awww"
  "base-devel"
  "btop"
  "brightnessctl"
  "cmake"
  "eog"
  "fastfetch"
  "fd"
  "fzf"
  "foot"
  "foot-terminfo"
  "gnome-calculator"
  "gnome-disk-utility"
  "go"
  "impala"
  "julia"
  "mullvad-vpn"
  "nautilus"
  "neovim"
  "nodejs"
  "npm"
  "picard"
  "qbittorrent"
  "rust"
  "stow"
  "tailscale"
  "tree"
  "ttf-cascadia-code-nerd"
  "typst"
  "obs-studio"
  "vim"
  "vlc"
  "vlc-plugins-all"
  "wiremix"
  "zellij"
  "zsh"
  "zsh-autosuggestions"
  "zsh-syntax-highlighting"
)

# AUR packages
AUR=(
  "elephant"
  "elephant-archlinuxpkgs"
  "elephant-niriactions"
  "elephant-calc"
  "feishin-bin"
  "helium-browser-bin"
  "thinkfan"
  "vesktop"
  "walker"
)

# Set up AUR helper (yay)
if ! command -v yay &>/dev/null; then
  YAY_BUILD_DIR="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay.git "$YAY_BUILD_DIR/yay"
  (cd "$YAY_BUILD_DIR/yay" && makepkg -si --noconfirm)
  rm -rf "$YAY_BUILD_DIR"
fi

# Install packages
sudo pacman -S --needed --noconfirm "${PACMAN[@]}"
yay -S --needed --noconfirm "${AUR[@]}"

# Oh-My-Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install LSPs for Neovim
rustup default stable
rustup install
rustup component add rust-analyzer
go install golang.org/x/tools/gopls@latest

# Uninstall bullshit packages
sudo pacman -Rns fuzzel alacritty --noconfirm

# Move config files to GNU Stow
git clone

# --- Set ZSH as default shell ---
if [[ "$SHELL" != *"zsh"* ]]; then
  sudo chsh -s "$(which zsh)" "$USER"
fi

echo "Configuration complete!"
echo "Restarting system"
reboot

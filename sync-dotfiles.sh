#!/bin/bash

set -e

DOTFILES="$HOME/dotfiles"

echo "=============================="
echo " Sincronizando dotfiles"
echo "=============================="

mkdir -p "$DOTFILES"

# -----------------------------
# COPIAR CONFIGS IMPORTANTES
# -----------------------------

cp -r ~/.config/hypr "$DOTFILES/" 2>/dev/null || true
cp -r ~/.config/waybar "$DOTFILES/" 2>/dev/null || true
cp -r ~/.config/kitty "$DOTFILES/" 2>/dev/null || true
cp -r ~/.config/easyeffects "$DOTFILES/" 2>/dev/null || true
cp -r ~/.config/fastfetch "$DOTFILES/" 2>/dev/null || true
cp -r ~/.config/fish "$DOTFILES/" 2>/dev/null || true
cp -r ~/.config/gtk-3.0 "$DOTFILES/" 2>/dev/null || true
cp -r ~/.config/Kvantum "$DOTFILES/" 2>/dev/null || true
cp -r ~/.config/wofi "$DOTFILES/" 2>/dev/null || true
cp ~/.config/starship.toml "$DOTFILES/" 2>/dev/null || true
cp -r ~/.config/alacritty "$DOTFILES/" 2>/dev/null || true

# -----------------------------
# PAQUETES INSTALADOS
# -----------------------------

pacman -Qqe > "$DOTFILES/packages.txt"
pacman -Qqm > "$DOTFILES/aur-packages.txt"

# -----------------------------
# .gitignore
# -----------------------------

cat > "$DOTFILES/.gitignore" <<EOF
.cache
.mozilla
.steam
node_modules
*.log
EOF

# -----------------------------
# GIT
# -----------------------------

cd "$DOTFILES"

if [ ! -d .git ]; then
    git init
    git branch -M main
fi

# CAMBIA ESTO POR TU REPO
REPO="https://github.com/riantorres1975/omarchy-dotfiles.git"

if ! git remote | grep -q origin; then
    git remote add origin "$REPO"
fi

git add .

# Solo hacer commit si hubo cambios
if ! git diff --cached --quiet; then
    git commit -m "Backup $(date '+%Y-%m-%d %H:%M:%S')"
    git push -u origin master:main
    echo ""
    echo "Backup subido correctamente 🚀"
else
    echo ""
    echo "No hubo cambios"
fi

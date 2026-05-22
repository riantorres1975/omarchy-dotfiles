#!/bin/bash
# install.sh — Restaura dotfiles en una instalación nueva de CachyOS/Arch + Omarchy
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="https://github.com/riantorres1975/omarchy-dotfiles.git"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

# ─── colores ───────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

msg()     { echo -e "${GREEN}→${NC} $1"; }
info()    { echo -e "${CYAN}  $1${NC}"; }
warn()    { echo -e "${YELLOW}⚠  $1${NC}"; }
err()     { echo -e "${RED}✗  $1${NC}" >&2; }
header()  { echo -e "\n${BOLD}── $1 ──────────────────────────────────${NC}"; }
ok()      { echo -e "${GREEN}✓${NC} $1"; }

# ─── flags ─────────────────────────────────────────────────────
DRY_RUN=false
SKIP_PACKAGES=false
SKIP_DCONF=false
NO_BACKUP=false

usage() {
  cat <<EOF
Uso: $0 [OPCIONES]

  --dry-run         Ver qué se haría sin modificar nada
  --skip-packages   Saltar instalación de paquetes (solo restaurar configs)
  --skip-dconf      No aplicar configuración dconf/gsettings
  --no-backup       No crear backup de ~/.config existente
  --help            Esta ayuda

Sin flags: instala paquetes, restaura configs y aplica dconf.
EOF
  exit 0
}

for arg in "$@"; do
  case "$arg" in
    --dry-run)       DRY_RUN=true ;;
    --skip-packages) SKIP_PACKAGES=true ;;
    --skip-dconf)    SKIP_DCONF=true ;;
    --no-backup)     NO_BACKUP=true ;;
    --help)          usage ;;
    *) err "Opción desconocida: $arg"; exit 1 ;;
  esac
done

# ─── listas de configs (deben coincidir con sync-dotfiles.sh) ──
CONFIG_DIRS=(
  hypr waybar kitty easyeffects fastfetch fish gtk-3.0 gtk-4.0
  Kvantum wofi alacritty mako omarchy walker foot ghostty
  btop lazygit swayosd
)
CONFIG_FILES=(
  starship.toml
)

# ══════════════════════════════════════════════════════════════
# BANNER
# ══════════════════════════════════════════════════════════════
echo -e "${BOLD}"
cat <<'EOF'
  ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
  ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
  ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
  ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
  ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
  ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
  Omarchy · Catppuccin Mocha · CachyOS/Arch
EOF
echo -e "${NC}"

$DRY_RUN && warn "[DRY-RUN] — no se modificará nada en el sistema\n"

# ══════════════════════════════════════════════════════════════
# 1. PREREQUISITOS
# ══════════════════════════════════════════════════════════════
header "Verificando requisitos"

# Debe ser Arch-based
if ! command -v pacman &>/dev/null; then
  err "pacman no encontrado. Este script es para CachyOS/Arch Linux."
  exit 1
fi
ok "Sistema Arch/CachyOS detectado"

# Debe haber internet
if ! ping -c1 -W3 archlinux.org &>/dev/null; then
  err "Sin conexión a internet."
  exit 1
fi
ok "Conexión a internet OK"

# Git disponible
if ! command -v git &>/dev/null; then
  warn "git no encontrado — instalando..."
  $DRY_RUN || sudo pacman -S --noconfirm git
fi
ok "git disponible"

# ══════════════════════════════════════════════════════════════
# 2. PAQUETES OFICIALES
# ══════════════════════════════════════════════════════════════
if ! $SKIP_PACKAGES; then
  header "Instalando paquetes oficiales"

  PKG_FILE="$DOTFILES/packages.txt"
  if [ ! -f "$PKG_FILE" ]; then
    warn "No se encontró packages.txt — omitiendo"
  else
    PKG_COUNT=$(wc -l < "$PKG_FILE")
    info "$PKG_COUNT paquetes en la lista"
    if $DRY_RUN; then
      info "sudo pacman -S --needed --noconfirm - < $PKG_FILE"
    else
      sudo pacman -S --needed --noconfirm - < "$PKG_FILE" || warn "Algunos paquetes no se pudieron instalar (normal en distros no-CachyOS)"
      ok "Paquetes oficiales instalados"
    fi
  fi

  # ──────────────────────────────────────────────────────────
  # 3. PAQUETES AUR
  # ──────────────────────────────────────────────────────────
  header "Instalando paquetes AUR"

  AUR_FILE="$DOTFILES/aur-packages.txt"
  if [ ! -f "$AUR_FILE" ] || [ ! -s "$AUR_FILE" ]; then
    info "No hay paquetes AUR que instalar"
  else
    # Instalar yay si no hay helper AUR
    AUR_CMD=""
    if command -v yay &>/dev/null; then
      AUR_CMD="yay"
    elif command -v paru &>/dev/null; then
      AUR_CMD="paru"
    else
      warn "No se encontró yay ni paru — instalando yay desde AUR..."
      if ! $DRY_RUN; then
        sudo pacman -S --needed --noconfirm base-devel
        TMP=$(mktemp -d)
        git clone https://aur.archlinux.org/yay.git "$TMP/yay"
        (cd "$TMP/yay" && makepkg -si --noconfirm)
        rm -rf "$TMP"
        AUR_CMD="yay"
      fi
    fi

    AUR_COUNT=$(wc -l < "$AUR_FILE")
    info "$AUR_COUNT paquetes AUR en la lista"
    if $DRY_RUN; then
      info "$AUR_CMD -S --needed --noconfirm - < $AUR_FILE"
    else
      $AUR_CMD -S --needed --noconfirm - < "$AUR_FILE" || warn "Algunos paquetes AUR no se instalaron"
      ok "Paquetes AUR instalados"
    fi
  fi
fi

# ══════════════════════════════════════════════════════════════
# 4. BACKUP DE CONFIGS EXISTENTES
# ══════════════════════════════════════════════════════════════
header "Respaldando configs actuales"

BACKUP_NEEDED=false
for dir in "${CONFIG_DIRS[@]}"; do
  [ -d "$HOME/.config/$dir" ] && BACKUP_NEEDED=true && break
done
for file in "${CONFIG_FILES[@]}"; do
  [ -f "$HOME/.config/$file" ] && BACKUP_NEEDED=true && break
done

if $BACKUP_NEEDED && ! $NO_BACKUP; then
  if $DRY_RUN; then
    info "Crearía backup en $BACKUP_DIR"
  else
    mkdir -p "$BACKUP_DIR"
    for dir in "${CONFIG_DIRS[@]}"; do
      [ -d "$HOME/.config/$dir" ] && cp -r "$HOME/.config/$dir" "$BACKUP_DIR/" && true
    done
    for file in "${CONFIG_FILES[@]}"; do
      [ -f "$HOME/.config/$file" ] && cp "$HOME/.config/$file" "$BACKUP_DIR/" && true
    done
    ok "Backup guardado en $BACKUP_DIR"
  fi
else
  $NO_BACKUP && info "Backup omitido (--no-backup)" || info "No hay configs existentes que respaldar"
fi

# ══════════════════════════════════════════════════════════════
# 5. RESTAURAR CONFIGS
# ══════════════════════════════════════════════════════════════
header "Restaurando configuraciones"

RESTAURADOS=0

for dir in "${CONFIG_DIRS[@]}"; do
  src="$DOTFILES/$dir"
  if [ -d "$src" ]; then
    if $DRY_RUN; then
      info "Copiaría $dir → ~/.config/$dir"
    else
      mkdir -p "$HOME/.config"
      cp -r "$src" "$HOME/.config/"
    fi
    ((RESTAURADOS++)) || true
  fi
done

for file in "${CONFIG_FILES[@]}"; do
  src="$DOTFILES/$file"
  if [ -f "$src" ]; then
    if $DRY_RUN; then
      info "Copiaría $file → ~/.config/$file"
    else
      cp "$src" "$HOME/.config/$file"
    fi
    ((RESTAURADOS++)) || true
  fi
done

# git config: solo la parte no-personal (aliases, settings)
GIT_SRC="$DOTFILES/git/config"
if [ -f "$GIT_SRC" ]; then
  if $DRY_RUN; then
    info "Copiaría git/config → ~/.config/git/config"
    warn "NOTA: Recuerda configurar git user.name y user.email"
  else
    mkdir -p "$HOME/.config/git"
    cp "$GIT_SRC" "$HOME/.config/git/config"
    ((RESTAURADOS++)) || true
  fi
fi

msg "Configuraciones restauradas: $RESTAURADOS"

# ══════════════════════════════════════════════════════════════
# 6. DCONF / GSETTINGS
# ══════════════════════════════════════════════════════════════
if ! $SKIP_DCONF; then
  header "Aplicando configuración dconf"

  DCONF_FILE="$DOTFILES/dconf-settings.ini"
  if [ ! -f "$DCONF_FILE" ]; then
    warn "No se encontró dconf-settings.ini — omitiendo"
  elif ! command -v dconf &>/dev/null; then
    warn "dconf no instalado — omitiendo"
  else
    if $DRY_RUN; then
      info "dconf load / < $DCONF_FILE"
    else
      dconf load / < "$DCONF_FILE"
      ok "dconf aplicado"
    fi
  fi
fi

# ══════════════════════════════════════════════════════════════
# 7. POST-INSTALACIÓN
# ══════════════════════════════════════════════════════════════
header "Post-instalación"

# Fish como shell por defecto
if command -v fish &>/dev/null; then
  FISH_PATH="$(command -v fish)"
  if [ "$SHELL" != "$FISH_PATH" ]; then
    if $DRY_RUN; then
      info "chsh -s $FISH_PATH"
    else
      # Agregar fish a /etc/shells si no está
      grep -qF "$FISH_PATH" /etc/shells || echo "$FISH_PATH" | sudo tee -a /etc/shells
      chsh -s "$FISH_PATH"
      ok "Shell cambiado a fish ($FISH_PATH)"
    fi
  else
    ok "fish ya es el shell por defecto"
  fi
else
  warn "fish no encontrado — shell sin cambiar"
fi

# Aplicar tema Omarchy si está disponible
if command -v omarchy &>/dev/null && ! $DRY_RUN; then
  CURRENT_THEME=$(cat "$HOME/.config/omarchy/current/theme/name" 2>/dev/null || echo "catppuccin-mocha-mauve")
  info "Aplicando tema Omarchy: $CURRENT_THEME"
  omarchy theme set "$CURRENT_THEME" 2>/dev/null && ok "Tema aplicado: $CURRENT_THEME" || warn "No se pudo aplicar el tema (normal si Hyprland no está corriendo)"
fi

# Recargar Hyprland si está corriendo
if command -v hyprctl &>/dev/null && hyprctl monitors &>/dev/null 2>&1; then
  if $DRY_RUN; then
    info "hyprctl reload"
  else
    hyprctl reload && ok "Hyprland recargado"
  fi
fi

# ══════════════════════════════════════════════════════════════
# RESUMEN FINAL
# ══════════════════════════════════════════════════════════════
echo ""
echo -e "${BOLD}${GREEN}════════════════════════════════════════${NC}"
echo -e "${BOLD}${GREEN}  Instalación completada${NC}"
echo -e "${BOLD}${GREEN}════════════════════════════════════════${NC}"
echo ""

if ! $DRY_RUN; then
  echo -e "${CYAN}Pasos manuales pendientes:${NC}"
  echo ""
  echo -e "  ${YELLOW}1.${NC} Configura tu identidad en git:"
  echo -e "     ${CYAN}git config --global user.name  \"Tu Nombre\"${NC}"
  echo -e "     ${CYAN}git config --global user.email \"tu@email.com\"${NC}"
  echo ""
  echo -e "  ${YELLOW}2.${NC} Cierra sesión y vuelve a entrar para aplicar:"
  echo -e "     • Shell Fish"
  echo -e "     • Tema visual completo"
  echo ""
  $NO_BACKUP || echo -e "  ${YELLOW}ℹ${NC}  Backup de configs previas en: ${CYAN}$BACKUP_DIR${NC}"
  echo ""
fi

#!/bin/bash
set -e

DOTFILES="$HOME/dotfiles"
REPO="https://github.com/riantorres1975/omarchy-dotfiles.git"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

# ─── configs a sincronizar (directorios y archivos sueltos) ───
CONFIG_DIRS=(
  hypr waybar kitty easyeffects fastfetch fish gtk-3.0
  Kvantum wofi alacritty
)
CONFIG_FILES=(
  starship.toml
)

# ─── colores ───
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'
msg()  { echo -e "${GREEN}→${NC} $1"; }
info() { echo -e "${CYAN}  $1${NC}"; }
err()  { echo -e "${RED}✗ $1${NC}" >&2; }

# ─── flags ───
DRY_RUN=false; SKIP_PUSH=false; SKIP_PACKAGES=false; TAG=false; VERBOSE=false

usage() {
  cat <<EOF
Uso: $0 [OPCIONES]

  --dry-run        Mostrar qué se copiaría sin hacer cambios
  --skip-push      Hacer commit local pero no pushear
  --skip-packages  No regenerar packages.txt ni aur-packages.txt
  --tag            Crear un tag con la fecha (ej: backup-20260517-1230)
  --verbose        Mostrar más detalles
  --help           Esta ayuda

Sin flags, copia configs, guarda paquetes, commitea y pushea.
EOF
  exit 0
}

for arg in "$@"; do
  case "$arg" in
    --dry-run)        DRY_RUN=true ;;
    --skip-push)      SKIP_PUSH=true ;;
    --skip-packages)  SKIP_PACKAGES=true ;;
    --tag)            TAG=true ;;
    --verbose)        VERBOSE=true ;;
    --help)           usage ;;
    *) err "Opción desconocida: $arg"; exit 1 ;;
  esac
done

$DRY_RUN && msg "[DRY-RUN] — sin modificar nada"

mkdir -p "$DOTFILES"

# ──────────────────────────────────────────────────
# 1. Auto-detectar qué configs existen
# ──────────────────────────────────────────────────
msg "Detectando configuraciones..."

SOURCES=()

for dir in "${CONFIG_DIRS[@]}"; do
  if [ -d "$HOME/.config/$dir" ]; then
    SOURCES+=("$HOME/.config/$dir")
  else
    $VERBOSE && info "No encontrado: ~/.config/$dir"
  fi
done
for file in "${CONFIG_FILES[@]}"; do
  if [ -f "$HOME/.config/$file" ]; then
    SOURCES+=("$HOME/.config/$file")
  else
    $VERBOSE && info "No encontrado: ~/.config/$file"
  fi
done

$VERBOSE && info "Se detectaron ${#SOURCES[@]} fuentes"

# ──────────────────────────────────────────────────
# 2. Copiar configs
# ──────────────────────────────────────────────────
COPIADOS=0

for src in "${SOURCES[@]}"; do
  name="$(basename "$src")"
  dest="$DOTFILES/$name"

  if $DRY_RUN; then
    info "Copiaría ~/.config/$name → dotfiles/"
    ((COPIADOS++)) || true
  else
    cp -r "$src" "$DOTFILES/"
    ((COPIADOS++)) || true
    $VERBOSE && info "Copiado: $name"
  fi
done

msg "Configs sincronizadas: $COPIADOS"

# ──────────────────────────────────────────────────
# 3. Paquetes
# ──────────────────────────────────────────────────
if ! $DRY_RUN && ! $SKIP_PACKAGES; then
  if command -v pacman &>/dev/null; then
    msg "Guardando lista de paquetes..."
    pacman -Qqe > "$DOTFILES/packages.txt"
    pacman -Qqm > "$DOTFILES/aur-packages.txt"
  else
    err "pacman no encontrado, omitiendo listas de paquetes"
  fi
else
  $SKIP_PACKAGES && msg "Lista de paquetes omitida (--skip-packages)"
fi

# ──────────────────────────────────────────────────
# 4. .gitignore
# ──────────────────────────────────────────────────
if ! $DRY_RUN; then
  cat > "$DOTFILES/.gitignore" <<'EOF'
.cache
.mozilla
.steam
node_modules
*.log
EOF
fi

# ──────────────────────────────────────────────────
# 5. Git
# ──────────────────────────────────────────────────
cd "$DOTFILES"

if [ ! -d .git ]; then
  if $DRY_RUN; then
    info "Inicializaría repo git"
  else
    git init && git branch -M main
  fi
fi

if ! git remote | grep -q origin; then
  if $DRY_RUN; then
    info "Agregaría remote origin → $REPO"
  else
    git remote add origin "$REPO"
  fi
fi

if $DRY_RUN; then
  info "git add . && git commit -m 'Backup $TIMESTAMP'"
  $SKIP_PUSH || info "git push origin master:main"
  $TAG && info "git tag backup-$(date '+%Y%m%d-%H%M')"
  exit 0
fi

git add .

if ! git diff --cached --quiet; then
  git commit -m "Backup $TIMESTAMP"

  if $TAG; then
    TAG_NAME="backup-$(date '+%Y%m%d-%H%M')"
    git tag "$TAG_NAME"
    info "Tag creado: $TAG_NAME"
  fi

  if $SKIP_PUSH; then
    msg "Commit local hecho. Push omitido (--skip-push)"
  else
    git push -u origin master:main
    msg "Backup subido correctamente"
  fi
else
  msg "No hubo cambios"
fi

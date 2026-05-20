# Dotfiles — Omarchy + Hyprland (CachyOS)

Configuraciones personales para CachyOS con Hyprland (Lua config), Waybar, Kitty, Alacritty, Fish, Ghostty, Foot, Mako, Walker y más. Tema visual: **Catppuccin Mocha**.

## Contenido del repo

| Directorio/Archivo | Descripción |
|--------------------|-------------|
| `hypr/` | Hyprland — ventanas, monitores, keybindings, animaciones, reglas |
| `waybar/` | Barra de estado — layout, estilos, scripts (clima, calendario, cava) |
| `kitty/` | Terminal Kitty |
| `alacritty/` | Terminal Alacritty |
| `foot/` | Terminal Foot |
| `ghostty/` | Terminal Ghostty |
| `fish/` | Shell Fish — funciones, alias, variables |
| `omarchy/` | Temas, fondos y hooks personalizados de Omarchy |
| `walker/` | Launcher Walker |
| `mako/` | Notificaciones Mako |
| `easyeffects/` | Perfiles de audio EasyEffects |
| `fastfetch/` | Config de fastfetch |
| `gtk-3.0/` | Tema GTK |
| `starship.toml` | Prompt Starship |
| `packages.txt` | Paquetes oficiales (pacman) |
| `aur-packages.txt` | Paquetes AUR |

---

## Instalación desde cero

### 1. Instalar CachyOS

Durante la instalación seleccionar:

- **BTRFS** con Snapper
- **Fish** shell
- **Hyprland**

---

### 2. Instalar Git

```bash
sudo pacman -S git
```

---

### 3. Clonar dotfiles

```bash
git clone https://github.com/riantorres1975/omarchy-dotfiles.git ~/dotfiles
```

---

### 4. Instalar paquetes oficiales

```bash
sudo pacman -S --needed - < ~/dotfiles/packages.txt
```

---

### 5. Instalar paquetes AUR

```bash
sudo pacman -S yay
yay -S --needed - < ~/dotfiles/aur-packages.txt
```

---

### 6. Restaurar configuraciones

```bash
cp -r ~/dotfiles/alacritty ~/.config/
cp -r ~/dotfiles/easyeffects ~/.config/
cp -r ~/dotfiles/fastfetch ~/.config/
cp -r ~/dotfiles/fish ~/.config/
cp -r ~/dotfiles/foot ~/.config/
cp -r ~/dotfiles/ghostty ~/.config/
cp -r ~/dotfiles/gtk-3.0 ~/.config/
cp -r ~/dotfiles/hypr ~/.config/
cp -r ~/dotfiles/kitty ~/.config/
cp -r ~/dotfiles/mako ~/.config/
cp -r ~/dotfiles/omarchy ~/.config/
cp -r ~/dotfiles/walker ~/.config/
cp -r ~/dotfiles/waybar ~/.config/
cp ~/dotfiles/starship.toml ~/.config/
```

---

### 7. Reiniciar Hyprland

Cerrar sesión y volver a entrar, o:

```bash
hyprctl reload
```

---

## Sincronizar cambios al repo

```bash
~/dotfiles/sync-dotfiles.sh
```

Detecta automáticamente los directorios configurados, copia los cambios a `~/dotfiles/`, guarda la lista de paquetes instalados, hace commit y push.

### Opciones del script

```
--dry-run        Ver qué se copiaría sin hacer cambios
--skip-push      Commit local sin push
--skip-packages  No regenerar packages.txt / aur-packages.txt
--tag            Crear un tag con fecha (ej: backup-20260519-2028)
--verbose        Mostrar detalle de cada archivo copiado
```

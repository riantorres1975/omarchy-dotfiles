# Dotfiles — Omarchy + Hyprland (CachyOS)

Configuraciones personales para CachyOS con Hyprland (Lua config), Waybar, Kitty, Alacritty, Fish, Ghostty, Foot, Mako, Walker y más. Tema visual: **Catppuccin Mocha**.

---

## Instalación rápida (nueva máquina)

```bash
# 1. Instalar git si no está
sudo pacman -S git

# 2. Clonar el repo
git clone https://github.com/riantorres1975/omarchy-dotfiles.git ~/dotfiles

# 3. Ejecutar el instalador
bash ~/dotfiles/install.sh
```

El script `install.sh` hace todo automáticamente:
- Instala los **paquetes oficiales** y **paquetes AUR**
- Hace **backup automático** de cualquier config existente en `~/.config-backup-<fecha>`
- Copia todas las **configuraciones** a `~/.config/`
- Aplica la **configuración dconf** (gsettings, botones de ventana, tema GTK, etc.)
- Cambia el **shell a Fish**
- Aplica el **tema Omarchy** si está disponible
- Recarga **Hyprland** si está corriendo

### Opciones del instalador

```
--dry-run         Ver qué haría sin modificar nada
--skip-packages   Solo restaurar configs (sin instalar paquetes)
--skip-dconf      No aplicar configuración dconf/gsettings
--no-backup       No crear backup de configs existentes
--help            Mostrar ayuda
```

### Después de instalar

```bash
# Configura tu identidad en git (no se guarda en el repo)
git config --global user.name  "Tu Nombre"
git config --global user.email "tu@email.com"
```

Cierra sesión y vuelve a entrar para aplicar Fish shell y el tema completo.

---

## Contenido del repo

| Directorio/Archivo   | Descripción |
|----------------------|-------------|
| `hypr/`              | Hyprland — ventanas, monitores, keybindings, animaciones, reglas |
| `waybar/`            | Barra de estado — layout, estilos |
| `kitty/`             | Terminal Kitty |
| `alacritty/`         | Terminal Alacritty |
| `foot/`              | Terminal Foot |
| `ghostty/`           | Terminal Ghostty |
| `fish/`              | Shell Fish — funciones, alias, variables |
| `omarchy/`           | Temas, fondos y hooks personalizados de Omarchy |
| `walker/`            | Launcher Walker |
| `mako/`              | Notificaciones Mako |
| `easyeffects/`       | Perfiles de audio EasyEffects |
| `fastfetch/`         | Config de fastfetch |
| `gtk-3.0/`           | Tema GTK3 |
| `gtk-4.0/`           | Tema GTK4 |
| `btop/`              | Monitor de sistema btop |
| `git/`               | Git — aliases y settings (sin user.name/email) |
| `lazygit/`           | Config de lazygit |
| `swayosd/`           | OSD (volumen, brillo) |
| `starship.toml`      | Prompt Starship |
| `dconf-settings.ini` | Settings de gsettings/dconf (temas, botones de ventana, etc.) |
| `packages.txt`       | Paquetes oficiales (pacman) |
| `aur-packages.txt`   | Paquetes AUR |
| `install.sh`         | Script de instalación para máquina nueva |
| `sync-dotfiles.sh`   | Script para respaldar y subir cambios |

---

## Sincronizar cambios al repo

```bash
~/dotfiles/sync-dotfiles.sh
```

Detecta los configs, copia los cambios, guarda lista de paquetes, hace commit y push.

### Opciones de sync

```
--dry-run        Ver qué se copiaría sin hacer cambios
--skip-push      Commit local sin push
--skip-packages  No regenerar packages.txt / aur-packages.txt
--tag            Crear un tag con fecha (ej: backup-20260521-2230)
--verbose        Mostrar detalle de cada archivo copiado
```

# Dotfiles — Setup Omarchy + Hyprland

Configuraciones personales para CachyOS con Hyprland, Waybar, Kitty, Alacritty, Fish y más.

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
cp -r ~/dotfiles/gtk-3.0 ~/.config/
cp -r ~/dotfiles/hypr ~/.config/
cp -r ~/dotfiles/kitty ~/.config/
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

Copiar configs modificadas a `~/dotfiles/`, hacer commit y push.

> Si el script no existe, crearlo manualmente o copiar los archivos a `~/dotfiles/` y hacer commit a mano.

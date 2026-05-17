# README - Restaurar mi setup Omarchy

## Instalación desde cero

### 1. Instalar CachyOS

Durante la instalación usar:

* BTRFS
* Snapper
* Fish shell
* Hyprland

---

## 2. Instalar Git

```bash
sudo pacman -S git
```

---

## 3. Clonar dotfiles

```bash
git clone https://github.com/riantorres1975/omarchy-dotfiles.git ~/dotfiles
```

---

## 4. Instalar paquetes normales

```bash
sudo pacman -S --needed - < ~/dotfiles/packages.txt
```

---

## 5. Instalar paquetes AUR

Primero instalar yay:

```bash
sudo pacman -S yay
```

Luego:

```bash
yay -S --needed - < ~/dotfiles/aur-packages.txt
```

---

## 6. Restaurar configuraciones

```bash
cp -r ~/dotfiles/hypr ~/.config/
cp -r ~/dotfiles/waybar ~/.config/
cp -r ~/dotfiles/kitty ~/.config/
cp -r ~/dotfiles/easyeffects ~/.config/
cp -r ~/dotfiles/fastfetch ~/.config/
cp -r ~/dotfiles/fish ~/.config/
cp -r ~/dotfiles/gtk-3.0 ~/.config/
```

---

## 7. Reiniciar Hyprland

Cerrar sesión y volver a entrar.

O ejecutar:

```bash
hyprctl reload
```

---

## 8. Ejecutar backup automático

Cada vez que cambies algo:

```bash
~/sync-dotfiles.sh
```

Eso:

* copia configs
* guarda paquetes
* hace commit
* sube a GitHub

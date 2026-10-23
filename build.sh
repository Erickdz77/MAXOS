#!/bin/bash
# MaxOS: script único. Cria toda a configuração e monta a ISO.
# Uso: bash build.sh <i386|amd64> <686-pae|amd64>   (precisa do arquivo logo.png ao lado)
set -e
ARCH="${1:-amd64}"; FLAVOUR="${2:-amd64}"
HERE="$(pwd)"
C=config/includes.chroot
mkdir -p config/package-lists $C/usr/share/backgrounds/maxos
mkdir -p 'config/includes.chroot/etc'
cat > 'config/includes.chroot/etc/issue' <<'MAXEOF'
MaxOS 1.0 (Debian 12)
MAXEOF
mkdir -p 'config/includes.chroot/etc/lightdm/lightdm.conf.d'
cat > 'config/includes.chroot/etc/lightdm/lightdm.conf.d/50-maxos.conf' <<'MAXEOF'
[Seat:*]
autologin-user=max
autologin-session=openbox
user-session=openbox
MAXEOF
mkdir -p 'config/includes.chroot/etc/skel'
cat > 'config/includes.chroot/etc/skel/.bashrc' <<'MAXEOF'
[ -n "$PS1" ] && [ -z "$MAXOS_SHOWN" ] && export MAXOS_SHOWN=1 && neofetch
MAXEOF
mkdir -p 'config/includes.chroot/etc/skel/.config/conky'
cat > 'config/includes.chroot/etc/skel/.config/conky/conky.conf' <<'MAXEOF'
conky.config = {
  alignment = 'top_right',
  gap_x = 30, gap_y = 40,
  minimum_width = 240, maximum_width = 240,
  own_window = true, own_window_type = 'desktop',
  own_window_transparent = true,
  own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
  double_buffer = true, update_interval = 2,
  use_xft = true, font = 'DejaVu Sans:size=10',
  default_color = 'white', draw_shades = false, draw_borders = false,
}
conky.text = [[
${font DejaVu Sans:size=32}${time %H:%M}${font}
${time %A, %d de %B de %Y}
${hr}
CPU ${cpu}%
${cpubar 5}
RAM ${memperc}%
${membar 5}
DISCO ${fs_used_perc /}%
${fs_bar 5 /}
]]
MAXEOF
mkdir -p 'config/includes.chroot/etc/skel/.config/gtk-3.0'
cat > 'config/includes.chroot/etc/skel/.config/gtk-3.0/settings.ini' <<'MAXEOF'
[Settings]
gtk-theme-name=Arc-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=DejaVu Sans 10
MAXEOF
mkdir -p 'config/includes.chroot/etc/skel/.config/lxterminal'
cat > 'config/includes.chroot/etc/skel/.config/lxterminal/lxterminal.conf' <<'MAXEOF'
[general]
fontname=DejaVu Sans Mono 11
bgcolor=rgb(2,4,10)
fgcolor=rgb(238,242,247)
MAXEOF
mkdir -p 'config/includes.chroot/etc/skel/.config/openbox'
cat > 'config/includes.chroot/etc/skel/.config/openbox/autostart' <<'MAXEOF'
feh --bg-fill /usr/share/backgrounds/maxos/wallpaper.png &
tint2 &
conky -c ~/.config/conky/conky.conf &
nm-applet &
volumeicon &
MAXEOF
mkdir -p 'config/includes.chroot/etc/skel/.config/tint2'
cat > 'config/includes.chroot/etc/skel/.config/tint2/tint2rc' <<'MAXEOF'
panel_items = LT
panel_monitor = all
panel_position = center left vertical
panel_size = 56 100%
panel_margin = 0 0
panel_padding = 8 12 8
panel_background_id = 1
panel_layer = top
launcher_padding = 4 8 8
launcher_icon_size = 32
launcher_item_app = /usr/share/applications/pcmanfm.desktop
launcher_item_app = /usr/share/applications/netsurf-gtk.desktop
launcher_item_app = /usr/share/applications/lxterminal.desktop
launcher_item_app = /usr/share/applications/maxos-sair.desktop
time1_format = %H:%M
time1_font = DejaVu Sans 9
clock_font_color = #ffffff 100
rounded = 0
border_width = 1
background_color = #070b12 100
border_color = #ffffff 25
background_color_hover = #ffffff 20
border_color_hover = #ffffff 25
background_color_pressed = #ffffff 30
border_color_pressed = #ffffff 25
MAXEOF
mkdir -p 'config/includes.chroot/usr/share/applications'
cat > 'config/includes.chroot/usr/share/applications/maxos-sair.desktop' <<'MAXEOF'
[Desktop Entry]
Type=Application
Name=Sair
Exec=openbox --exit
Icon=system-shutdown
MAXEOF
mkdir -p 'config/package-lists'
cat > 'config/package-lists/maxos.list.chroot' <<'MAXEOF'
xorg
lightdm
openbox
obconf
tint2
conky-std
feh
lxterminal
pcmanfm
netsurf-gtk
neofetch
htop
nano
network-manager
network-manager-gnome
alsa-utils
volumeicon-alsa
arc-theme
papirus-icon-theme
fonts-dejavu
firmware-linux-free
firmware-misc-nonfree
MAXEOF

# Logo e papel de parede (gerado a partir do logo.png)
cp "$HERE/logo.png" $C/usr/share/backgrounds/maxos/logo.png
convert -size 1366x768 radial-gradient:'#0b1830-#02040a' \
  \( "$HERE/logo.png" -resize 300x300 \) -gravity center -geometry +0-30 -composite \
  -font DejaVu-Sans -pointsize 16 -fill '#8a95a5' -gravity south \
  -annotate +0+60 'FOCO   •   DISCIPLINA   •   EVOLUÇÃO' \
  $C/usr/share/backgrounds/maxos/wallpaper.png

lb config \
  --distribution bookworm \
  --architectures "$ARCH" \
  --linux-flavours "$FLAVOUR" \
  --archive-areas "main contrib non-free-firmware" \
  --binary-images iso-hybrid \
  --debian-installer none \
  --memtest none \
  --iso-volume "MaxOS" \
  --iso-application "MaxOS" \
  --bootappend-live "boot=live components quiet splash username=max hostname=maxos locales=pt_BR.UTF-8 keyboard-layouts=br timezone=America/Sao_Paulo"
lb build
mv live-image-*.iso "MaxOS-1.0-$ARCH.iso"

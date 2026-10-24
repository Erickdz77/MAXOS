#!/bin/bash
# MaxOS: script único. Cria toda a configuração e monta a ISO.
# Uso: bash build.sh <i386|amd64> <686-pae|amd64>   (precisa do arquivo fundo.png ao lado)
set -e
ARCH="${1:-amd64}"; FLAVOUR="${2:-amd64}"
HERE="$(pwd)"
C=config/includes.chroot
mkdir -p config/package-lists $C/usr/share/backgrounds/maxos
mkdir -p 'config/hooks/normal'
cat > 'config/hooks/normal/0100-maxos.hook.chroot' <<'MAXEOF'
#!/bin/sh
mkdir -p /etc/skel/.config/openbox
cp /etc/xdg/openbox/rc.xml /etc/skel/.config/openbox/rc.xml
sed -i 's#</applications>#<application class="Lxterminal"><position force="yes"><x>90</x><y>-60</y></position></application>\n</applications>#' /etc/skel/.config/openbox/rc.xml
sed -i 's/^PRETTY_NAME=.*/PRETTY_NAME="MaxOS 1.0"/' /etc/os-release
MAXEOF
chmod +x 'config/hooks/normal/0100-maxos.hook.chroot'
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
  gap_x = 30, gap_y = 56,
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
mkdir -p 'config/includes.chroot/etc/skel/.config/conky'
cat > 'config/includes.chroot/etc/skel/.config/conky/marca.conf' <<'MAXEOF'
conky.config = {
  alignment = 'bottom_right',
  gap_x = 30, gap_y = 30,
  minimum_width = 240, maximum_width = 240,
  own_window = true, own_window_type = 'desktop',
  own_window_transparent = true,
  own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
  double_buffer = true, update_interval = 60,
  use_xft = true, font = 'DejaVu Sans:size=9',
  default_color = '8a95a5', draw_shades = false, draw_borders = false,
}
conky.text = [[
${alignr}MAXOS
${alignr}CUSTOM DISTRIBUTION
${alignr}v1.0
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
bgcolor=rgb(0,0,0)
fgcolor=rgb(238,242,247)
MAXEOF
mkdir -p 'config/includes.chroot/etc/skel/.config/openbox'
cat > 'config/includes.chroot/etc/skel/.config/openbox/autostart' <<'MAXEOF'
feh --bg-fill /usr/share/backgrounds/maxos/wallpaper.png &
tint2 -c ~/.config/tint2/topo.tint2rc &
tint2 -c ~/.config/tint2/tint2rc &
conky -c ~/.config/conky/conky.conf &
conky -c ~/.config/conky/marca.conf &
nm-applet &
volumeicon &
lxterminal --geometry=66x20 &
MAXEOF
mkdir -p 'config/includes.chroot/etc/skel/.config/tint2'
cat > 'config/includes.chroot/etc/skel/.config/tint2/tint2rc' <<'MAXEOF'
panel_items = L
panel_monitor = all
panel_position = center left vertical
panel_size = 64 100%
panel_margin = 0 34
panel_padding = 0 14 0
panel_background_id = 1
panel_layer = top
strut_policy = follow_size
launcher_padding = 12 0 16
launcher_background_id = 0
launcher_icon_size = 38
launcher_item_app = /usr/share/applications/pcmanfm.desktop
launcher_item_app = /usr/share/applications/netsurf-gtk.desktop
launcher_item_app = /usr/share/applications/lxterminal.desktop
launcher_item_app = /usr/share/applications/obconf.desktop
launcher_item_app = /usr/share/applications/maxos-sair.desktop

rounded = 0
border_width = 1
border_sides = R
background_color = #000000 100
border_color = #ffffff 30
MAXEOF
mkdir -p 'config/includes.chroot/etc/skel/.config/tint2'
cat > 'config/includes.chroot/etc/skel/.config/tint2/topo.tint2rc' <<'MAXEOF'
panel_items = P:SC
panel_monitor = all
panel_position = top center horizontal
panel_size = 100% 34
panel_margin = 0 0
panel_padding = 14 0 8
panel_background_id = 1
panel_layer = top
strut_policy = follow_size

execp = new
execp_command = echo "M A X   O S"
execp_interval = 0
execp_font = DejaVu Sans Bold 10
execp_font_color = #ffffff 100
execp_padding = 0 0
execp_background_id = 0

systray_padding = 4 4 8
systray_background_id = 0
systray_icon_size = 20

time1_format = %H:%M
time1_font = DejaVu Sans 10
clock_font_color = #ffffff 100
clock_padding = 10 0
clock_background_id = 0

rounded = 0
border_width = 1
border_sides = B
background_color = #000000 100
border_color = #ffffff 30
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

cp "$HERE/fundo.png" $C/usr/share/backgrounds/maxos/wallpaper.png

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

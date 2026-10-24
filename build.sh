#!/bin/bash
# MaxOS: script único. Cria toda a configuração e monta a ISO.
# Uso: bash build.sh <i386|amd64> <686-pae|amd64>   (precisa do arquivo fundo.png ao lado)
set -e
ARCH="${1:-amd64}"; FLAVOUR="${2:-amd64}"
HERE="$(pwd)"
C=config/includes.chroot
mkdir -p config/package-lists $C/usr/share/backgrounds/maxos $C/usr/share/maxos/icons
mkdir -p 'config/hooks/normal'
cat > 'config/hooks/normal/0100-maxos.hook.chroot' <<'MAXEOF'
#!/bin/sh
mkdir -p /etc/skel/.config/openbox
cp /etc/xdg/openbox/rc.xml /etc/skel/.config/openbox/rc.xml
sed -i 's#</applications>#<application class="Lxterminal"><position force="yes"><x>90</x><y>-70</y></position></application>\n</applications>#' /etc/skel/.config/openbox/rc.xml
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
[ -n "$PS1" ] && [ -z "$MAXOS_SHOWN" ] && export MAXOS_SHOWN=1 && neofetch --source /usr/share/maxos/logo.ascii --ascii_colors 7 7 --title_fqdn off
MAXEOF
mkdir -p 'config/includes.chroot/etc/skel/.config/conky'
cat > 'config/includes.chroot/etc/skel/.config/conky/conky.conf' <<'MAXEOF'
conky.config = {
  alignment = 'top_right',
  gap_x = 36, gap_y = 66,
  minimum_width = 260, maximum_width = 260,
  own_window = true, own_window_type = 'desktop',
  own_window_transparent = true,
  own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
  double_buffer = true, update_interval = 2,
  use_xft = true, font = 'JetBrains Mono:size=10',
  default_color = 'white', default_bar_width = 260, default_bar_height = 5,
  draw_shades = false, draw_borders = false,
}
conky.text = [[
${font JetBrains Mono:light:size=36}${time %H:%M}${font}
${time %A, %d de %B de %Y}
${voffset 6}${hr 1}
${voffset 8}CPU ${cpu}%
${cpubar}
${voffset 8}RAM ${memperc}%
${membar}
${voffset 8}DISCO ${fs_used_perc /}%
${fs_bar /}
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
  use_xft = true, font = 'JetBrains Mono:size=8',
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
fontname=JetBrains Mono 10
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
lxterminal --geometry=72x21 &
MAXEOF
mkdir -p 'config/includes.chroot/etc/skel/.config/tint2'
cat > 'config/includes.chroot/etc/skel/.config/tint2/tint2rc' <<'MAXEOF'
panel_items = L
panel_monitor = all
panel_position = center left vertical
panel_size = 100% 64
panel_margin = 0 0
panel_padding = 0 0 0
panel_background_id = 1
panel_layer = top
strut_policy = follow_size
launcher_padding = 18 52 22
launcher_background_id = 0
launcher_icon_size = 28
launcher_icon_theme_override = 0
launcher_item_app = /usr/share/applications/maxos-arquivos.desktop
launcher_item_app = /usr/share/applications/maxos-web.desktop
launcher_item_app = /usr/share/applications/maxos-terminal.desktop
launcher_item_app = /usr/share/applications/maxos-codigo.desktop
launcher_item_app = /usr/share/applications/maxos-pasta.desktop
launcher_item_app = /usr/share/applications/maxos-musica.desktop
launcher_item_app = /usr/share/applications/maxos-video.desktop
launcher_item_app = /usr/share/applications/maxos-config.desktop
launcher_item_app = /usr/share/applications/maxos-sair.desktop
launcher_item_app = /usr/share/applications/maxos-apps.desktop

rounded = 0
border_width = 1
border_sides = R
background_color = #000000 100
border_color = #ffffff 45
MAXEOF
mkdir -p 'config/includes.chroot/etc/skel/.config/tint2'
cat > 'config/includes.chroot/etc/skel/.config/tint2/topo.tint2rc' <<'MAXEOF'
panel_items = PP:SBC
panel_monitor = all
panel_position = top center horizontal
panel_size = 100% 36
panel_margin = 0 0
panel_padding = 14 0 10
panel_background_id = 1
panel_layer = top
strut_policy = follow_size

button = new
button_icon = /usr/share/maxos/icons/logo.png
button_centered = 1
button_padding = 0 0 0
button_max_icon_size = 28
button_lclick_command = pcmanfm
button_background_id = 0

execp = new
execp_command = echo "M A X O S      │      >_"
execp_interval = 0
execp_font = JetBrains Mono 10
execp_font_color = #ffffff 100
execp_padding = 6 0
execp_lclick_command = lxterminal
execp_background_id = 0

systray_padding = 4 4 10
systray_background_id = 0
systray_icon_size = 20

time1_format = %H:%M
time1_font = JetBrains Mono 10
clock_font_color = #ffffff 100
clock_padding = 10 0
clock_background_id = 0

rounded = 0
border_width = 1
border_sides = B
background_color = #000000 100
border_color = #ffffff 45
MAXEOF
mkdir -p 'config/includes.chroot/usr/share/applications'
cat > 'config/includes.chroot/usr/share/applications/maxos-apps.desktop' <<'MAXEOF'
[Desktop Entry]
Type=Application
Name=Aplicativos
Exec=pcmanfm menu://applications/
Icon=/usr/share/maxos/icons/apps.png
MAXEOF
mkdir -p 'config/includes.chroot/usr/share/applications'
cat > 'config/includes.chroot/usr/share/applications/maxos-arquivos.desktop' <<'MAXEOF'
[Desktop Entry]
Type=Application
Name=Arquivos
Exec=pcmanfm
Icon=/usr/share/maxos/icons/arquivos.png
MAXEOF
mkdir -p 'config/includes.chroot/usr/share/applications'
cat > 'config/includes.chroot/usr/share/applications/maxos-codigo.desktop' <<'MAXEOF'
[Desktop Entry]
Type=Application
Name=Codigo
Exec=lxterminal -e nano
Icon=/usr/share/maxos/icons/codigo.png
MAXEOF
mkdir -p 'config/includes.chroot/usr/share/applications'
cat > 'config/includes.chroot/usr/share/applications/maxos-config.desktop' <<'MAXEOF'
[Desktop Entry]
Type=Application
Name=Configuracoes
Exec=obconf
Icon=/usr/share/maxos/icons/config.png
MAXEOF
mkdir -p 'config/includes.chroot/usr/share/applications'
cat > 'config/includes.chroot/usr/share/applications/maxos-musica.desktop' <<'MAXEOF'
[Desktop Entry]
Type=Application
Name=Musica
Exec=mpv --player-operation-mode=pseudo-gui
Icon=/usr/share/maxos/icons/musica.png
MAXEOF
mkdir -p 'config/includes.chroot/usr/share/applications'
cat > 'config/includes.chroot/usr/share/applications/maxos-pasta.desktop' <<'MAXEOF'
[Desktop Entry]
Type=Application
Name=Pasta
Exec=pcmanfm /home/max
Icon=/usr/share/maxos/icons/pasta.png
MAXEOF
mkdir -p 'config/includes.chroot/usr/share/applications'
cat > 'config/includes.chroot/usr/share/applications/maxos-sair.desktop' <<'MAXEOF'
[Desktop Entry]
Type=Application
Name=Sair
Exec=openbox --exit
Icon=/usr/share/maxos/icons/sair.png
MAXEOF
mkdir -p 'config/includes.chroot/usr/share/applications'
cat > 'config/includes.chroot/usr/share/applications/maxos-terminal.desktop' <<'MAXEOF'
[Desktop Entry]
Type=Application
Name=Terminal
Exec=lxterminal
Icon=/usr/share/maxos/icons/terminal.png
MAXEOF
mkdir -p 'config/includes.chroot/usr/share/applications'
cat > 'config/includes.chroot/usr/share/applications/maxos-video.desktop' <<'MAXEOF'
[Desktop Entry]
Type=Application
Name=Video
Exec=mpv --player-operation-mode=pseudo-gui
Icon=/usr/share/maxos/icons/video.png
MAXEOF
mkdir -p 'config/includes.chroot/usr/share/applications'
cat > 'config/includes.chroot/usr/share/applications/maxos-web.desktop' <<'MAXEOF'
[Desktop Entry]
Type=Application
Name=Navegador
Exec=netsurf-gtk
Icon=/usr/share/maxos/icons/web.png
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
fonts-jetbrains-mono
mpv
MAXEOF

# Ícones (PNG embutidos)
base64 -d > $C/usr/share/maxos/icons/apps.png <<'B64'
iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAABSUlEQVR42u2YTUrDUBRG72sKgiKo4EK6HnEV7kbdgwgOHLgBuwwnTkQ69Kf1OLmFgC1SE8mrngPhhcf7SHJJ3g0nQkRERET+J+WnQWAcEeQxiohFKYVtyXcCKJvM15bv5cGBU+AKuAPOgP3vbmLofB8FGAENcM5X7oHjXFNqzHd9+HGOJ3nBV2Cex0vOXeaaprZ8HwVocrwBFsB7q/ofOfe47lUcOr+O0SY1yHFvTQcpEbETEeNK850LsFx7m+fzVht6yxuYRsQMaFa0pKHz3TtAbjCHwHTFJvQMTJbrasv32gaBI+ACeACegGtgstypa83/xr/ALnDQblO15/v8HJr2Dr3JxYfO912Isq15EdEH6AP0AfoAfYA+QB+gD9AH6AP0AfoAfYCIPkAfoA/QB+gD9AH6AH2APkAfoA/QB+gD9AEiIiIif5pPvCg6/H8Ctu4AAAAASUVORK5CYII=
B64
base64 -d > $C/usr/share/maxos/icons/arquivos.png <<'B64'
iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAChUlEQVR42u2aPYvUUBSGn5PMijIq2go2gmizpdho4Z+wEETWws5KtBDEn2CxjT9AKws7ezsLQQSbgWWxEQth1m0WP2byWswJDLObMZNNYuKeB8Jlvu6d897zcXNvIAiCIAiCIAiC4AhiRR9IMiABsloGMlNvVHHj6+4z7YUHSDIzk6RjwBVgBEyr2u1j7JpZJikxs6yzAszN/BB4A1wHvrshVQUA+AI8NbPXklIzm3bV9VNvr2nGRPWxJ2nd+0+6YvPiH8ndcwSMgbSmJPgLOAG8lDQErIk8U4VBwfu/58IjAR4AH1yQsu6bf/c2sAH8BNaBTTO7K2lN0qSVOC9bgfJZkXRW0njOfa8eMrTeeT8/vN1oObSTVT1gkZOeH1bxgNx7JsAt4D1w2l9vStoCPrmnNbFGyCtQZma7eXWrKkBmZlNJrJjBp571tyXdA155PhgCb73CNCVAntMk6bmZPflrGV4SAjcOs5iRNPD2mfc39astMkmXDwqHtsrR1Ad+6F4waXNs97LzB619Bi1mYWkWiDclXQLOzcVp3Ys7AaeAF97KK1vlJFibEB6HI19rNJn5B3NGW5HQrQrgImQeDk0thHIPOFNmjNYFyEVo8k7WPa1UterMmrwr9wIhQAgQAoQAIUAIEAKEACFACBAChAAhQAgQAvz/lN0RSn2PLe3Kmd4STJLK2lZWgB0zmzDbzu4L31yIygJorr0v6TPNnuLUzXFmJ9JasKeUAOaf5TN+p6chnrkNa0W27kuCHuN7wFf/0YD+krjx28BHty1bnOl9Avi28kXgEXDB3advFUN+jYHHZrZVdEJ8JCiqXsueE0x6lvRYks/UtafTgiAIgiAIgn/NH2KlDBsMoDD3AAAAAElFTkSuQmCC
B64
base64 -d > $C/usr/share/maxos/icons/codigo.png <<'B64'
iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAEhklEQVR42u2asW9URxDGZ+/dYRBSIrtzSEMREAoSCGFLiCYiShNFgkhYERVgxaGEKiV/AkaisUAiSZMyoUBRipQokewGKsCIColQwCEhIHbu7v3SzMJkee/de/bd+WHvSNa+u9tdz3wz8+3O7hOJEiVKlChRokSJEmVLiquTMkDyRjHnelvKE4Ar+rzZjW9oOwP8BszY77eK8XuBlLeybxQg1AFhH+q79XlFRBCRyVHwVGOInk38X0kAptXw7SLSFpHbOtaVmGPN0hwWoVkW18/kdE+V8D4zYNwRked2DNBwzqW1jwAgcc5hCO2kfm7kAJWKyIcickAjQETkLx1zypOicy4FmnUntETbTwyZpcD+LEIz/b/Sfl1tDwK7+b8c0b7NWkaAer4HjIvIzyKSisiq8WpR/n+hz4mIPNEU2K6/9USkKyI3gSnnXBdo1dXzE8CiemxV22/zljPAKVEuGU//6jdBmkZtE0ltYHoYkbAe45vaTgHLquy/2s6FW9xwpwd8BLwEejrmgn4/Zub1IPSAF8BsLUAIjLdKdozxzT5jT+u4jo497CPGh7rO/1j7dQNwm3UxPlUD2sDRfsqZtPnRhP99YMzWAabfpEmvlQ0FIcd4n6NTZZTS/N8G3DMA/JCVMgaE8Q0HIQjLtRrv9/97lCx9WJ/JG18ShNaoPD+9VuODec6avF4B9hQVQAa4IhCSoZTSRulZZWLP2pWMD7x5w4T/khKfKxk9WSDMGwJ1gzTe/9O5gIkfr8F4v/ztBB4ZAC5XiCALwq0AhKuGY9wgjT8XrPFLwGTeOl/C+4cUyI7Od6LKXEavJnA1BEEBaKzX+MSEvd/d9YA/gImqxgep9L3ZN7wCdlU9CrOhDlzSuTwIs2X064eQC/r19Pmhc66txlARV1/+fmnmviMiT7TkLT2fVpItU0Jj9BkbyIGKRzkjzK6F4Vgh/yeApyb/L1Zdy30doc/fBfXHIvDBQMjQkkkGCL9r9VcKBKPwMV0+O9oeq5j/znDAfIbx4wM9WQ7QXghAWCwLgsn/i8b7zw2fuIq6hA65VcUh6wHBrwj/VAFBQzIB/jQA3CzL2DnGvzLM3xz6SbJRYK4gEorK312qtN9Ina9QO4TGv85Y+4d/0m3qgdIgGOW/NuVv15a//SKnj/HJSG+TTLhlgfDOHsH0nzfh/wjYWZT/FpjaGF8Agt8lLpstcisof+8aAG4Usb+Zf1xXnKwtb7Kh94gBCJ2cIsmDsDcof88WlL+NjHNGb/xCLYzPAOGoKZM9CDOm3xlTTK3mlb/BZelyYPy5Whmfc0r0zJAcwAH97afg+GtbxrW4N36/6bva75C1biAcCS5GPgVawAPz/fWc1cICYG+LR3PqM0AQ/NXYNyYyeqb8PV6wZ/AgnAzeF6j31VhecaQrwHlT/r4EPu6z/LmiOQclQ0FULzK9ZxvOuQ7wuSl/74rI30W3xno5+n6/MxTk82tl8hS4UpeQHqUCO8zzLxriyGaXAkLb/C9AFRBabTYwboQgbN2XIKNEiRIlSpQoUaJEqZ/8B9Tm5yQqf0cfAAAAAElFTkSuQmCC
B64
base64 -d > $C/usr/share/maxos/icons/config.png <<'B64'
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
B64
base64 -d > $C/usr/share/maxos/icons/logo.png <<'B64'
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
B64
base64 -d > $C/usr/share/maxos/icons/musica.png <<'B64'
iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAD9ElEQVR42u2aS4hcVRCG/+ruaQk6ExLE1bgRfJCJgrhSBBVNllkoboUMuBAREdzElfuABHcJGPG5EERm48InUSMquFAJCfjYDAgTVDK+xkx338+FdaA83h57upvJvT3339w+d87tO/Wfqr/q1GmpQYMGDRo0aNBgl8J28mVAOwwLM2PXMA1Yyb0O0C7726wZ3/Lrw8DbwFFgvoSM1iwbf5B/YxU4DtwVQwOwmfKKQMCtwJ9AD+hnZHwFPA0cyJ+tPRnpnweuAX5yg4tg/CB87gFngUeBxVxAa0lGIGA/8Esg4E3gm8wTIhnrwArwyBC9aNeNgH2BAIA7PN7vBk65JgzDKnAaOAR0Mr3o1JWAQ9m8eeCIr/r6EK8AOJfEs84hAHCPu/KefBWBRU+V77guDCPjU+ApF0urOgHzQQQBDpfEdTePbeCAZ4izW+jFckmlWck0+JcLYAH86HF9BFjInpkDrsoLI68ZjgPn3fDLnlI/jO+qAwHDRG4kMtxTXgjf9UGVCSgLgUhCsQ0yusDV/vmZ8MzYBOwkY3PhfSbpFUlnJBXRRkmLko5KWpF0LpJhZptm9ofP3VP7OsDvLwWR64/gGQ96SBybhgdcSQIeyFNXpvhbkfED8F3IBO/XkYD7gsh1tkFGvncYAGfqTEA72/11xvCMt6pcB4xMQMlWeCsyPgF+A74GbvJ9QWtmCBiRjOsnXfVq76RSzjQrUrr0VW5JGpjZaiJ53AZrLQj4HzKYpLtcOwJKyJgIs9eFvdIeEIWqDgcfnSkaneKxiI1Mr/v7M0sA0HKjBz5ecDIum9lGptyVQ2saxnuOXgbek/StpO8lXfDO72EnaHOmNCc0Om4HPmNrvOpFy9o4hVCVjb8tVHebQ4xPTc3zPreoEgGdMQVPQFfSS5L2uXt3Jb0r6aSkS5JukPSkpCVJPUm3+FcU2uFj+Wmvftuvy6ExCfBYydw54MXMEwa1DoHUgwc+Cu6cGhLtcOY/5/f2euynbnAi4N4qENDarvu7ou91l06ufMJ1wcysb2YDM+sBHTNbl/Sazx1436+QVImV70xAXDeMf3bDGCKYF9MwvPPXOtcBPUm/h/HNXva2/rtfsUJSPPffkPScpC+9jhjUVQRXQlxfCNkh9fiSBtzoByJJBI/VNv9nBNyfZYHTwHXZ3CXgCyep53XAtS6S9a0KAwlvuPEbfl0DTgDPAi+H4iiR9HitVz9mA0+H+4HP3bh+SRUY752aCeNLKsIF4PmwyjnWgCdiDVGprtKkJKSmB3BQ0kOS7tQ/54CXJH0s6XUzuzhJ47IO4dAeRTOqCJsiEanpkQoiS9XfrvpNcIMGDRo0aNCgQYOa4G+8SWDstJdqvwAAAABJRU5ErkJggg==
B64
base64 -d > $C/usr/share/maxos/icons/pasta.png <<'B64'
iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAC30lEQVR42u2aPWsUYRSFnzs7EeNG8aMTBBFEm5Qighb+CQtBJBYWgpVoIYg/wSKNP0ArCzt7uxSCCjaBENKIhRANSFCzO8cid2BYdjazm9lxh70HhmFnd9937pl7z/3YhUAgEAgEAoFAIBCYQ1jZG5IMSICslo3M1BpW3Pi61+y0wgMkmZlJ0hHgCrAO9Ce12/fYMbNMUmJm2cwSUHjyXeAdcAP46YZMSgDAV+C5mb2V1DGz/qy6fsfP17WPnurDrqRlXz+ZFZsHbyR3z3VgG+jUJIJ/gUXgtaQuYNPQmUmQllzfK4RHAjwCPjohVd03/+wdYAX4AywDq2Z2T9KCpF4jcV41A+VPRdIpSdsF9716yNBa83V++3ml4dBOxvWAQSy5PozjAbn39IDbwAfghL9elbQBfHFPm0aNkGegzMx28uw2KQGZmfUlMaaC9131NyXdB964HnSB955hpkVArmmS9NLMnh2YhkeEwM3DFDOSUj+/8PX6fjSFTNLlYeHQVDrq+8aP3Qt6Te7tXnZuWO2TNqjC0n4g3pJ0CThbiNO6izsBx4FXfpZntolFsDYiPA7XvdaYpvKnBaOtjOhGCXASMg+HaRVCuQecrLJHVQI6zmhnViq4Cv1NpftMK3aJP8ys5+LVFnyXpEkJ2Cv0AAIeStqacs6uG0eBYwcJbVoSP+eBpcKX77Z46pWNIiBhzpGWDDC2gF/AGb/2ycvWttl2zfuXsTVgoeAdBjwws7U2We8jvW/A6UkIGBS6rufucbvB/5UG80qwtjog8wLGZm2oOayh84qz0n3OvQgGAUFAEBAEBAFBQBAQzdBBaNVEyAchaZ0EzN1EqNgQtXkitDhgR2UCzN/Ln3hbJ0KZ27BQZmsyrJsCdr2XTvkPo/OaRX4B2AQ+u23Z4JMuaycvAk+AC+4+bcsY8mMbeGpmG2W/EM8FyrLXqP8JJi0TPUbomWZ9kBMIBAKBQCAQaBr/AOsVPROwdHEGAAAAAElFTkSuQmCC
B64
base64 -d > $C/usr/share/maxos/icons/sair.png <<'B64'
iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAFQUlEQVR42u1aTWgdVRT+zsxLSjH2IURspRuVNphKQE1bFPwpNJSC4ELxD9RWyMZVFtqFmxbEhTu3fQt159aNv9X0B7ppUVDwt3bThRVbo0mbJul7M5+Ldy49jJPkzX3zE3xzYJh5dyb3nvPdc86937kBaqmllloqEpIByWBgjU97HhTjRe+7SO6ybYNgfKj3F0h29HrevhsI1yc5y1typqpQqCL23JhnAVCvdlUT0qjQGToAXNxXFv9VZt8NkfQGcw0uGgCSkmdGJxkWtUwGRRgvIhSRKA+ltb9IRFjEKhHkbHwoItTnJ91zv2CS3EfyThGJ894rBDkbH5HcRvIEgJMkJ3zXd5KBGj8K4BMA50g+qmM0NlQicQqR3E3yd93cdEh+Q3JTYt/vvj1mNkKzKfwgVLL0MclYv2uTnLb9VO4BOvMdkrsBfAFgG4CbAEIAfwPY0v0scz6IAQwDuKJLJvXeIjmtY4ZVz7zb1u4hOWdmniSPJslPFg9IkKbnTP839T5dKX9Q9xSSd5H80yi3QvI1+80q4bIuACnhdSkBwlRlIJgYPaHKLOv9kL4fWidf9ASA7YvkBMmrhkX+QXJr6YUVQ2lfUQOW9H5M24d7SJg9A5AAYb8mRQf4h6V6gbq9kBwm+TPJyFFabW+slfB8AUiA8I5ZFZZJjvkutz5uE+gG5yUAY5qdlwDMaHvc7wZoLQapRr4L4FfVfxOAt3wJVuDnBBQAr6vxIYCvReRbXRLjwuhjF9hARBYAHFf9YwDPkNzqs/0OsmZ+NXAMwIQCAADHS6zpOSM/AnBN224DcFCfwyI9wH1/UF1PAFwGcNq5f9H1AB1HROQygDNGp6fdPBUJgOv8CWPEWRG5ZolQj7KS0m9WvT83bZMkR7KGQeAZ/6Om7ceMM+qMHdeyWEe3vD4T8YP5fTuAzYUlQaWmMYAmgJ3m1Xees0itSTYAXPAE8aLJAyMA7s9qlw+jEgB2l3c1K8lRL5oBEGnbEW2LMwIwj25FWfTKbI8vpbSKhh5JDAD+AnAoBzYrq+hVqAdYo4d8d5TGVX03T40EVQ4LywFanREACyZmAeAhn2XN1Q1dvc9T7x2akwDgutGLuQNwS2/pqPvCKOGTBPvaFOr9PhP/S1qAKRQA9/150/aYsr+4RACcgfsTy/GiqyUWTYMfURborj15nwX0wEZHtP7o6oVH8qwVrqfAMMkLZvBWWZzc0OkXdexIafFOX0rsq8BRo8CVsiozphJ12kzAbGlVIeOCo2p4J1GZGSpwbFcQeTVRG9xXdlUoTFR1ltUTni0KBDPmPVoXdMafKsX1U7wgINkkedHE4RzJybxBMMY3SZ5Xw1fU+x4uHQA7IMm9GottVewSyQcdCP0WSozb32Eq0Df0PlOq668xM9OJmJwjecAmzixAmOKqA3kHyXMJ41uVGp+yKiRBIMm3STat16hhoTlYcVfo3iX6P6wxb8vvLdNf9f9pkgKCi1GS/IXkGyS3Z+hvC8mXSX6lfcRmtWmZ5bBv4yVPEPTA8gCAD9A9JI0MQ1sAcArASQDfK3G5bljdOIB7ATyuW1wHWFsZZwfAmyLynoYGCyy/950T7ib5vvGCmP+VRc0VcyT/SXkfmecvSe7dUG6/Hgj6/IACMc/s0lbDp9L6zptW5r5PQPcAI9Lf2wFMAXgKwKRy+Gbiz24AWNTw+AzApyLyk11yizh0kYK9IdAaQmTaNqN7kDGeqOD8BmBBROZXA7LIwkIZmyaXuKIev42LPGYrFYCU8EgrxnBDZvZaaqmlllpqqaWWWv6n8i/r+mjgIaL1ZgAAAABJRU5ErkJggg==
B64
base64 -d > $C/usr/share/maxos/icons/terminal.png <<'B64'
iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAElElEQVR42u2aT4hVZRjGf8+5V42wTG1VJLRoldQiTWhlEEhgtEmLIi1hYmij0LJtuxbiosWM6EKIYHLTxj9RLQQplP5BLSx3loYEZpk04733aTHvwY/rOPfcO3ea797OCxdmOHznfO/zPu/f74NaaqmlllpqqeX/Kup3gW1lrZDkZXmx7YbtIneL2pbtZlVDqarFS2Rtr0vW5cQGz29T15K9F5I6AwNgW4ni+4BXgSeAZq4EAC4CJ4GDkq73AkEVfH0D8CGwY8Ti20/A65LOLQbCYgCU/n4aeA6YBdaMiPK3gFXA1WDs1XCPTiUAbDcktW2/CRxNlP8c+AD4M+jmTBRW/BrAK8BeoAWsBo5J2lvqVDWSFhFNz9juxO+LUeG+7fc8L23b121vvFsK190Cn+0HgJ+BB+PRTuBEoNrKVPcC6AAbIxiuDZY+K+nMQixo9qBV+vxGANOqTKX/3vKd2ONcxAEtoMcdiPVKK6U0RigDFF3s9qAAUOUlmdYDlaQ5BNo1kjq8zYhJc4nKK1W6SumZo68MqnwRAecl2yds75LUsd0cewaUlra9GZiJgPO87WckfWm7Kak11gzoSpcG5oBTtvdJatleNbYAhPULST8Au4HfokBaCxyxPSHpVswQNJYMSED4GHgKOB/vmwWmbR+MAKmcBylL2lgZ9CRdiXb5bDRNs8AB29OSOiVYYxkDwt+LmMRsBw4HCP8AE7ZP2V4fIDTGDoDUHYC2pLeAKeCeYMIO4LTtDdFiF2MHQAlCMkuYBCaDCR1gK/CV7S25ucNQNxLzw06AMAXsAa5HinwM+Mj2vfM45ZEdhm6JAKF87zfAX/G/wy0YSxdIqsRm1ABPR1bYFK10G3hX0k2gWLYDjJUEwPaqyAr7gM+A++LRH8B2ScciY2TTNTaHpLjCqrdsTwDTYfECuAK8KOl8jj3CMOYBTaATKe4gcIDbU+TzofyVCIyt7qaqzwGG0oyTyzygFX9PAxOJ8meBFyRdW2gYOeDswMOeOzSXoHzZEu8C3gG2JcofBt5OqsT2AsB1bD8ebnKJ3ueMBh4Jtv2YHtvlMA8gcv0aYErSZJwr3GGp5NBlN/NHbmL+oEWLuEL57P6oIV6TNNPXYccyBkHHBlcDk5Kmoubv9KDp/vj+HLC+4rfm4jv7E+CzmAecBF4ulZfUrkDPQ4lCVWV1rDm04kEwQJCk48DxxDXaPda1Y92M7e+Bh6NfqBIDCuBXSRe6B7Ir4gIxFO17LB7rCkkXgAuDxqAs6oBBrZB0hf02Rc6mDhhWCz1WzVAmomEwQF0vKv29sJ3r6U85gG0ntYP6NnRy1ey7uBxh20dGxfy29yQXO27a3tTVe/RkQCPK2E+AJyP3vmH7cnR6f5PfaXF5RWYn8H6woAmcA365W+bQIu2top//FniU2xePbkbNrwxBKIB1XR3mVklf9506S7rY3mL7skdHSpdtxWyCgYewCQgP2T5q+/cRAOCG7U9tbyubryWli5Q6tjcAm8n7usxFSZfSznMoI68cT3V67LeoGjn7nv3lrv+o3VKppZZaaqmlllpWRv4F/6ctPRvfyc4AAAAASUVORK5CYII=
B64
base64 -d > $C/usr/share/maxos/icons/video.png <<'B64'
iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAEf0lEQVR42u2aTYhVZRzGf88516lFZWjMYhZBELMIK+iDaBUxQii1qxChbAZauougGFeNCLUIlFoEGohRBAVtHCpr4S5B7MNNKbQopxiCMGwGx3vv0+L+Xz3cnPHcyXM/pvPA2Zz7cd7/8z7/z/dAjRo1atSoUaNGjf8n1OsPbGuoDZJcyR/bzm1nw76jtmW7UXajVHbHE7O2Nxd+N0xqcGeZ+rOw9kxSe90E2FbB8BlgN/AA0BhWAQDngXngbUkXb0SCSvj6FuAD4KkRi28/AS9IOrUWCWsRkPz9c2A7cBm4ZUSMvwJsAhZDsYvhHu1SBNjOJbVsTwNHCsZ/BbwD/BVy85AYrLhyYBewB2gCY8BRSXuSTWUjaRbR9KTtdlxfj4r2bc+5g5bti7a3rpbCtVrgs30ncA64Kz56GjgerDaH1PYMaANbIxjeFip9UtLJ66mgcQNZFT+/FMQ0S0up4FKFQqVV4c63Y40rEQd0HTsoSwBdPp6vtzApGh1ktCur2K4pQavY8a8v9pJjezU+ix15zvZx289LasW9KmuJ0mttVCjHTFLb9jbg47i9w/b9wCFJixGUsirdooxU+pGilsMn28AscMb2jCRHuh1Yn5H1QYY/A0tRmChImAAO2z5heyrcot1LEzNKChjrek6SexuYAk7YPmJ7UlIz4kO+kQjoDki7gdeDgETINHDK9qztsXCLrB9u0W+/E/C7pAPAw9G1pd2+A3gDOG17l6R2uEVepVsMIvCMRUX2vaSdwE7gbCFvbwM+jLS5rZA2841CQIr8myJVzoca9kXXluLDjlDDQdvjVaXKQY64rkpc0oqkOeAh4P1CfBgD9gI/2N5bRVwY+Iwv1CDbDUkXJM0AjwOfRNPVBMaBg8B0SpcbhoAgwZ3i8aqffxdXwkqZEd56MPDZXnc5HLPH14B7Y/fTGo8BR8MFWhuBgCT7JtCyPRWGT3Wt7xtgn6Qvq1hEY0C7nheC4AQwF8VQKoxy4EJkhmOSrpQZcY8KAYrAd6vtVyLKjxfk3gLeBeYkLSbCqkqDgyDgsu0nwsj7utYyD7wq6WwY3gBaVbbL/SbAdKbMk133zwL7JX3U5SKVzx4bfTQ8YTIKnSwqv0PAm5JWUpHTzwFJPwhIQ8lm4ZlZVHyzkhaq9vOBFUKR45eB38LwBp3Dle2SZiQtpCHIoMZilSkgOjhJWrb9DPAs8KOkT/vt5wNzgTT6lnQOOHC9ym/Q6EsQjOCWpVb4Zpaya8Sd/0yAuv4oNSuZ7V4rMiejKx56qtArKJ6rnmNd4TWTb+Ng1LYPMyKw/WLhUHfJ9t0FJZZSQC6pafsz4MFoR1+yvQC8B/zN8ByNFxWb0znEfStU0ABOAb+u1ktojfQl4HbgDHAP1146WKLzvoCGkIQM2NxVfD0q6XTPzVSSi+1HbC94dJBctmn75dWk3ysJE3F48ccIEHDJ9he2HyvUG+tPF0Xp2N5CZ2ydD3EMPC/pl5taXkdWyEcoC6is7NXrHzMkg9S1llnF5KhGjRo1atSoUaPGRsM/QVYDHyd2zIIAAAAASUVORK5CYII=
B64
base64 -d > $C/usr/share/maxos/icons/web.png <<'B64'
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
B64
cat > $C/usr/share/maxos/logo.ascii <<'MAXEOF'
                  ...                 
           .-=++**%%*++=:.            
        .+**##*+=--=-=+#@%#+=::.      
       -*#-:.           -=+%@%*:      
     .--. :..::.       :::--**%*:     
   ..:.  :=-+:         .=+==..:**-.   
   -:. ..+%*   -=+##=:   -##.-.:+%-   
  .+: -+ +@    :+#%@#%%-  =@ =+-:##:  
 .+#. :# ##    .@##%-.-:  .@.=# .=@=. 
 -@#.  %.=@    -@@@@:     =@ #- .-@#: 
.:%%:  -%:%*   :*@@@@.   :@-+* . -@*. 
..=@= :-=#+%*.  %+*@@%  =%***:=. =#-. 
  .=#- -+*##@@*##:.+#@##@##*++. -#=.  
   .+#:  -+%@@@#-- . +@@@%*=:  +%+.   
    .-++-  .:=**=   .##+=:   :++:.    
      .+*+=-.   .   ..  .:=+##-       
      .  :=+**+======+*%%**+-:        
            .:-=*##*+=+=:.            
                   . .                
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

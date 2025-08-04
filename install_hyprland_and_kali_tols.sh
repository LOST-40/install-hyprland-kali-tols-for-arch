#!/bin/bash

# This script simulates the installation of a custom Arch Linux distribution
# with Hyprland and Kali Linux tools (via BlackArch) based on the documentation.
# It is meant for demonstration purposes within a sandboxed environment.

# IMPORTANT: This script assumes a base Arch Linux installation is already present
# and that you are running it from within a chrooted environment or with root privileges.

echo "Starting simulated installation of Arch Linux with Hyprland and Kali tools..."

# --- Hyprland Installation and Configuration ---
echo "Installing Hyprland and its dependencies..."
pacman -S --noconfirm hyprland xorg-xwayland wayland libinput xdg-desktop-portal-hyprland

echo "Configuring Hyprland..."
mkdir -p ~/.config/hypr
cat << EOF > ~/.config/hypr/hyprland.conf
# Hyprland configuration

# Monitor
monitor=,preferred,auto,1

# Execute your favorite apps here
exec-once = waybar
exec-once = dunst
exec-once = nm-applet --indicator

# Some default env vars.
env = XCURSOR_SIZE,24

# For all categories, see https://wiki.hypr.land/Configuring/Variables/
input {
    kb_layout = us
    follow_mouse = 1
    touchpad {
        natural_scroll = no
    }
    sensitivity = 1.0 # 0.0 - 1.0, 0.0 = no sensitivity, 1.0 = full sensitivity
}

general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)
    layout = dwindle
}

decoration {
    rounding = 10
    blur {
        enabled = true
        size = 3
        passes = 1
    }
    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

animations {
    enabled = yes

    # Some default animations, but more can be added here
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

dwindle {
    # See https://wiki.hypr.land/Configuring/Dwindle-Layout/
    pseudotile = yes
    preserve_split = yes
}

master {
    # See https://wiki.hypr.land/Configuring/Master-Layout/
    new_is_master = true
}

group {
    # See https://wiki.hypr.land/Configuring/Group-Layout/
    # insert_at = end
}

# Example window rules
# windowrulev2 = float,class:^(kitty)$
# windowrulev2 = fullscreen,class:^(firefox)$

# Example binds
bind = SUPER, Q, killactive,
bind = SUPER, M, exit,
bind = SUPER, E, exec, dolphin
bind = SUPER, V, togglefloating,
bind = SUPER, R, exec, wofi --show drun
bind = SUPER, S, pseudo,
bind = SUPER, W, togglesplit,

# Move focus with mainMod + arrow keys
bind = SUPER, left, movefocus, l
bind = SUPER, right, movefocus, r
bind = SUPER, up, movefocus, u
bind = SUPER, down, movefocus, d

# Switch workspaces with mainMod + [0-9]
bind = SUPER, 1, workspace, 1
bind = SUPER, 2, workspace, 2
bind = SUPER, 3, workspace, 3
bind = SUPER, 4, workspace, 4
bind = SUPER, 5, workspace, 5
bind = SUPER, 6, workspace, 6
bind = SUPER, 7, workspace, 7
bind = SUPER, 8, workspace, 8
bind = SUPER, 9, workspace, 9
bind = SUPER, 0, workspace, 10

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = SUPER SHIFT, 1, movetoworkspace, 1
bind = SUPER SHIFT, 2, movetoworkspace, 2
bind = SUPER SHIFT, 3, movetoworkspace, 3
bind = SUPER SHIFT, 4, movetoworkspace, 4
bind = SUPER SHIFT, 5, movetoworkspace, 5
bind = SUPER SHIFT, 6, movetoworkspace, 6
bind = SUPER SHIFT, 7, movetoworkspace, 7
bind = SUPER SHIFT, 8, movetoworkspace, 8
bind = SUPER SHIFT, 9, movetoworkspace, 9
bind = SUPER SHIFT, 0, movetoworkspace, 10

# Scroll through existing workspaces with mainMod + scroll
bind = SUPER, mouse_down, workspace, e+1
bind = SUPER, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = SUPER, mouse:272, movewindow
bindm = SUPER, mouse:273, resizewindow
EOF

# --- Kali Linux Tools Integration (BlackArch) ---
echo "Adding BlackArch repository..."
cat << EOF >> /etc/pacman.conf
[blackarch]
SigLevel = Optional TrustAll
Server = https://mirror.rackspace.com/blackarch/blackarch/os/
EOF

echo "Installing BlackArch keyring..."
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
./strap.sh

echo "Installing essential Kali Linux tools (nmap, wireshark, metasploit, aircrack-ng)..."
pacman -S --noconfirm nmap wireshark metasploit aircrack-ng

# --- Customization and Automation ---
echo "Creating post-installation script..."
mkdir -p /usr/local/bin
cat << EOF > /usr/local/bin/post_install.sh
#!/bin/bash

echo "Running post-installation script..."

# Update system
pacman -Syu --noconfirm

# Install common utilities
pacman -S --noconfirm git vim htop neofetch

# Enable NetworkManager
systemctl enable NetworkManager
systemctl start NetworkManager

echo "Post-installation script finished."
EOF
chmod +x /usr/local/bin/post_install.sh

echo "Creating custom dotfiles..."
mkdir -p ~/.config/fish
cat << EOF > ~/.config/fish/config.fish
# Fish shell configuration

# Set greeting message
set -g fish_greeting "Welcome to ArchHyprKali!"

# Aliases
alias ls=\'ls --color=auto\'
alias ll=\'ls -lh\'
alias update=\'sudo pacman -Syu\'

# Neofetch on login
neofetch
EOF

cat << EOF > ~/.bashrc
# .bashrc

# Source global definitions
if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi

# User specific aliases and functions
alias ls=\'ls --color=auto\'
alias ll=\'ls -lh\'
alias update=\'sudo pacman -Syu\'

# Neofetch on login
neofetch
EOF

echo "Adding automated tasks..."
cat << EOF >> ~/.bashrc
alias update_system=\"sudo pacman -Syu --noconfirm && sudo pacman -Sc --noconfirm\"
EOF

echo "Simulated installation complete. Please refer to arch_hyprland_kali_documentation.md for details."



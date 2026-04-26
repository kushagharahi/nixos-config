#!/usr/bin/env bash

# Ensure we are targeting workspace 1
# Launch amdgpu_top (Top window)
hyprctl dispatch exec "[workspace 1 silent] kitty -e amdgpu_top --dark"

# Small delay to let the first window register
sleep 0.4

# Force the next split to be vertical (stacking top/bottom)
hyprctl dispatch layoutmsg presel d

# Launch htop (Bottom window)
hyprctl dispatch exec "[workspace 1 silent] kitty -e htop"
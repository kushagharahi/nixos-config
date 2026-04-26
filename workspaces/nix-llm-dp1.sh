#!/bin/bash

# 1. Setup DP-2 (Portrait) by calling the sub-script
bash /home/kusha/nixos-config/workspaces/hw-stats-dp-2.sh

# --- DP-1 (Main Monitor / Workspace 2) ---

# Define the path clearly
TARGET_DIR="~/projects/nix-llm"

# 1. Start kitty and force it to stay in the directory using the --hold flag 
# if it fails, and log any stderr to a file.
hyprctl dispatch exec "[workspace 2 silent] kitty --directory $TARGET_DIR 2> ~/kitty_error.log"

sleep 0.5

# 2. Split for VS Code
hyprctl dispatch layoutmsg presel r
hyprctl dispatch exec "[workspace 2 silent] codium --new-window $TARGET_DIR"

# 3. Focus
hyprctl dispatch workspace 2
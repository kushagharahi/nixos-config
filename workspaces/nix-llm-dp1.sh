#!/usr/bin/env bash

# 1. Setup DP-2 (Portrait) by calling the sub-script
if command -v hw-stats-dp2 >/dev/null 2>&1; then
  hw-stats-dp2
else
  bash "$(dirname "$0")/hw-stats-dp2.sh"
fi

# --- DP-1 (Main Monitor / Workspace 2) ---

# Define the path clearly
TARGET_DIR="$HOME/projects/nix-llm"

# 1. Start kitty and force it to stay in the directory using the --hold flag 
# if it fails, and log any stderr to a file.
hyprctl dispatch exec "[workspace 2 silent] kitty --directory \"$TARGET_DIR\" 2> \"$HOME/kitty_error.log\""

sleep 0.5

# 2. Split for VS Code
hyprctl dispatch layoutmsg presel r
hyprctl dispatch exec "[workspace 2 silent] codium --new-window \"$TARGET_DIR\""

# 3. Focus
hyprctl dispatch workspace 2
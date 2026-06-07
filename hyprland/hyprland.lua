-- --- Variables ---
local mod = "SUPER"

-- --- Monitors ---
hl.monitor({
    output = "DP-1",
    mode = "2560x1440@165",
    position = "auto-center-right",
    scale = 1,
})

hl.monitor({
    output = "DP-2",
    mode = "3840x2160@60",
    position = "0x0",
    scale = 1,
    transform = 1,
})

-- --- Core Configuration ---
hl.config({
    general = {
        -- Order: Top, Right, Bottom, Left
        gaps_out = { 5, 20, 20, 20 },
        resize_on_border = true
    },
    ecosystem = {
        no_donation_nag = true,
    },
    quirks = {
        prefer_hdr = 2,
    },
    cursor = {
        no_hardware_cursors = false,
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },
    decoration = {
        rounding = 10,
    },
    dwindle = {
        preserve_split = true,
        force_split = 0,
    }
})
    
-- --- Workspaces ---
-- DP-1
hl.workspace_rule({ workspace = "2", monitor = "DP-1", default = true })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
hl.workspace_rule({ workspace = "4", monitor = "DP-1" })
hl.workspace_rule({ workspace = "5", monitor = "DP-1" })
hl.workspace_rule({ workspace = "6", monitor = "DP-1" })

-- DP-2: Forced Hamburger Stack
local dp2_workspaces = {"1", "7", "8", "9", "10"}
for _, id in ipairs(dp2_workspaces) do
    hl.workspace_rule({ 
        workspace = id,
        monitor = "DP-2", 
        default = (id == "1"), 
        layout_opts = { orientation = "top" } 
    })
end

-- Special Workspace
hl.workspace_rule({ workspace = "special:>_", on_created_empty = "kitty --class quake-terminal" })

-- --- Autostart (Exec Once) ---
-- Replaces old exec-once by firing on startup
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("ashell")
    hl.exec_cmd("swaync")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd([[swaybg -i "$(find ~/pictures/wallpapers/ -type f | shuf -n 1)" -m fill]])
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("hyprsunset --temperature 3000")
    hl.exec_cmd("udiskie &")
end)

-- --- Window Rules ---
hl.window_rule({
    match = {
        class = "^(quake-terminal)$",
        workspace = "name:special:>_"
    },
    float = true,
    size = "(monitor_w*0.8) (monitor_h*0.4)",
    move = "(monitor_w*0.1) 0",
    dim_around = true
})

-- --- Keybinds ---

-- System & Utilities
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exec_cmd([[hyprctl activewindow | grep pid | cut -d ' ' -f 2 | xargs kill -9]]))
hl.bind(mod .. " + M", hl.dsp.exit())
hl.bind(mod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mod .. " + V", hl.dsp.exec_cmd([[cliphist list | rofi -dmenu | cliphist decode | wl-copy]]))
hl.bind(mod .. " + N", hl.dsp.exec_cmd([[pgrep -x hyprsunset > /dev/null && pkill hyprsunset || hyprsunset --temperature 3000]]))

-- Screenshots
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(mod .. " + R", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))

-- Navigation (Focus)
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Window Snapping / Moving
hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

hl.bind(mod .. " + SHIFT + CTRL + left", hl.dsp.window.move({ monitor = "l" }))
hl.bind(mod .. " + SHIFT + CTRL + right", hl.dsp.window.move({ monitor = "r" }))

-- Window Resizing (Repeating)
hl.bind(mod .. " + CTRL + right", hl.dsp.window.resize({ x = 30, y = 0, relative = true }),  { repeating = true })
hl.bind(mod .. " + CTRL + left",  hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + up",    hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + down",  hl.dsp.window.resize({ x = 0, y = 30, relative = true }),  { repeating = true })
-- Toggle Split
hl.bind(mod .. " + T", hl.dsp.exec_cmd("hyprctl dispatch togglesplit"))

-- Special Workspace
hl.bind("SUPER + Escape", hl.dsp.workspace.toggle_special(">_"))

-- Cycle through workspaces (Mod + Alt + Left/Right)
hl.bind(mod .. " + ALT + right", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mod .. " + ALT + left", hl.dsp.focus({ workspace = "m-1" }))

-- --- Workspace Switching Logic ---
-- This native loop replaces all 30 lines of workspace number binds
for i = 1, 10 do
    local key = i % 10 -- Maps the 10th workspace to key '0'
    
    -- Mod + Number -> Switch Workspace
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = tostring(i) }))
    
    -- Mod + Shift + Number -> Move Window to Workspace
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(i) }))
    
    -- Mod + Alt + Number -> Jump to Workspace
    hl.bind(mod .. " + ALT + " .. key, hl.dsp.focus({ workspace = tostring(i) }))
end
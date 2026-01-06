## NixOS

Must do Lanzaboote setup for secure boot: https://nix-community.github.io/lanzaboote/introduction.html

Build after config change

```bash
sudo nixos-rebuild switch --flake .
```

Update flake lock
```bash
nix flake update
```

Clear out old NixOS generations
```bash
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +1
```

Collect Garbage

After deleting the generations, you need to actually remove the files from the disk:
```bash
sudo nix-collect-garbage -d
```

Show FPS in games, add to steam game properties:
```
mangohud %command%
```

for elden ring, starts hidden right shift + f12 starts it
```
MANGOHUD=1 MANGOHUD_DLSYM=1 MANGOHUD_CONFIG="no_display=1" %command%
``` 

starting and stopping sunshine is via systemd
```bash
systemctl --user start sunshine
```
```bash
systemctl --user stop sunshine
```

todo:
- notes sync with fastmail
- faster/more targeted builds
- secret management
- move to modules?
- file manager gui
- fish like autocomplete and syntax highlighting
- weather widget
- bump CUPs so printing works again: github.com/nixos/nixpkgs/issues/473491
- sunshine improvements
  - virtual monitor with native resolution
  - prevent screenlock while sunshine has an active connection
- dota needed: `xrandr --output DP-1 --primary` figure out why

- convert pi1 pihole to nix
- convert pi3 mainsail/klipper to nix
- convert x86 k3s debian box to nix
## NixOS

Build after config change

```
sudo nixos-rebuild switch --flake
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
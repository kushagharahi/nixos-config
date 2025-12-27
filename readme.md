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
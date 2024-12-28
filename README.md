# Running VM

```
nixos-rebuild build-vm --flake .#test
export QEMU_NET_OPTS="hostfwd=tcp::2221-:22"
result/bin/run-nixos-vm
```

## SSHing into machine

```
ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no admin@localhost -p 2221
```

# Bootstrapping Windows WSL2

Install Nix as per instructions on site

Run this (replacing the host/user combo as necessary)
```
nix-shell -p home-manager
home-manager switch --extra-experimental-features nix-command --extra-experimental-features flakes --flake ".#cwilliams@personal-pc-win"
```

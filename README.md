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

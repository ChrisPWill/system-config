# Starter Config

if suggestions don't work, first make sure
you have TypeScript LSP working in your editor

if you do not want typechecking only suggestions

```json
// tsconfig.json
"checkJs": false
```

types are symlinked to:
/home/cwilliams/.local/share/com.github.Aylur.ags/types

# Watch mode

Fun command to run ags in watch mode when updating config:

```
rg --files | nix-shell -p entr --run "entr -r ags"
```

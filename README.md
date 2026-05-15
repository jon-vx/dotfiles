# dotfiles

Configs for a dual X11/Wayland Linux setup. Everything shares the **Domino Still Life** palette — warm earth tones (brass, paper, olive, oxidized wood).

## Software

- **Ghostty** — terminal · JetBrainsMono Nerd Font, 96% opacity, background blur
- **Neovim** — editor · `lazy.nvim`, LSP via mason, treesitter, telescope, mini.nvim, inline Domino Still Life theme
- **i3** — window manager (X11) · vim-style navigation, 10/18 gaps
- **sway** — window manager (Wayland) · same bindings as i3, `caps:swapescape`
- **waybar** — status bar (Wayland) · Roman-numeral workspaces, mako DND toggle, custom `=^.^=` cat module
- **mako** — notifications · per-urgency styling, DND mode
- **fuzzel** — app launcher (Wayland) · fuzzy match, Gruvbox icons
- **tmux** — multiplexer · vim pane navigation, mouse on, base-index 1
- **bash** — shell · `n` / `y` / `ll` aliases, fzf-powered `j` directory jumper

## Layout

| Repo path | Symlinks into |
|-----------|---------------|
| `.bashrc`, `.gitconfig`, `.profile`, `.tmux.conf`, `.xprofile` | `~/` |
| `fuzzel/`, `ghostty/`, `i3/`, `mako/`, `nvim/`, `sway/`, `waybar/` | `~/.config/<dir>/` |

## Setup on a new machine

```bash
git clone https://github.com/jon-vx/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Files at $HOME
for f in .bashrc .gitconfig .profile .tmux.conf .xprofile; do
  ln -sf ~/dotfiles/$f ~/$f
done

# Subdirectories under ~/.config
for d in fuzzel ghostty i3 mako nvim sway waybar; do
  mkdir -p ~/.config/$d
  for f in ~/dotfiles/$d/*; do
    ln -sf "$f" ~/.config/$d/$(basename "$f")
  done
done
```

After editing any config, `cd ~/dotfiles && git commit -am "…" && git push` — the symlinks mean live edits show up in `git status`.

## Common bindings (i3 / sway)

| Binding | Action |
|---------|--------|
| `Mod+Return` | terminal |
| `Mod+d` | launcher (fuzzel on sway, rofi on i3) |
| `Mod+h/j/k/l` | focus pane |
| `Mod+Shift+h/j/k/l` | move pane |
| `Mod+1`–`Mod+0` | switch workspace |
| `Mod+a` / `Mod+u` / `Mod+n` | Claude.ai / Discord / Zen browser |
| `Mod+f` | fullscreen |
| `Mod+r` | resize mode |
| `Mod+Shift+x` | lock screen |
| `Print` / `Shift+Print` | screenshot (region / save) |

# How to config

## Install

### 1. system dependencies

**macOS**
```sh
xcode-select --install
brew install neovim tree-sitter-cli ripgrep node
```

**Arch / Manjaro**
```sh
sudo pacman -S neovim base-devel git curl tar tree-sitter-cli ripgrep nodejs npm
```

**Debian / Ubuntu**
```sh
sudo apt install build-essential git curl tar ripgrep nodejs npm
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage
chmod +x nvim-linux-x86_64.appimage && sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
cargo install --locked tree-sitter-cli
```

> Do **not** install tree-sitter-cli from npm : nvim-treesitter needs the real CLI.

| dependency | needed for |
|---|---|
| ruby + gem | the `erb_formatter` formatter for `.erb` files |

### 2. clone and start

```sh
git clone git@github.com:FtAlama/nvim-0.11-config.git ~/.config/nvim
nvim
```

## Command

`space` is the leader key.

### files and search

| key | action |
|---|---|
| `space + e` | file tree (neo-tree) — in the tree, `a` creates a file, end with `/` for a directory |
| `space + p` | find files |
| `space + fg` | live grep |
| `space + b` | open buffers |
| `space + *` | search the word under the cursor |

### navigation

| key | action |
|---|---|
| `space + s` | **go to a function** — symbols of the current file |
| `space + S` | symbols of the whole project |
| `gd` | go to definition |
| `space + i` | go to implementation |
| `space + l` | references |
| `ctrl + o` | **go back where you were** (built-in jumplist) |
| `ctrl + i` | go forward again |

### problems

| key | action |
|---|---|
| `space + d` | show the problem under the cursor |
| `space + D` | list every problem of the project |
| `]d` / `[d` | next / previous problem (built-in) |

### code

| key | action |
|---|---|
| `space + f` | format the file (or the selection in visual mode) |
| `space + ca` | code action |
| `D` | hover documentation |
| `grn` | rename the symbol (built-in) |

### folding

Collapse a function to its signature only.

| key | action |
|---|---|
| `space + z` | fold / unfold the function under the cursor |
| `space + Z` | fold / unfold **every** function at once |

```
 3 | +--  8 lines: int ft_func(int a, int b)
```

Both keys toggle : press again to get back. The built-in `zc`, `zo`, `za`, `zM`,
`zR` still work if you prefer them.

Files always open fully unfolded (`foldlevel=99`). Folding only applies to
filetypes that have a treesitter parser — plain text, neo-tree and the like are
untouched.

### C/C++ specific

| key | action |
|---|---|
| `space + h` | switch between `.cpp` and `.hpp` (clangd) |
| `space + th` | toggle inlay hints (parameter names and types) |

`:LspClangdShowSymbolInfo` also shows the type info of the symbol under the cursor.

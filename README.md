# How to config

## Install

### 1. system dependencies

**macOS**
```sh
xcode-select --install
brew install neovim ripgrep tree-sitter-cli
```

**Arch / Manjaro**
```sh
sudo pacman -S neovim git curl tar ripgrep
```

**Debian / Ubuntu**
```sh
sudo apt install git curl tar ripgrep
```

Install Neovim 0.12 or newer using your distribution's package manager, Homebrew, or the official release for your OS and architecture. Treesitter parsers are optional; to use them, install `tree-sitter-cli` (>= 0.26.1) and a C compiler such as Clang. macOS users can use Xcode Command Line Tools and Homebrew; Linux users can install Clang and the CLI from their package manager. If unavailable, the CLI can be built with Cargo after installing Rust.

> Do **not** install tree-sitter-cli from npm : nvim-treesitter needs the real CLI.

Node.js/npm are only needed for JavaScript-based language servers or formatters you choose to install. Ruby and the `erb-formatter` gem are only needed for ERB formatting; its executable is `erb-format`.

### 2. clone and start

```sh
git clone git@github.com:FtAlama/nvim-0.11-config.git ~/.config/nvim
nvim
```

On first launch, `lazy.nvim` downloads the plugins. LSP servers and formatters are not installed automatically; use `:Mason` to browse packages and `:MasonInstall <package>` to install them. The configured LSP servers are enabled automatically only after you install them. Treesitter parsers are installed the first time you open a supported filetype.

For example, use `:MasonInstall lua-language-server clangd vim-language-server html-lsp css-lsp stylua clang-format` for the configured LSP servers and formatters. Install `prettier` from Mason if Node.js/npm is available. For ERB formatting, install Ruby and run `gem install erb-formatter`.

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

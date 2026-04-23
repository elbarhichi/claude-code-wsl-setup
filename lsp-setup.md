# LSP Setup for Claude Code on WSL2

## What This Does

Installs language server plugins that give Claude Code code intelligence — autocomplete, hover types, go-to-definition, find references — directly inside the Claude Code CLI.

## Install LSP Binaries

```bash
# Python (pyright)
pip install pyright

# TypeScript
npm install -g typescript-language-server typescript

# Go (requires Go 1.21+)
go install golang.org/x/tools/gopls@latest
```

> Make sure the installed binaries are on your `PATH` in `~/.bashrc` or `~/.zshrc`.

## Install Claude Code Plugins

This step must be done **inside Claude Code** via the plugin UI — it cannot be automated from bash.

1. Open Claude Code
2. Type `/plugins` and search for each plugin
3. Install at **user scope**:

| Plugin | Language |
|--------|----------|
| `pyright-lsp@claude-plugins-official` | Python |
| `typescript-lsp@claude-plugins-official` | TypeScript / JavaScript |
| `gopls-lsp@claude-plugins-official` | Go |

## Enable in settings.json

After installing, add to `~/.claude/settings.json`:

```json
"enabledPlugins": {
  "pyright-lsp@claude-plugins-official": true,
  "typescript-lsp@claude-plugins-official": true,
  "gopls-lsp@claude-plugins-official": true
}
```

## Verify

Open a Python or TypeScript file in your project and ask Claude Code to hover over a symbol or find references — if LSP is active, it will use real code intelligence instead of reading the file manually.

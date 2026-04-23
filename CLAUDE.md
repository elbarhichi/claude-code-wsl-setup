# CLAUDE.md

This repo contains fixes and config for Claude Code running on WSL2 with VS Code Remote. When asked to "set this up", follow the steps below exactly.

## What This Repo Fixes

| File | What it configures |
|------|-------------------|
| `image-paste.md` | `~/.local/bin/clip2png` + `~/.claude/keybindings.json` (Alt+V) + `SessionStart` hook |
| `shift-enter.md` | VS Code `keybindings.json` (Windows-side, manual step) |
| `browser.md` | `BROWSER` env var in `~/.bashrc` |
| `lsp-setup.md` | LSP plugins in `~/.claude/settings.json` |
| `statusline.md` | `~/.claude/statusline-command.sh` + `statusLine` in `~/.claude/settings.json` |
| `mcp-setup.md` | DeepWiki MCP server (user-scoped HTTP) |
| `settings.md` | `attribution` field in `~/.claude/settings.json` |

## Automatic Setup Steps (Claude does these)

Read each `*.md` file, then execute in order:

### 1. Dependencies
```bash
sudo apt-get install -y wl-clipboard imagemagick jq
```

### 2. clip2png script
Copy `scripts/clip2png` to `~/.local/bin/clip2png` and make it executable:
```bash
cp scripts/clip2png ~/.local/bin/clip2png
chmod +x ~/.local/bin/clip2png
```

### 3. statusline script
Copy `scripts/statusline-command.sh` to `~/.claude/statusline-command.sh` and make it executable:
```bash
cp scripts/statusline-command.sh ~/.claude/statusline-command.sh
chmod +x ~/.claude/statusline-command.sh
```

### 4. ~/.claude/keybindings.json
Create or merge with exact content from `image-paste.md`.

### 5. ~/.claude/settings.json
Merge these fields (do NOT overwrite existing content):
- `hooks.SessionStart` — clip2png daemon
- `statusLine` — statusline script
- `attribution` — disable co-authored-by
- `enabledPlugins` — LSP plugins

### 6. BROWSER in ~/.bashrc
Ask the user which browser they use and add the correct path. Common paths:
- Edge: `/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe`
- Chrome: `/mnt/c/Program Files/Google/Chrome/Application/chrome.exe`
- Brave: `/mnt/c/Users/<username>/AppData/Local/BraveSoftware/Brave-Browser/Application/brave.exe`

### 7. MCP: DeepWiki
```bash
claude mcp add -s user -t http deepwiki https://mcp.deepwiki.com/mcp
```

### 8. LSP plugins
Install via Claude Code plugin UI (cannot be done from bash):
- `pyright-lsp@claude-plugins-official`
- `typescript-lsp@claude-plugins-official`
- `gopls-lsp@claude-plugins-official`

Tell the user: *"Open Claude Code, go to /plugins, search and install: pyright-lsp, typescript-lsp, gopls-lsp at user scope."*

## Manual Steps (user must do these)

### Shift+Enter in VS Code (Windows-side)
Cannot be done automatically — VS Code keybindings live on the Windows side.

Tell the user to:
1. Open VS Code
2. Press `Ctrl+Shift+P` → **"Preferences: Open Keyboard Shortcuts (JSON)"**
3. Add:
```json
{
    "key": "shift+enter",
    "command": "workbench.action.terminal.sendSequence",
    "args": { "text": "\r" },
    "when": "terminalFocus"
}
```

### Source ~/.bashrc
```bash
source ~/.bashrc
```

## Key Technical Notes

**clip2png singleton**: The script uses a PID file (`/tmp/clip2png.pid`) to ensure only one instance runs. The SessionStart hook fires for every subagent — without the singleton guard, multiple instances pile up and cause lag.

**clip2png polling**: WSLg does not support `wl-paste --watch`. The script polls every 1 second instead. The hook command uses `nohup ... > /dev/null 2>&1 &` — the redirect must come before `&` or Claude Code hangs waiting for stdout to close.

**statusline performance**: The script runs on every Claude Code event. All data comes from stdin JSON (zero external calls). Git branch is cached for 5 seconds using `session_id` from stdin as the cache key.

**VS Code Remote-WSL**: `/terminal-setup` won't work — it detects a remote session and can't install keybindings. The Windows-side manual step is required.

**Enterprise PowerShell CLM**: In environments where PowerShell Constrained Language Mode is enforced (common in enterprise), tools that use `Add-Type` (like `wsl-screenshot-cli` and balloon notification scripts) will fail silently. Use `clip2png` instead — it uses `wl-paste` (WSLg Wayland), no PowerShell needed.

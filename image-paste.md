# Image Paste on WSL2

## Problem

Pasting images into Claude Code doesn't work on WSL2. The Windows clipboard is not directly accessible as PNG from WSL.

## Solution

`clip2png` — a bash polling script that watches the WSL clipboard every 1 second. When it detects an image (PNG or BMP), it saves it to `/tmp/clip2png-last.png` and makes it available to Claude Code via the `chat:imagePaste` action.

**Dependencies**: `wl-clipboard`, `imagemagick`

```bash
sudo apt-get install -y wl-clipboard imagemagick
```

---

## Install

Copy `scripts/clip2png` to `~/.local/bin/clip2png`:

```bash
cp scripts/clip2png ~/.local/bin/clip2png
chmod +x ~/.local/bin/clip2png
```

---

## Auto-start via SessionStart hook

Add to `~/.claude/settings.json`:

```json
"hooks": {
  "SessionStart": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "bash -c 'nohup ~/.local/bin/clip2png > /dev/null 2>&1 &'"
        }
      ]
    }
  ]
}
```

> **Do not add a `SessionEnd` hook.** Claude Code fires `SessionStart`/`SessionEnd` for every Task tool subagent — a stop hook would kill the daemon mid-session.

> **The `> /dev/null 2>&1` must come before `&`.** Without it, the hook's stdout pipe never closes and Claude Code hangs.

---

## Keybinding (Alt+V)

Create or update `~/.claude/keybindings.json`:

```json
{
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "alt+v": "chat:imagePaste"
      }
    }
  ]
}
```

> The top level must be an object with a `bindings` array — a bare JSON array silently fails to load.

---

## Usage

1. Take a screenshot on Windows (Win+Shift+S or PrintScreen)
2. Wait ~1 second for clip2png to detect it
3. Press **Alt+V** in Claude Code

---

## Why not wsl-screenshot-cli?

`wsl-screenshot-cli` uses a PowerShell subprocess with `Add-Type` (.NET clipboard API). In enterprise environments with PowerShell Constrained Language Mode (CLM) enforced, `Add-Type` is blocked and the tool silently fails. `clip2png` uses `wl-paste` (WSLg Wayland) — no PowerShell required.

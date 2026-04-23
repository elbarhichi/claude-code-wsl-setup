# Shift+Enter: Insert Newline in Claude Code (WSL2 + VS Code)

## Problem

Shift+Enter submits the prompt instead of inserting a newline when using Claude Code in VS Code's integrated terminal connected to WSL2.

## Fix

This is a **manual step** — VS Code keybindings live on the Windows host and cannot be configured automatically from WSL.

### Steps

1. Open VS Code
2. Press `Ctrl+Shift+P` → type **"Preferences: Open Keyboard Shortcuts (JSON)"** → Enter
3. Add this entry to the JSON array:

```json
{
    "key": "shift+enter",
    "command": "workbench.action.terminal.sendSequence",
    "args": { "text": "\r" },
    "when": "terminalFocus"
}
```

4. Save the file

Shift+Enter will now insert a newline in Claude Code without submitting.

---

## Why not `/terminal-setup`?

Claude Code's `/terminal-setup` command detects VS Code Remote sessions and refuses to install keybindings automatically. The Windows-side manual step is required.

---

## Fallback (no setup needed)

Use `\` + `Enter` — press backslash then Enter to insert a newline. Works everywhere without any configuration.

# claude-code-wsl-setup

Claude Code quality-of-life fixes for WSL2: image paste, keybindings, browser, LSP, and MCP.

## What's Included

| Fix | What it does |
|-----|-------------|
| Image paste (Alt+V) | Paste screenshots from Windows clipboard into Claude Code |
| Shift+Enter newline | Insert newlines without submitting (VS Code) |
| Browser | Open links in your Windows browser |
| LSP plugins | Code intelligence (Python, TypeScript, Go) |
| Status bar | Show project, branch, context usage, session cost |
| MCP: DeepWiki | Ask Claude questions about any GitHub repo |

## Setup

### Option 1: Let Claude do it

Clone this repo, open Claude Code in the repo directory, and say:

```
set this up
```

Claude will read the docs and configure everything automatically. It will tell you which steps require manual action on your part.

### Option 2: Manual

Follow each `*.md` file in order.

## Requirements

- WSL2 (Ubuntu)
- VS Code with Remote-WSL extension
- Windows 11 (for WSLg clipboard support)

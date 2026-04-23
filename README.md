# Claude Code WSL Setup

Fixes for the most common Claude Code papercuts on WSL2 + VS Code.

## What it fixes

**Image paste** — copy a screenshot on Windows with Win+Shift+S, press Alt+V in Claude Code and it just works. The Windows clipboard gives BMP, not PNG — converted automatically. Works even in enterprise environments where PowerShell Constrained Language Mode is enforced.

**Shift+Enter newline** — insert a newline without submitting your prompt, in VS Code's integrated terminal.

**Windows browser** — open links and OAuth flows in your existing Windows browser instead of failing silently from WSL2.

**LSP code intelligence** — connect Claude Code to language servers (Python, TypeScript, Go) so it finds functions in milliseconds instead of grepping through files. Saves tokens and gives accurate results.

**Status bar** — shows current directory, git branch, context window usage bar, and session cost — color-coded, zero lag, no external API calls.

**DeepWiki MCP** — ask Claude questions about any GitHub repository and get answers grounded in the actual source code.

## Setup

```bash
git clone https://github.com/elbarhichi/claude-code-wsl-setup.git
cd claude-code-wsl-setup
claude
```

Then prompt:

```
Set this up
```

Claude will read the docs and configure everything automatically. It will tell you which steps require manual action on your part (VS Code keybinding on the Windows side, browser path, LSP plugins via UI).

## What's included

| File | Fix |
|------|-----|
| `image-paste.md` | Alt+V image paste — BMP→PNG converter + keybinding |
| `shift-enter.md` | Shift+Enter newline in VS Code integrated terminal |
| `browser.md` | Open links in your Windows browser via `BROWSER` env var |
| `lsp-setup.md` | LSP plugins — Python, TypeScript, Go code intelligence |
| `statusline.md` | Status bar — directory, git branch, context bar, session cost |
| `mcp-setup.md` | DeepWiki MCP server |
| `settings.md` | Disable `Co-authored-by: Claude` git attribution |

## Scripts

| Path | Contents |
|------|----------|
| `scripts/clip2png` | Clipboard polling daemon — BMP→PNG conversion |
| `scripts/statusline-command.sh` | Status bar script |

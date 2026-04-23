# Status Bar for Claude Code

## What It Shows

```
project | branch | Sonnet | [████░░░░░░] 42% | session: $0.023 · 4m 12s
```

- **`project`** — current directory name
- **`branch`** — git branch (omitted outside git repos)
- **`model`** — current Claude model (e.g. Sonnet, Opus)
- **`[bar] %`** — context window usage (green < 50%, yellow < 80%, red ≥ 80%)
- **`session: $X · Xm Xs`** — estimated session cost and elapsed time (from Claude Code's local tracking, no API call)

All data comes from the JSON Claude Code pipes to stdin — zero external calls, no lag.

---

## Install

Copy `scripts/statusline-command.sh` to `~/.claude/`:

```bash
cp scripts/statusline-command.sh ~/.claude/statusline-command.sh
chmod +x ~/.claude/statusline-command.sh
```

Requires `jq`:

```bash
sudo apt-get install -y jq
```

---

## Configure

Add to `~/.claude/settings.json`:

```json
"statusLine": {
  "type": "command",
  "command": "bash ~/.claude/statusline-command.sh"
}
```

---

## Performance Notes

- Git branch is cached for 5 seconds using `session_id` from stdin as the cache key — avoids running `git` on every event
- All data (model, cost, duration) comes directly from stdin — no API calls
- Total script runtime: ~20ms

> **VS Code Remote-WSL note**: Even a fast statusline script can cause visible lag in VS Code Remote sessions due to the WSL2 ↔ Windows communication overhead. If you notice input lag or UI freezes, disable the status bar by removing the `statusLine` field from `settings.json`.

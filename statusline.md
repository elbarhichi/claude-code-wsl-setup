# Status Bar for Claude Code

## What It Shows

```
project | branch | [████░░░░░░] 42% | session: $0.023
```

- **`project`** — current directory name
- **`branch`** — git branch (omitted outside git repos)
- **`[bar] %`** — context window usage (green < 50%, yellow < 80%, red ≥ 80%)
- **`session: $X`** — estimated cost for the current session (from Claude Code's local tracking, no API call)

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
- Session cost comes directly from `cost.total_cost_usd` in stdin — no API call
- Total script runtime: ~20ms

> **VS Code Remote-WSL note**: Even a fast statusline script can cause visible lag in VS Code Remote sessions due to the WSL2 ↔ Windows communication overhead. If you notice input lag or UI freezes, disable the status bar by removing the `statusLine` field from `settings.json`.

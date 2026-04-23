# Claude Code Settings

## Disable Co-authored-by Attribution

By default Claude Code adds `Co-authored-by: Claude` to commits and PRs. To disable:

Add to `~/.claude/settings.json`:

```json
"attribution": {
  "commit": "",
  "pr": ""
}
```

Empty strings disable the attribution entirely.

> The correct field is `"attribution"`. The deprecated `includeCoAuthoredBy` key and non-existent `gitAttribution` key have no effect.

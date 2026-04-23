# Browser: Open Links in Windows Browser from WSL2

## Problem

Claude Code can't open URLs in a browser from WSL2 — the `BROWSER` environment variable isn't set, so links either fail or open in a WSL text browser.

## Fix

Set `BROWSER` in `~/.bashrc` to point to your Windows browser executable via `/mnt/c/...`.

### Common paths

| Browser | Path |
|---------|------|
| Edge | `/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe` |
| Chrome | `/mnt/c/Program Files/Google/Chrome/Application/chrome.exe` |
| Brave | `/mnt/c/Users/<username>/AppData/Local/BraveSoftware/Brave-Browser/Application/brave.exe` |
| Firefox | `/mnt/c/Program Files/Mozilla Firefox/firefox.exe` |

### Add to `~/.bashrc`

```bash
export BROWSER="/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"
```

Then reload:

```bash
source ~/.bashrc
```

> Replace the path with your actual browser. Ask the user which browser they use before adding this line.

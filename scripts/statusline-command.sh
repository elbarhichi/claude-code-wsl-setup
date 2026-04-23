#!/usr/bin/env bash
# Claude Code status line
# Format: dir | branch | [bar] % | session: $X

input=$(cat)

IFS=$'\t' read -r cwd ctx_pct session_cost session_id < <(
  printf '%s' "$input" | jq -r '[
    .workspace.current_dir // .cwd // "",
    .context_window.used_percentage // "",
    .cost.total_cost_usd // "",
    .session_id // ""
  ] | @tsv'
)

parts=()

pct_color() {
  local pct=$1
  if   [ "$pct" -lt 50 ]; then printf '\033[32m'
  elif [ "$pct" -lt 80 ]; then printf '\033[33m'
  else                          printf '\033[31m'
  fi
}

# ── 0. Project dir basename ───────────────────────────────────────────────────
parts+=("$(basename "${cwd:-$PWD}")")

# ── 1. Git branch (cached 5s per session) ─────────────────────────────────────
if [ -n "$cwd" ] && [ -n "$session_id" ]; then
  git_cache="/tmp/statusline-git-${session_id}"
  if [ ! -f "$git_cache" ] || [ $(( $(date +%s) - $(stat -c %Y "$git_cache") )) -gt 5 ]; then
    git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null > "$git_cache" || true
  fi
  branch=$(cat "$git_cache" 2>/dev/null)
  [ -n "$branch" ] && parts+=("$branch")
fi

# ── 2. Context window bar ─────────────────────────────────────────────────────
if [ -n "$ctx_pct" ]; then
  pct=$(printf '%.0f' "$ctx_pct")
  color=$(pct_color "$pct")
  filled=$(( pct * 10 / 100 ))
  [ "$filled" -gt 10 ] && filled=10
  empty=$(( 10 - filled ))
  bar=""
  for (( i=0; i<filled; i++ )); do bar="${bar}█"; done
  for (( i=0; i<empty;  i++ )); do bar="${bar}░"; done
  parts+=("$(printf "${color}[%s] %d%%\033[0m" "$bar" "$pct")")
fi

# ── 3. Session cost (from stdin, zero latency) ────────────────────────────────
if [ -n "$session_cost" ] && [ "$session_cost" != "0" ]; then
  parts+=("$(printf '\033[33msession: $%.3f\033[0m' "$session_cost")")
fi

# ── Join with " | " and print ─────────────────────────────────────────────────
out=""
for part in "${parts[@]}"; do
  [ -z "$out" ] && out="$part" || out="${out} | ${part}"
done

printf '%b\n' "$out"

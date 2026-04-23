#!/usr/bin/env bash
# Claude Code status line
# Format: dir | branch | model | [bar] % | session: $X · Xm Xs

input=$(cat)

IFS=$'\t' read -r cwd ctx_pct session_cost session_id model_name duration_ms < <(
  printf '%s' "$input" | jq -r '[
    .workspace.current_dir // .cwd // "",
    .context_window.used_percentage // "",
    .cost.total_cost_usd // "",
    .session_id // "",
    .model.display_name // "",
    .cost.total_duration_ms // ""
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

# ── 2. Model name ─────────────────────────────────────────────────────────────
[ -n "$model_name" ] && parts+=("$model_name")

# ── 3. Context window bar ─────────────────────────────────────────────────────
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

# ── 4. Session cost + duration ────────────────────────────────────────────────
cost=${session_cost:-0}
if [ -n "$duration_ms" ]; then
  mins=$(( duration_ms / 60000 ))
  secs=$(( (duration_ms % 60000) / 1000 ))
  parts+=("$(printf '\033[33msession: $%.3f · %dm %ds\033[0m' "$cost" "$mins" "$secs")")
else
  parts+=("$(printf '\033[33msession: $%.3f\033[0m' "$cost")")
fi

# ── Join with " | " and print ─────────────────────────────────────────────────
out=""
for part in "${parts[@]}"; do
  [ -z "$out" ] && out="$part" || out="${out} | ${part}"
done

printf '%b\n' "$out"

#!/usr/bin/env python3
"""
Claude Code status line — single line:
  🤖 Model  🌿 branch +S ~M  •  project  │  ▓▓▓░░ XX% ctx  💰 $X.XX  │  5h: XX% ⏰Xh  7d: XX% ⏰Xd

Context bar colour: green < 70%, yellow 70–89%, red ≥ 90%
Rate limit colour:  green < 50%, yellow 50–79%, red ≥ 80%
"""

import json
import sys
import subprocess
import os
import time

# ── ANSI colours ──────────────────────────────────────────────────────────────
GREEN = "\033[32m"
YELLOW = "\033[33m"
RED = "\033[31m"
CYAN = "\033[36m"
DIM = "\033[2m"
RESET = "\033[0m"

SEP = f"  {DIM}│{RESET}  "


def colour_pct(pct, low=50, high=80):
    if pct >= high:
        return RED
    if pct >= low:
        return YELLOW
    return GREEN


def fmt_reset(unix_ts):
    """Return a human-friendly 'resets in Xh Ym' string."""
    if not unix_ts:
        return ""
    delta = int(unix_ts) - int(time.time())
    if delta <= 0:
        return "now"
    h, rem = divmod(delta, 3600)
    m = rem // 60
    if h > 0:
        return f"{h}h{m:02d}m"
    return f"{m}m"


# ── Parse input ───────────────────────────────────────────────────────────────
data = json.load(sys.stdin)

model = data.get("model", {}).get("display_name", "Claude")
cwd = data.get("workspace", {}).get("current_dir", os.getcwd())
project = os.path.basename(cwd)
cost = (data.get("cost") or {}).get("total_cost_usd", 0) or 0
ctx_pct = int((data.get("context_window") or {}).get("used_percentage", 0) or 0)
session = data.get("session_id", "")

# ── Git info (cached per session, refreshed every 5 s) ───────────────────────
CACHE = f"/tmp/claude-statusline-{session}"
CACHE_TTL = 5


def refresh_git_cache():
    try:
        subprocess.check_output(
            ["git", "rev-parse", "--git-dir"], stderr=subprocess.DEVNULL
        )
        branch = subprocess.check_output(
            ["git", "branch", "--show-current"], text=True, stderr=subprocess.DEVNULL
        ).strip()
        staged = subprocess.check_output(
            ["git", "diff", "--cached", "--numstat"],
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
        modified = subprocess.check_output(
            ["git", "diff", "--numstat"], text=True, stderr=subprocess.DEVNULL
        ).strip()
        n_staged = len([l for l in staged.split("\n") if l]) if staged else 0
        n_modified = len([l for l in modified.split("\n") if l]) if modified else 0
        return f"{branch}|{n_staged}|{n_modified}"
    except Exception:
        return "||"


stale = not os.path.exists(CACHE) or time.time() - os.path.getmtime(CACHE) > CACHE_TTL
if stale:
    with open(CACHE, "w") as f:
        f.write(refresh_git_cache())

with open(CACHE) as f:
    parts = f.read().strip().split("|")
branch = parts[0]
n_staged = parts[1] if len(parts) > 1 else "0"
n_modified = parts[2] if len(parts) > 2 else "0"

# ── Context bar ───────────────────────────────────────────────────────────────
BAR_WIDTH = 8
filled = ctx_pct * BAR_WIDTH // 100
bar_str = "▓" * filled + "░" * (BAR_WIDTH - filled)
bar_col = colour_pct(ctx_pct, low=70, high=90)

# ── Rate limits ───────────────────────────────────────────────────────────────
rate = data.get("rate_limits") or {}
five_h = rate.get("five_hour") or {}
seven_d = rate.get("seven_day") or {}

rate_parts = []
if five_h.get("used_percentage") is not None:
    pct = five_h["used_percentage"]
    reset = fmt_reset(five_h.get("resets_at"))
    c = colour_pct(pct)
    reset_str = f" ⏰ {reset}" if reset else ""
    rate_parts.append(f"5h: {c}{pct:.0f}%{RESET}{DIM}{reset_str}{RESET}")
if seven_d.get("used_percentage") is not None:
    pct = seven_d["used_percentage"]
    reset = fmt_reset(seven_d.get("resets_at"))
    c = colour_pct(pct)
    reset_str = f" ⏰ {reset}" if reset else ""
    rate_parts.append(f"7d: {c}{pct:.0f}%{RESET}{DIM}{reset_str}{RESET}")

rate_str = SEP + SEP.join(rate_parts) if rate_parts else ""

# ── Git segment ───────────────────────────────────────────────────────────────
git_str = ""
if branch:
    git_str = f"  🌿 {branch}"
    if int(n_staged) > 0:
        git_str += f" {GREEN}+{n_staged}{RESET}"
    if int(n_modified) > 0:
        git_str += f" {YELLOW}~{n_modified}{RESET}"

# ── Assemble single line ──────────────────────────────────────────────────────
line = (
    f"🤖 {CYAN}{model}{RESET}"
    f"{git_str}"
    f"  {DIM}•{RESET}  {project}"
    f"{SEP}{bar_col}{bar_str}{RESET} {ctx_pct}% ctx"
    f"{SEP}💰 {YELLOW}${cost:.2f}{RESET}"
    f"{rate_str}"
)

print(line)

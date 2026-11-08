#!/usr/bin/env bash
# Makes the essay-helper orchestrator the main agent in EVERY Claude Code
# session on this computer, in any folder:
#   - copies the agents to ~/.claude/agents and the skills to ~/.claude/skills
#   - sets "agent": "orchestrator" in ~/.claude/settings.json (backup kept)
#
# Usage:  scripts/install-global.sh             install / update
#         scripts/install-global.sh --uninstall remove the agent setting
# Re-run after pulling changes to update the installed copies.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_HOME="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
SETTINGS="$CLAUDE_HOME/settings.json"

set_agent() {  # $1 = agent name, or empty to remove the setting
  mkdir -p "$CLAUDE_HOME"
  [ -f "$SETTINGS" ] && cp "$SETTINGS" "$SETTINGS.bak"
  python3 - "$SETTINGS" "$1" <<'PY'
import json, sys, os
path, agent = sys.argv[1], sys.argv[2]
data = {}
if os.path.exists(path) and os.path.getsize(path):
    with open(path) as f:
        data = json.load(f)
if agent:
    data["agent"] = agent
else:
    data.pop("agent", None)
with open(path, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY
}

if [ "${1:-}" = "--uninstall" ]; then
  set_agent ""
  echo "Removed the global orchestrator setting from $SETTINGS."
  echo "The copied agents and skills remain in $CLAUDE_HOME (harmless; delete them by hand if you like)."
  exit 0
fi

mkdir -p "$CLAUDE_HOME/agents" "$CLAUDE_HOME/skills"
cp "$REPO"/.claude/agents/*.md "$CLAUDE_HOME/agents/"
for d in "$REPO"/.claude/skills/*/; do
  name="$(basename "$d")"
  rm -rf "$CLAUDE_HOME/skills/$name"
  cp -r "$d" "$CLAUDE_HOME/skills/$name"
done
set_agent "orchestrator"

echo "Installed $(ls "$REPO"/.claude/agents/*.md | wc -l | tr -d ' ') agents and $(ls -d "$REPO"/.claude/skills/*/ | wc -l | tr -d ' ') skills into $CLAUDE_HOME."
echo "Every new Claude Code session now starts as the orchestrator."
echo "For a session that is already open: exit it and run 'claude --continue' (or 'claude --resume') to reopen it with the orchestrator."

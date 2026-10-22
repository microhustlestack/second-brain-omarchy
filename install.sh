#!/usr/bin/env bash
#
# Second Brain installer (pre-AUR route, and the AI appliance bake-in route).
#
#   bash install.sh            # CLI + template into ~/.local (user install)
#   bash install.sh skill      # also deploy the agent skill (opencode + claude if present)
#   bash install.sh vault      # also run `second-brain init` if no vault exists
#
# Nothing here touches system dirs and nothing needs sudo.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info() { printf '  %s\n' "$*"; }
ok()   { printf '  ok %s\n' "$*"; }
warn() { printf '  ! %s\n' "$*" >&2; }

install_user() {
  mkdir -p "$HOME/.local/bin" "$HOME/.local/share/second-brain"
  install -m755 "$REPO_DIR/bin/second-brain" "$HOME/.local/bin/second-brain"
  rm -rf "$HOME/.local/share/second-brain/template"
  cp -r "$REPO_DIR/share/template" "$HOME/.local/share/second-brain/template"
  mkdir -p "$HOME/.local/share/second-brain/skills"
  rm -rf "$HOME/.local/share/second-brain/skills/second-brain"
  cp -r "$REPO_DIR/share/skills/second-brain" "$HOME/.local/share/second-brain/skills/second-brain"
  rm -rf "$HOME/.local/share/second-brain/agent-workspace"
  cp -r "$REPO_DIR/share/agent-workspace" "$HOME/.local/share/second-brain/agent-workspace"
  ok "Workspace template: ~/.local/share/second-brain/agent-workspace"
  mkdir -p "$HOME/.local/share/applications"
  cp "$REPO_DIR/share/applications/second-brain.desktop" "$HOME/.local/share/applications/"
  # systemd user units (lint timer, ingest watcher, ingest timer), with
  # ExecStart rewritten from the packaged /usr/bin path to the local bin.
  mkdir -p "$HOME/.config/systemd/user"
  local unit
  for unit in "$REPO_DIR"/contrib/systemd/*; do
    sed "s|/usr/bin/second-brain|$HOME/.local/bin/second-brain|g" \
      "$unit" > "$HOME/.config/systemd/user/$(basename "$unit")"
  done
  ok "CLI:      ~/.local/bin/second-brain"
  ok "Template: ~/.local/share/second-brain/template"
  ok "Units:    ~/.config/systemd/user/second-brain-*.{service,timer,path} (not enabled)"
  info "Enable automation: systemctl --user daemon-reload, then enable"
  info "second-brain-ingest.path (real-time) or second-brain-ingest.timer (nightly 02:00)"
  case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) warn "~/.local/bin is not on PATH in this shell. Omarchy adds it by default." ;;
  esac
}

deploy_skill() {
  local deployed=0
  if [[ -d "$HOME/.config/opencode" ]] || command -v opencode >/dev/null 2>&1; then
    mkdir -p "$HOME/.config/opencode/skills"
    rm -rf "$HOME/.config/opencode/skills/second-brain"
    cp -r "$REPO_DIR/share/skills/second-brain" "$HOME/.config/opencode/skills/second-brain"
    ok "OpenCode skill: ~/.config/opencode/skills/second-brain"
    deployed=1
  fi
  if [[ -d "$HOME/.claude" ]]; then
    mkdir -p "$HOME/.claude/skills"
    rm -rf "$HOME/.claude/skills/second-brain"
    cp -r "$REPO_DIR/share/skills/second-brain" "$HOME/.claude/skills/second-brain"
    ok "Claude Code skill: ~/.claude/skills/second-brain"
    deployed=1
  fi
  [[ "$deployed" -eq 0 ]] && warn "No agent dir detected. Skill staged at ~/.local/share/second-brain/skills/second-brain"
  return 0
}

echo "Second Brain installer"
install_user
for target in "$@"; do
  case "$target" in
    skill) deploy_skill ;;
    vault)
      if "$HOME/.local/bin/second-brain" status >/dev/null 2>&1 && [[ -d "${SECOND_BRAIN_HOME:-$HOME/SecondBrain}" ]]; then
        info "Vault already exists, leaving it alone."
      else
        "$HOME/.local/bin/second-brain" init
      fi
      ;;
    *) warn "unknown target: $target (use: skill | vault)"; exit 1 ;;
  esac
done
echo
echo "Check the install:  second-brain doctor"
echo "Scanner (CEREBRO):  pipx install git+https://github.com/microhustlestack/cerebro-skill"
echo "Local model:        install LM Studio via Omarchy menu (Install, AI), then: second-brain model --save"

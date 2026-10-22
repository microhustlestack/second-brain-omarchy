# Maintainer: J'Juan Wilson Jr. <hello@microhustlestack.com>
pkgname=second-brain-git
pkgver=0.1.0.r0.g0000000
pkgrel=1
pkgdesc="WSTUNLTD™ Second Brain Omarchy by JJUANtheBRAND™: PARA filing + LLM Wiki + graph ontology + CEREBRO lint + agent workspace, as a CLI and templates"
arch=('any')
url="https://github.com/microhustlestack/second-brain-omarchy"
license=('MIT')
depends=('bash' 'python' 'python-yaml')
makedepends=('git')
optdepends=(
  'pipx: install the CEREBRO scanner the Arch-safe way (PEP 668)'
  'opencode: agent engine that maintains the wiki (any agent works)'
  'obsidian: vault viewer with graph view'
  'gum: nicer prompts, ships with Omarchy'
)
# Local model runtime: LM Studio, installed through Omarchy's own install
# menu (Install, AI, LM Studio) rather than as a pacman dependency, since
# Omarchy manages it. `second-brain model` sizes a model to the machine
# and `second-brain doctor` checks for the lms CLI.
provides=('second-brain')
conflicts=('second-brain')
source=("git+$url.git")
sha256sums=('SKIP')
install=second-brain.install

pkgver() {
  cd "$srcdir/second-brain-omarchy"
  printf "%s.r%s.g%s" "0.1.0" \
    "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package() {
  cd "$srcdir/second-brain-omarchy"

  # CLI
  install -Dm755 bin/second-brain "$pkgdir/usr/bin/second-brain"

  # Read-only template. User vaults are COPIES made by `second-brain init`.
  # Never symlink a vault into /usr/share: the package owns that tree and
  # pacman will replace it on upgrade.
  install -dm755 "$pkgdir/usr/share/second-brain"
  cp -r share/template "$pkgdir/usr/share/second-brain/template"

  # Agent skill (install into your agent's skill dir to activate; see README)
  install -Dm644 share/skills/second-brain/SKILL.md \
    "$pkgdir/usr/share/second-brain/skills/second-brain/SKILL.md"

  # Execution layer template: agent-workspace (workflow/task/subtask triads).
  # Installed read-only like the vault template; users copy it with
  # `second-brain workspace init`.
  cp -r share/agent-workspace "$pkgdir/usr/share/second-brain/agent-workspace"

  # Docs (model swap durability checklist)
  install -Dm644 docs/model-swap-durability-checklist.md \
    "$pkgdir/usr/share/doc/$pkgname/model-swap-durability-checklist.md"

  # Launcher entry: Omarchy's Walker and every freedesktop launcher index it
  install -Dm644 share/applications/second-brain.desktop \
    "$pkgdir/usr/share/applications/second-brain.desktop"

  # Optional weekly lint timer (user service, enable manually)
  install -Dm644 contrib/systemd/second-brain-lint.service \
    "$pkgdir/usr/lib/systemd/user/second-brain-lint.service"
  install -Dm644 contrib/systemd/second-brain-lint.timer \
    "$pkgdir/usr/lib/systemd/user/second-brain-lint.timer"

  # Optional ingestion automation (user units, enable one or both):
  # path watcher = real-time event hook on raw/, timer = nightly 02:00 batch
  install -Dm644 contrib/systemd/second-brain-ingest.service \
    "$pkgdir/usr/lib/systemd/user/second-brain-ingest.service"
  install -Dm644 contrib/systemd/second-brain-ingest.path \
    "$pkgdir/usr/lib/systemd/user/second-brain-ingest.path"
  install -Dm644 contrib/systemd/second-brain-ingest.timer \
    "$pkgdir/usr/lib/systemd/user/second-brain-ingest.timer"

  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
  install -Dm644 README.md "$pkgdir/usr/share/doc/$pkgname/README.md"
}

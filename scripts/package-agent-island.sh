#!/bin/zsh

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"

export OPEN_ISLAND_APP_NAME="${OPEN_ISLAND_APP_NAME:-Agent Island}"
export OPEN_ISLAND_BUNDLE_ID="${OPEN_ISLAND_BUNDLE_ID:-dev.islanddev.local}"
export OPEN_ISLAND_VERSION="${OPEN_ISLAND_VERSION:-0.1.0}"
export OPEN_ISLAND_DISABLE_UPDATES="true"
export OPEN_ISLAND_DMG_SKIP_FINDER="${OPEN_ISLAND_DMG_SKIP_FINDER:-true}"
export OPEN_ISLAND_PACKAGE_ROOT="${OPEN_ISLAND_PACKAGE_ROOT:-$repo_root/output/agent-island}"

# Keep the existing local signing requirement when the developer identity is
# available so macOS can preserve Accessibility and Automation grants across
# rebuilds. Other machines fall back to the ad-hoc signature in package-app.sh.
if [[ -z "${OPEN_ISLAND_SIGN_IDENTITY:-}" ]] && \
   security find-identity -p codesigning -v "$HOME/Library/Keychains/login.keychain-db" 2>/dev/null \
       | grep -q '"Open Island Dev Local"'; then
    export OPEN_ISLAND_SIGN_IDENTITY="Open Island Dev Local"
fi

if [[ "${OPEN_ISLAND_SIGN_IDENTITY:-}" == "Open Island Dev Local" ]]; then
    export OPEN_ISLAND_HARDENED_SIGNING="false"
fi

exec zsh "$repo_root/scripts/package-app.sh"

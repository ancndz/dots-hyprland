#!/usr/bin/env bash
# ii slideshow rotation engine
# Invoked by cron (cronie). On each call advances to the next wallpaper in
# the configured folder (by name order, wrapping around), then calls
# switchwall.sh to apply the wallpaper + regenerate the color palette.

QUICKSHELL_CONFIG_NAME="ii"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
CONFIG_FILE="$XDG_CONFIG_HOME/illogical-impulse/config.json"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INDEX_FILE="$XDG_STATE_HOME/quickshell/slideshow.index"
mkdir -p "$(dirname "$INDEX_FILE")"

# cron runs with a minimal environment; adopt the user's desktop session env
# so switchwall.sh can reach hyprctl, gsettings, notify-send (via dbus).
if [[ -n "$(pgrep -u "$USER" hyprland)" ]]; then
    export DISPLAY="${DISPLAY:-:0}"
    export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"
    export XDG_RUNTIME_DIR="/run/user/$(id -u)"
    export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
fi

# Supported static image extensions (no video per requirements).
IMAGE_EXTS=(jpg jpeg png webp bmp)

log() { echo "[slideshow] $*"; }

enabled=$(jq -r '.background.slideshow.enabled // false' "$CONFIG_FILE" 2>/dev/null)
if [[ "$enabled" != "true" ]]; then
    log "disabled, exiting"
    exit 0
fi

folder=$(jq -r '.background.slideshow.folder // empty' "$CONFIG_FILE" 2>/dev/null)
folder="${folder#file://}"
if [[ -z "$folder" || ! -d "$folder" ]]; then
    log "slideshow folder not set or missing: '$folder'"
    exit 1
fi

# Build sorted list of images (by name).
mapfile -t imgs < <(
    find "$folder" -maxdepth 1 -type f \( \
        -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \
        -o -iname '*.webp' -o -iname '*.bmp' \) \
        -printf '%f\n' | sort
)

if [[ ${#imgs[@]} -eq 0 ]]; then
    log "no images found in $folder"
    exit 0
fi

# Advance index by one (wrap around).
idx=$(cat "$INDEX_FILE" 2>/dev/null || echo "-1")
idx=$(("${idx:- -1}" + 1))
idx=$(( idx % ${#imgs[@]} ))
echo "$idx" > "$INDEX_FILE"

next="$folder/${imgs[$idx]}"
log "switching to [${idx}]: ${imgs[$idx]}"
"$SCRIPT_DIR/switchwall.sh" --image "$next"
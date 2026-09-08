#!/usr/bin/env bash
# ii slideshow cron manager
# Installs / removes the slideshow entry in the user's crontab (no sudo).
# Usage:
#   slideshow-cron.sh install "<cron expression or @reboot>"
#   slideshow-cron.sh uninstall
#   slideshow-cron.sh status
#
# The installed line is tagged with "# ii-slideshow" so we can find/remove
# only our own entry without touching the user's other cron jobs.

QUICKSHELL_CONFIG_NAME="ii"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# The rotation engine actually lives next to this script.
SLIDESHOW_SCRIPT="$SCRIPT_DIR/slideshow.sh"
TAG="# ii-slideshow"

show_help() {
    cat <<EOF
Usage: $0 {install <expr>|uninstall|status}
  install <expr>   add slideshow cron job (expr = cron fields or @reboot)
  uninstall        remove the slideshow cron job
  status           print whether the slideshow cron job is installed
EOF
}

# Print current crontab with the slideshow line removed.
remove_ours() {
    local line
    crontab -l 2>/dev/null | grep -vF "$TAG"
}

install() {
    local expr="$1"
    local shell_bin
    shell_bin="$(command -v bash)"

    if [[ -z "$expr" ]]; then
        echo "No cron expression given." >&2
        show_help >&2
        exit 1
    fi

    local rest
    rest="$(remove_ours)"

    # New combined crontab: existing jobs + our tagged line.
    {
        [[ -n "$rest" ]] && printf '%s\n' "$rest"
        printf '%s %s %s %s\n' "$expr" "$shell_bin" "$SLIDESHOW_SCRIPT" "$TAG"
    } | crontab -

    echo "Installed slideshow cron: $expr"
}

uninstall() {
    local rest
    rest="$(remove_ours)"
    if [[ -n "$rest" ]]; then
        printf '%s\n' "$rest" | crontab -
    else
        crontab -r 2>/dev/null || true
    fi
    echo "Removed slideshow cron job."
}

status() {
    if crontab -l 2>/dev/null | grep -qF "$TAG"; then
        echo "installed"
        crontab -l | grep -F "$TAG"
    else
        echo "not-installed"
    fi
}

case "${1:-}" in
    install) install "$2" ;;
    uninstall) uninstall ;;
    status) status ;;
    *) show_help ;;
esac
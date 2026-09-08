#!/usr/bin/env bash
# ii slideshow setup helper
# Called from the QuickConfig UI.
#   pick-folder          : let user choose an existing folder -> use it directly
#   add-images <files...>: copy chosen images into the system Slideshow folder
#                          and use that folder
# In both cases writes .background.slideshow.folder into config.json.

QUICKSHELL_CONFIG_NAME="ii"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
CONFIG_FILE="$XDG_CONFIG_HOME/illogical-impulse/config.json"
PICTURES_DIR="$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")"
SLIDESHOW_DIR="$PICTURES_DIR/Slideshow"

log() { echo "[slideshow-setup] $*"; }

set_folder() {
    local folder="$1"
    if ! command -v jq >/dev/null 2>&1; then
        log "jq is required"
        exit 1
    fi
    # ensure slideshow object exists
    jq '.background.slideshow.folder = $f' --arg f "$folder" \
        "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    log "slideshow folder set to: $folder"
}

pick_picker() {
    # choose a folder picker tool
    if command -v zenity >/dev/null 2>&1; then
        echo "zenity"
    elif command -v kdialog >/dev/null 2>&1; then
        echo "kdialog"
    else
        echo ""
    fi
}

pick_folder() {
    local picker picker_path
    picker="$(pick_picker)"
    if [[ "$picker" == "zenity" ]]; then
        picker_path="$(zenity --file-selection --directory --title='Выберите папку с обоями' 2>/dev/null)"
    elif [[ "$picker" == "kdialog" ]]; then
        picker_path="$(kdialog --getexistingdirectory "$PICTURES_DIR" 'Выберите папку с обоями' 2>/dev/null)"
    else
        log "no folder picker (zenity/kdialog) available"
        exit 1
    fi
    if [[ -z "$picker_path" ]]; then
        log "no folder selected"
        exit 0
    fi
    set_folder "$picker_path"
}

add_images() {
    local picker picker_files file
    picker="$(pick_picker)"
    if [[ "$picker" == "zenity" ]]; then
        # multi-select images
        mapfile -t picker_files < <(zenity --file-selection --multiple \
            --file-filter='Images | *.jpg *.jpeg *.png *.webp *.bmp' \
            --title='Выберите изображения для слайдшоу' 2>/dev/null)
    elif [[ "$picker" == "kdialog" ]]; then
        picker_files="$(kdialog --getopenfilename "$PICTURES_DIR" \
            '*.jpg *.jpeg *.png *.webp *.bmp|Images' --multiple --title='Выберите изображения' 2>/dev/null)"
        # kdialog --multiple returns newline-separated list; handle via readarray
        mapfile -t picker_files <<< "$picker_files"
    else
        log "no picker available"
        exit 1
    fi

    if [[ ${#picker_files[@]} -eq 0 || -z "${picker_files[0]}" ]]; then
        log "no images selected"
        exit 0
    fi

    mkdir -p "$SLIDESHOW_DIR"
    local copied=0
    for file in "${picker_files[@]}"; do
        [[ -z "$file" || -f "$file" ]] || continue
        cp -f "$file" "$SLIDESHOW_DIR/"
        copied=$((copied + 1))
    done
    log "copied $copied image(s) to $SLIDESHOW_DIR"
    set_folder "$SLIDESHOW_DIR"
}

case "${1:-}" in
    pick-folder) pick_folder ;;
    add-images) shift; add_images "$@" ;;
    *) echo "Usage: $0 {pick-folder|add-images}" >&2; exit 1 ;;
esac
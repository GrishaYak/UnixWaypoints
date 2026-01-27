#!/bin/sh

HELP_TEXT='
Hello! This is an uninstaller for UnixWaypoints.
It will:
1) Erase loading waypoints from shell rc.
2) Clear all created waypoints (Optional)

Flags:
-h|--help                   - print this text
-o|--old                    - use if you had run "instal.sh" from older versions
-k|--keep-waypoints         - keep my waypoints untouched
'

WAYPOINTS_FILE="$PWD/.waypoints"
SCRIPT_FILE="$PWD/waypoints.sh"
OLD_DIR="$HOME/.local/share/waypoints"
OLD="$OLD_DIR/waypoints.sh"
MY_MARK="#UnixWaypoints"


case "$SHELL" in
    */zsh)
        SHELL_RC="$HOME/.zshrc"
        ;;
    */bash)
        SHELL_RC="$HOME/.bashrc"
        ;;
    *)
        SHELL_RC="$HOME/.profile"
        ;;
esac
DELETE_WAYPOINTS=1
case "$1" in
    -h|--help)
        echo "$HELP_TEXT"
        return 1
        ;;
    -o|--old)
        grep -vxF ". $SCRIPT_FILE" "$SHELL_RC" > .tmp
        grep -vxF ". $OLD" .tmp > "$SHELL_RC"
        rm -rf "$OLD_DIR"
        ;;
    -k|--keep-waypoints)
        DELETE_WAYPOINTS=0
        ;;
esac

NEW_VERSION_EXPORT=$(grep -A 1 "$MY_MARK" "$SHELL_RC")
grep -vxF "$NEW_VERSION_EXPORT" "$SHELL_RC" > .tmp && cat .tmp > "$SHELL_RC"

rm .tmp

[ $DELETE_WAYPOINTS -eq 1 ] && rm -f "$WAYPOINTS_FILE"

echo "waypoints have been uninstalled"


#!/bin/sh
# Installer for Waypoints

WAYPOINTS_FILE="$PWD/.waypoints"
SCRIPT_FILE="$PWD/waypoints.sh"

# Detect shell startup file
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

touch "$WAYPOINTS_FILE"

grep -qxF ". $SCRIPT_FILE" "$SHELL_RC" || printf "\n. $SCRIPT_FILE\n" >> "$SHELL_RC"

echo "Installation complete!"
echo "Restart your terminal to start using wp and tp."


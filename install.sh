#!/bin/sh

cd $(dirname "$0")
WAYPOINTS_FILE="$PWD/.waypoints"
SCRIPT_FILE="$PWD/waypoints.sh"

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

if [ "$(uname)" != "Linux" ]; then
    sed -i '' "s|WAYPOINTS_FILE=.*\$|WAYPOINTS_FILE=\"$WAYPOINTS_FILE\"|g" "$SCRIPT_FILE"
else
    sed --in-place --posix "s|WAYPOINTS_FILE=.*\$|WAYPOINTS_FILE=\"$WAYPOINTS_FILE\"|g" "$SCRIPT_FILE"
fi   
 
grep -qxF ". $SCRIPT_FILE" "$SHELL_RC" || printf "\n. $SCRIPT_FILE\n" >> "$SHELL_RC"


echo "Installation complete!"
echo "Restart your terminal to start using wp and tp."

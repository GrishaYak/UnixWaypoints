#!/bin/sh
MY_MARK="#UnixWaypoints"
cd $(dirname "$0")
WAYPOINTS_FILE="$PWD/.waypoints"
SCRIPT_FILE="$PWD/waypoints.sh"
HELP_TEXT='
Hello! This script will install UnixWaypoints on your machine.
To work properly, it needs "waypoints.sh" file in its directory.

During installation it will:
1) Create a file containing saved waypoints
2) Rewrite "waypoints.sh" file, so it will work on your machine
3) It will add a command that will make waypoints work in your terminal to ".zshrc" 
or ".bashrc" or ".profile", depending on what it will find first

Flags:
-h|--help                   - print this text
'

case $1 in
    -h|--help)
        echo "$HELP_TEXT"
        return 1
        ;;
esac

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

grep -qxF "$MY_MARK" "$SHELL_RC" || printf "\n$MY_MARK\n. $SCRIPT_FILE\n" >> "$SHELL_RC"
echo "Installation complete!"
echo "Restart your terminal to start using wp and tp."

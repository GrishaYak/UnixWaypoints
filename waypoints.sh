# ~/.local/share/waypoints/.waypoints.sh
[ -n "$WP_LOADED" ] && return
WP_LOADED=1
WAYPOINTS_FILE="$HOME/.local/share/waypoints/.waypoints"

wp() {
    mkdir -p "$(dirname "$WAYPOINTS_FILE")"
    touch "$WAYPOINTS_FILE"

    case "$1" in
        add)
            [ -z "$2" ] && { echo "Usage: wp add <name>"; return 1; }
            name=$2
            path=$(pwd)

            grep -v "^$name=" "$WAYPOINTS_FILE" > "$WAYPOINTS_FILE.tmp"
            mv "$WAYPOINTS_FILE.tmp" "$WAYPOINTS_FILE"

            printf '%s=%s\n' "$name" "$path" >> "$WAYPOINTS_FILE"
            ;;
        rm)
            [ -z "$2" ] && { echo "Usage: wp rm <name>"; return 1; }
            case "$3" in 
                -E) 
                    regex=$(printf '%s' "$2" | sed 's/\*/.*/g; s/?/./g')
                    grep -v -E "^$regex=" "$WAYPOINTS_FILE" > "$WAYPOINTS_FILE.tmp"
                    ;;
                *) 
                    grep -v "^$2=" "$WAYPOINTS_FILE" > "$WAYPOINTS_FILE.tmp"
            esac    
            mv "$WAYPOINTS_FILE.tmp" "$WAYPOINTS_FILE"
            ;;
        ls)
            cut -d= -f1 "$WAYPOINTS_FILE"
            ;;
        *)
            echo "Usage: wp {add|rm|ls}"
            ;;
    esac
}

tp() {
    [ -z "$1" ] && { echo "Usage: tp <name>"; return 1; }

    dest=$(grep "^$1=" "$WAYPOINTS_FILE" | cut -d= -f2-)
    [ -z "$dest" ] && { echo "Directory not found: $dest"; return 1; }
    cd "$dest" || return 1
}

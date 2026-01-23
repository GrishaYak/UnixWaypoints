#!usr/bin/env sh
[ -n "$WP_LOADED" ] && return
WP_LOADED=1
WAYPOINTS_FILE="$HOME/.local/share/waypoints/.waypoints"
WP_TEMP="$WAYPOINTS_FILE.tmp"

wp() {
    touch "$WAYPOINTS_FILE"

    case "$1" in
        add)
            [ -z "$2" ] && { echo "Usage: wp add <name>"; return 1; }
            name=$2
            path=$(pwd)

            grep -v "^$name=" "$WAYPOINTS_FILE" > $WP_TEMP
            mv "$WP_TEMP" "$WAYPOINTS_FILE"

            printf '%s=%s\n' "$name" "$path" >> "$WAYPOINTS_FILE"
            ;;
        rm)
            [ -z "$2" ] && { echo "Usage: wp rm <name>"; return 1; }
            case "$3" in 
                -e|--reg|--regex) 
                    regex="$(printf '%s' "$2" | sed 's/\*/.*/g; s/?/./g')"
                    grep -v -E "^$regex=" "$WAYPOINTS_FILE" > "$WP_TEMP"

                    echo Following waypoints will be deleted: 
                    comm -13 "$WP_TEMP" "$WAYPOINTS_FILE" | cut -d= -f1
                    echo Type \"Y\" if you are okay with this

                    read ok
                    ;;
                *) 
                    grep -v "^$2=" "$WAYPOINTS_FILE" > "$WP_TEMP"
                    ok=Y
            esac    
            if [ "$ok" = "Y" ]; then
                mv "$WP_TEMP" "$WAYPOINTS_FILE"
            else
                rm "$WP_TEMP"
            fi
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

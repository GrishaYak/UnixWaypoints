#!usr/bin/env sh
[ -n "$WP_LOADED" ] && return
WP_LOADED=1
WAYPOINTS_FILE="/home/grishayak/cs/projects/shell/UnixWaypoints/.waypoints"

WP_TEMP="$WAYPOINTS_FILE.tmp"

USAGE='Usage:'

RM_USAGE='
wp rm <name>                - remove <name> (understands regular expressions)
wp rm <name> -n|--no-regex  - understand <name> literally'

ADD_USAGE='
wp add <name>               - add <name> to the waypoint list'

LS_USAGE='
wp ls                       - print all waypoints'

TP_USAGE="
tp <name>                   - teleport to waypoint named <name>"

WP_USAGE="$ADD_USAGE$LS_USAGE$RM_USAGE
wp <name>                   - same as wp add <name>
$TP_USAGE"

HELP_TEXT='You can type "wp" without arguments instead of using -h or --help flag.

'
wp() {
    touch "$WAYPOINTS_FILE"
    [ -z "$1" ] && { echo "$USAGE$WP_USAGE"; return 1; }
    case "$1" in
        -h|--help)
            echo "$HELP_TEXT$USAGE$WP_USAGE"
            return 1
            ;;
        add)
            [ -z "$2" ] && { echo "$USAGE$ADD_USAGE"; return 1; }
            name=$2

            grep -v "^$name=" "$WAYPOINTS_FILE" > $WP_TEMP
            mv "$WP_TEMP" "$WAYPOINTS_FILE"

            printf '%s=%s\n' "$name" "$PWD" >> "$WAYPOINTS_FILE"
            ;;
        rm)
            [ -z "$2" ] && { echo "$USAGE$RM_USAGE"; return 1; } 
            
            case "$3" in 
                -n|--no-regex) 
                    grep -v "^$2=" "$WAYPOINTS_FILE" > "$WP_TEMP"
                    ok=Y
                    ;;
                *) 
                    regex="$(printf '%s' "$2" | sed 's/\*/.*/g; s/?/./g')"
                    grep -v -E "^$regex=" "$WAYPOINTS_FILE" > "$WP_TEMP"

                    comm -13 "$WP_TEMP" "$WAYPOINTS_FILE" | cut -d= -f1 | sed 's/^/wp rm /g'
                    
                    ok=Y
                    ;;
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
            wp add $1
            ;;
    esac
}

tp() {
    [ -z "$1" ] && { echo "$USAGE$TP_USAGE"; return 1; }

    DEST=$(grep "^$1=" "$WAYPOINTS_FILE" | cut -d= -f2-)
    [ -z "$DEST" ] && { echo "Directory not found: $1"; return 1; }
    cd "$DEST" || return 1
}

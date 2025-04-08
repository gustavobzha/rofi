#!/bin/bash
#
## Author       : Gustavo Bezerra
## Github       : gustavobzha
#
## Applets      : playerctl
#
## Mentions     : This applet was created based on rofi-playerctl script from giomatfois62
#                 Github: https://github.com/giomatfois62/rofi-desktop/blob/main/scripts/rofi-playerctl.sh
#
## Dependencies : rofi, playerctl
# 
# This script controls media players through playerctl with a two-step interface:
# 1. First select a player
# 2. Then select an action for that player
#


# Import Current Theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

if ! command -v playerctl &> /dev/null; then
    rofi -e "Install playerctl to enable the media player controls menu" -theme "$theme"
    exit 1
fi

TOGGLE="󰐎  Play/Pause"
NEXT="󰼧  Next"
PREV="󰼨  Previous"
SEEKMINUS="󰁍  Go back 15 seconds"
SEEKPLUS="󰁔  Go ahead 15 seconds"
STATUS=""
RETURN="󰌑  Return"

# Function to get player status
get_player_status() {
    local player="$1"
    if playerctl -p "$player" status >/dev/null 2>&1; then
        player_metadata=$(playerctl -p "$player" metadata -f "{{trunc(default(title, \"[Unknown]\"), 25)}} by {{trunc(default(artist, \"[Unknown]\"), 25)}}")
        player_status=$(playerctl -p "$player" status)
        echo "$player: $player_metadata ($player_status)"
    else
        echo "$player: Inactive"
    fi

	# Options

}

# Function to list all available players
list_players() {
    playerctl -l 2>/dev/null
}

# Show player selection menu
show_player_menu() {
    local players
    players=$(list_players)
    
    if [ -z "$players" ]; then
        rofi -e "No players available" -theme "$theme"
        exit 1
    fi
    
    printf '%s\n' "${players[@]}" | rofi -dmenu -i -p "Select Player" -theme "$theme" -format 's' | head -n 1
}

# Show action menu for selected player
show_action_menu() {
    local player="$1"

	while true; do
        STATUS=$(get_player_status "$player")
        
        # Show menu
        chosen=$(echo -e "$TOGGLE\n$NEXT\n$PREV\n$SEEKPLUS\n$SEEKMINUS\n$RETURN" | \
            rofi -dmenu -i -p "$player" -mesg "$STATUS" -theme "$theme" -format 's')
        
        # Exit if user pressed ESC or clicked outside
        if [ -z "$chosen" ]; then
            exit 0
        fi
        
        # Execute the chosen action
        case "$chosen" in
            "$TOGGLE")
                playerctl -p "$player" play-pause
                ;;
            "$NEXT")
                playerctl -p "$player" next
                ;;
            "$PREV")
                playerctl -p "$player" previous
                ;;
            "$SEEKMINUS")
                playerctl -p "$player" position 15-
                ;;
            "$SEEKPLUS")
                playerctl -p "$player" position 15+
                ;;
            "$RETURN")
                # Return to player selection
                new_player=$(show_player_menu)
                if [ -n "$new_player" ]; then
                    player="$new_player"
                else
                    exit 0
                fi
                ;;
        esac

        # Exit if the player is no longer available
        if ! playerctl -p "$player" status >/dev/null 2>&1; then
            rofi -e "Player $player is no longer available" -theme "$theme"
            return 1
        fi
    done
}

# Main execution
selected_player=$(show_player_menu)

if [ -n "$selected_player" ]; then
	show_action_menu "$selected_player"
fi

exit 0

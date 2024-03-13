#!/bin/bash

# Path to your i3 configuration file
I3_CONFIG_PATH="$HOME/.config/i3/config"

# Define your laptop screen output (e.g., eDP-1)
LAPTOP_OUTPUT="eDP-1"

# Define your HDMI output (e.g., HDMI-1)
HDMI_OUTPUT="HDMI-1"

# List of workspace names (adjust as needed)
WORKSPACES=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

# Function to move workspaces to a specific output
move_workspaces_to_output() {
    local output="$1"
    for ws in "${WORKSPACES[@]}"; do
        i3-msg "workspace $ws; move workspace to output $output"
    done
}

# Main script logic
if xrandr | grep -q "HDMI-1 connected"; then
    # HDMI is connected, move relevant workspaces to HDMI output
    move_workspaces_to_output "$HDMI_OUTPUT"
    echo "Relevant workspaces moved to $HDMI_OUTPUT"
    
    # Set HDMI-1 on top of eDP-1 with the specified refresh rate
    xrandr --output "$HDMI_OUTPUT" --mode 1920x1080 --rate 74.97 --pos 0x0 --above "$LAPTOP_OUTPUT"
    echo "HDMI-1 set on top of $LAPTOP_OUTPUT with refresh rate 74.97"
else
    # HDMI is unplugged, restore workspaces to laptop screen
    move_workspaces_to_output "$LAPTOP_OUTPUT"
    echo "Relevant workspaces moved to $LAPTOP_OUTPUT"

    # Turn off HDMI-1
    xrandr --output "$HDMI_OUTPUT" --off
    echo "HDMI-1 turned off"
fi

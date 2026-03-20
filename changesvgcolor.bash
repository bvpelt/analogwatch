#!/bin/bash

# --- Variables ---
BASE_DIR="/home/bvpelt/Develop/analogwatch/resources/drawables"
INPUT_DIR="./resources/drawables"

# Define colors and their labels in an associative array (requires Bash 4+)
declare -A COLORS=(
    ["black"]="#434343"
    ["classic"]="#b80200"
    ["gray"]="#7f7f7f"
    ["bluesteel"]="#838da0"
    ["blue"]="#81a9d1"
    ["orange"]="#ffca52"
    ["whiteish"]="#a4f3ae"
    ["white"]="#e9e9e9"
)

# --- Function ---
process_logo() {
    local logo_name=$1  # e.g., "vav-logo" or "bethel-logo"
    local selectors=$2  # e.g., "path" or "path;select-by-element:ellipse"

    echo "Processing variants for: $logo_name"

    for label in "${!COLORS[@]}"; do
        local hex=${COLORS[$label]}
        local input_file="$INPUT_DIR/$logo_name.svg"
        local output_file="$BASE_DIR/$logo_name-$label.svg"

        # Build the action string dynamically based on selectors
        # We split the selectors by semicolon to apply the color to each element type
        local actions=""
        IFS=';' read -ra ADDR <<< "$selectors"
        for sel in "${ADDR[@]}"; do
            actions+="select-by-element:$sel;object-set-property:fill,$hex;"
        done
        actions+="export-filename:$output_file;export-do"

        cat "$input_file" | inkscape --pipe --actions="$actions"
    done
}

# --- Execution ---
echo "Starting logo processing..."

# VAV Logos only target 'path'
process_logo "vav-logo" "path"

# Bethel Logos target 'path' and 'ellipse'
process_logo "bethel-logo" "path;ellipse"

echo "Done!"
#!/bin/bash

# --- Variables (Keep your existing ones) ---
BASE_DIR="/home/bvpelt/Develop/analogwatch/resources/drawables"
INPUT_DIR="./resources/drawables"

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

# --- Fixed Darken Function ---
darken_color() {
    local hex=$(echo "${1#\#}" | tr '[:lower:]' '[:upper:]')
    local factor=$2
    
    # Extract RGB and convert via bc using ibase=16
    local r_dec=$(echo "ibase=16; ${hex:0:2}" | bc)
    local g_dec=$(echo "ibase=16; ${hex:2:2}" | bc)
    local b_dec=$(echo "ibase=16; ${hex:4:2}" | bc)

    # Apply factor and format back to 2-digit hex
    local r=$(printf "%02x" $(echo "($r_dec * $factor) / 1" | bc))
    local g=$(printf "%02x" $(echo "($g_dec * $factor) / 1" | bc))
    local b=$(printf "%02x" $(echo "($b_dec * $factor) / 1" | bc))
    
    echo "#$r$g$b"
}

# --- Fixed Processing Function ---
process_logo() {
    local logo_name=$1
    local mode=$2

    for label in "${!COLORS[@]}"; do
        local base_hex=${COLORS[$label]}
        local output_file="$BASE_DIR/$logo_name-$label.svg"
        local actions=""

        if [ "$mode" == "kruis" ]; then
            local hex_20=$base_hex
            local hex_30=$(darken_color "$base_hex" "0.9")
            local hex_40=$(darken_color "$base_hex" "0.8")
            local hex_60=$(darken_color "$base_hex" "0.6")

            # We must select IDs individually since regex isn't supported
            # LEVEL 20
            actions+="select-by-id:20-left_side_stem,20-left_end_cap,20-left_side_top;object-set-property:fill,$hex_20;select-clear;"
            # LEVEL 30
            actions+="select-by-id:30-top_bevel,30-right_arm_top,30-left_arm_top;object-set-property:fill,$hex_30;select-clear;"
            # LEVEL 40
            actions+="select-by-id:40-right_arm_bottom,40-left_arm_bottom;object-set-property:fill,$hex_40;select-clear;"
            # LEVEL 60
            actions+="select-by-id:60-right_side_top,60-right_end_cap,60-right_side_stem,60-bottom_bevel;object-set-property:fill,$hex_60;select-clear;"
        else
            actions+="select-by-element:path;object-set-property:fill,$base_hex;select-clear;"
            [[ "$logo_name" == "bethel-logo" ]] && actions+="select-by-element:ellipse;object-set-property:fill,$base_hex;select-clear;"
        fi

        actions+="export-filename:$output_file;export-do"
        inkscape --pipe --actions="$actions" < "$INPUT_DIR/$logo_name.svg"
    done
}

# --- Execution (Same as before) ---
echo "Starting logo processing..."
process_logo "vav-logo" "standard"
process_logo "bethel-logo" "standard"
process_logo "kruis" "kruis"
echo "Done!"
#!/bin/bash

# 1. Check if an input file was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <path_to_svg_file>"
    exit 1
fi

# 2. VITAL FIX: Convert input to an Absolute Path
# This prevents Inkscape (Snap) from looking in the wrong folder
INPUT_FILE=$(realpath "$1")

# 3. Extract the directory from the absolute path
OUTPUT_DIR=$(dirname "$INPUT_FILE")

# 4. Check if the file actually exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found."
    exit 1
fi

echo "Processing $INPUT_FILE..."

# 5. Loop through the required sizes
for size in 80 60 54 40 36 30; do
    
    # Define the output file with full path
    OUTPUT_NAME="${OUTPUT_DIR}/launcher_icon_${size}.png"
    
    echo "  Generating: $OUTPUT_NAME"
    
    # Run Inkscape
    # We suppress the GTK warnings using 2> /dev/null to keep output clean
    inkscape "$INPUT_FILE" \
        --export-width=$size \
        --export-height=$size \
        --export-filename="$OUTPUT_NAME" 2> /dev/null
done

echo "Success! All icons created."
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
OUTPUT_DIR=$(realpath $(dirname "$0"))/resources/drawables

# Create directory structure
mkdir -p resources/drawables-round-218x218
mkdir -p resources/drawables-round-240x240
mkdir -p resources/drawables-round-260x260
mkdir -p resources/drawables-round-280x280
mkdir -p resources/drawables-round-360x360
mkdir -p resources/drawables-round-390x390
mkdir -p resources/drawables-round-416x416
mkdir -p resources/drawables-round-454x454
mkdir -p resources/drawables-rectangle-240x240
mkdir -p resources/drawables-rectangle-320x360

# 4. Check if the file actually exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found."
    exit 1
fi

echo "Processing $INPUT_FILE..."

# 5. Loop through the required sizes
#for size in 80 60 54 40 36 30; do
for size in 80 60 40 36; do
    
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

# Assuming you have launcher_icon_80.png, etc. in resources/drawables/
pushd resources/drawables

# Keep 80x80 as default in drawables/
cp launcher_icon_80.png launcher_icon.png

# Copy icons to appropriate folders
cp launcher_icon_40.png ../drawables-round-218x218/launcher_icon.png
cp launcher_icon_40.png ../drawables-round-240x240/launcher_icon.png
cp launcher_icon_40.png ../drawables-round-260x260/launcher_icon.png
mv launcher_icon_40.png ../drawables-round-280x280/launcher_icon.png
cp launcher_icon_60.png ../drawables-round-360x360/launcher_icon.png
cp launcher_icon_60.png ../drawables-round-390x390/launcher_icon.png
mv launcher_icon_60.png ../drawables-round-416x416/launcher_icon.png
mv launcher_icon_80.png ../drawables-round-454x454/launcher_icon.png
cp launcher_icon_36.png ../drawables-rectangle-240x240/launcher_icon.png
mv launcher_icon_36.png ../drawables-rectangle-320x360/launcher_icon.png

popd
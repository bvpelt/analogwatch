#!/bin/bash

# 1. Check if an input file was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <path_to_svg_file>"
    exit 1
fi

# 2. Convert input to an Absolute Path
INPUT_FILE=$(realpath "$1")
echo "Processing: $INPUT_FILE"

# 3. Determine Project Root
# This gets the folder where this script lives
PROJECT_ROOT=$(realpath $(dirname "$0"))

# Define the Default/Base output directory
BASE_DRAWABLES="${PROJECT_ROOT}/resources/drawables"

echo "Project Root: $PROJECT_ROOT"

# 4. Create the STANDARD Connect IQ directory structure
# These must be siblings to 'resources', not inside it
mkdir -p "$BASE_DRAWABLES"

mkdir -p "${PROJECT_ROOT}/resources-round-208x208/drawables"
mkdir -p "${PROJECT_ROOT}/resources-round-218x218/drawables"
mkdir -p "${PROJECT_ROOT}/resources-round-240x240/drawables"
mkdir -p "${PROJECT_ROOT}/resources-round-260x260/drawables"
mkdir -p "${PROJECT_ROOT}/resources-round-280x280/drawables"
mkdir -p "${PROJECT_ROOT}/resources-round-360x360/drawables"
mkdir -p "${PROJECT_ROOT}/resources-round-390x390/drawables"
mkdir -p "${PROJECT_ROOT}/resources-round-416x416/drawables"
mkdir -p "${PROJECT_ROOT}/resources-round-454x454/drawables"
mkdir -p "${PROJECT_ROOT}/resources-rectangle-240x240/drawables"
mkdir -p "${PROJECT_ROOT}/resources-rectangle-320x360/drawables"

# 5. Check if the file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found."
    exit 1
fi

# 6. Generate the source icons into the base folder first
for size in 80 60 54 40 36 30; do
    OUTPUT_NAME="${BASE_DRAWABLES}/launcher_icon_${size}.png"
    echo "  Generating: $OUTPUT_NAME"
    
    inkscape "$INPUT_FILE" \
    --export-width=$size \
    --export-height=$size \
    --export-filename="$OUTPUT_NAME" 2> /dev/null
done

echo "Success! Icons generated. Distributing to device folders..."

# Move into the base drawables directory to start copying
pushd "$BASE_DRAWABLES" > /dev/null

# --- DISTRIBUTION STEP ---
# We copy the correctly sized icon to "launcher_icon.png" in the specific device folders

# 1. Set Default (80x80)
cp launcher_icon_80.png launcher_icon.png

# These devices are tiny (208x208) and need the smallest icon Forerunner 45, Swim 2
cp launcher_icon_30.png ../../resources-round-208x208/drawables/launcher_icon.png


# Venu Sq 2 is 'rectangle-320x360'. It has a high-res screen, so it needs 54px, not 36px.
cp launcher_icon_54.png ../../resources-rectangle-320x360/drawables/launcher_icon.png

# 2. Distribute 40x40 icons (For Fenix, Marq, FR245)
cp launcher_icon_40.png ../../resources-round-218x218/drawables/launcher_icon.png
cp launcher_icon_40.png ../../resources-round-240x240/drawables/launcher_icon.png
cp launcher_icon_40.png ../../resources-round-260x260/drawables/launcher_icon.png
cp launcher_icon_40.png ../../resources-round-280x280/drawables/launcher_icon.png

# 3. Distribute 60x60 icons (For Venu 2/3, FR265, FR965)
cp launcher_icon_60.png ../../resources-round-360x360/drawables/launcher_icon.png
cp launcher_icon_60.png ../../resources-round-390x390/drawables/launcher_icon.png
cp launcher_icon_60.png ../../resources-round-416x416/drawables/launcher_icon.png

# 4. Distribute 80x80 icons (For High-res, Epix Pro 51mm)
cp launcher_icon_80.png ../../resources-round-454x454/drawables/launcher_icon.png

# 5. Distribute 36x36 icons (For Venu Sq / Older devices)
cp launcher_icon_36.png ../../resources-rectangle-240x240/drawables/launcher_icon.png
# Venu Sq 2 is 'rectangle-320x360'. It has a high-res screen, so it needs 54px, not 36px.
cp launcher_icon_54.png ../../resources-rectangle-320x360/drawables/launcher_icon.png

# Cleanup: Remove the sized temp files from the base folder so you only have 'launcher_icon.png' (80x80) left
rm launcher_icon_30.png launcher_icon_36.png launcher_icon_40.png launcher_icon_54.png launcher_icon_60.png launcher_icon_80.png

popd > /dev/null

echo "Distribution complete. Cleaned up temporary files."
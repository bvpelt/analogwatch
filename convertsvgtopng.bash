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
BASE_DRAWABLES="${PROJECT_ROOT}/images"

echo "Project Root: $PROJECT_ROOT"

# 4. Create the STANDARD Connect IQ directory structure
# These must be siblings to 'resources', not inside it
mkdir -p "$BASE_DRAWABLES"

# Create the directories
mkdir -p icon-{30,35,36,40,54,56,60,61,65,70,80}/drawables
mkdir -p icon-va3m/drawables

# Move your correctly sized icons into them (assuming you have them or can resize them)
# Then copy the drawables.xml to each so the compiler sees the resource definition
find . -maxdepth 1 -name "icon-*" -exec cp resources/drawables/drawables.xml {}/drawables/ \;
cp resources/drawables/drawables.xml icon-va3m/drawables

# 5. Check if the file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found."
    exit 1
fi

# 6. Generate the source icons into the base folder first
for size in 30 35 36 40 54 56 60 61 65 70 80; do
    OUTPUT_NAME="${BASE_DRAWABLES}/launcher_icon_${size}.png"
    echo "  Generating: $OUTPUT_NAME"
    
    inkscape "$INPUT_FILE" \
    --export-width=$size \
    --export-height=$size \
    --export-filename="$OUTPUT_NAME" 2> /dev/null
done

echo "Success! Icons generated. Distributing to device folders..."

# Move into the base drawables directory to start copying

# --- DISTRIBUTION STEP ---
# We copy the correctly sized icon to "launcher_icon.png" in the specific device folders

for size in 30 35 36 40 54 56 60 61 65 70 80; do
    OUTPUT_NAME="${BASE_DRAWABLES}/launcher_icon_${size}.png"
    mv $OUTPUT_NAME "${PROJECT_ROOT}/icon-${size}/drawables/launcher_icon.png"
done
cp "${PROJECT_ROOT}/icon-80/drawables/launcher_icon.png" ${PROJECT_ROOT}/resources/drawables/

OUTPUT_NAME="${BASE_DRAWABLES}/launcher_icon_va3m.png"
echo "  Generating: $OUTPUT_NAME"

inkscape "$INPUT_FILE" \
--export-width=40 \
--export-height=33 \
--export-filename="$OUTPUT_NAME" 2> /dev/null

mv $OUTPUT_NAME "${PROJECT_ROOT}/icon-va3m/drawables/launcher_icon.png"

echo "Distribution complete. Cleaned up temporary files."
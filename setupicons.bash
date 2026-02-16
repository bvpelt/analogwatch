#!/bin/bash

# Run this from your project root directory
IMAGE_DIR="/home/bvpelt/Develop/analogwatch/resources/drawables"

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

# Assuming you have launcher_icon_80.png, etc. in resources/drawables/
cd resources/drawables

# Copy icons to appropriate folders
cp $IMAGE_DIR/launcher_icon_40.png ../drawables-round-218x218/launcher_icon.png
cp $IMAGE_DIR/launcher_icon_40.png ../drawables-round-240x240/launcher_icon.png
cp $IMAGE_DIR/launcher_icon_40.png ../drawables-round-260x260/launcher_icon.png
cp $IMAGE_DIR/launcher_icon_40.png ../drawables-round-280x280/launcher_icon.png
cp $IMAGE_DIR/launcher_icon_60.png ../drawables-round-360x360/launcher_icon.png
cp $IMAGE_DIR/launcher_icon_60.png ../drawables-round-390x390/launcher_icon.png
cp $IMAGE_DIR/launcher_icon_60.png ../drawables-round-416x416/launcher_icon.png
cp $IMAGE_DIR/launcher_icon_80.png ../drawables-round-454x454/launcher_icon.png
cp $IMAGE_DIR/launcher_icon_36.png ../drawables-rectangle-240x240/launcher_icon.png
cp $IMAGE_DIR/launcher_icon_36.png ../drawables-rectangle-320x360/launcher_icon.png

# Keep 80x80 as default in drawables/
cp $IMAGE_DIR/launcher_icon_80.png launcher_icon.png

echo "Icon directories created and populated!"

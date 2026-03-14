#!/bin/bash -xv

echo "Processing logo's"

# Black
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#000000;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-black.svg;export-do'

# Classic
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#ffcd22;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-classic.svg;export-do'

# Blue Steel, Blue, Orange, White, Whiteish, Black
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#a5a5a5;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-gray.svg;export-do'






#!/bin/bash -xv

echo "Processing logo's"

# Black
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#7f7f7f;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-black.svg;export-do'

# Classic
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#cb8180;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-classic.svg;export-do'

# White
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#7f7f7f;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-gray.svg;export-do'

# BlueSteelProfile
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#838da0;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-bluesteel.svg;export-do'

# BlueProfile
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#81a9d1;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-blue.svg;export-do'

# OrangeProfile
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#ffd97f;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-orange.svg;export-do'

# WhitishProfile
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#e2f3e4;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-whiteish.svg;export-do'

# White  
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#7f7f7f;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-white.svg;export-do'

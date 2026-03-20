#!/bin/bash -xv

echo "Processing logo's"

# Black
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#434343;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-black.svg;export-do'

# Classic
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#b80200;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-classic.svg;export-do'

# White
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#7f7f7f;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-gray.svg;export-do'

# BlueSteelProfile
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#838da0;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-bluesteel.svg;export-do'

# BlueProfile
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#81a9d1;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-blue.svg;export-do'

# OrangeProfile
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#ffca52;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-orange.svg;export-do'

# WhitishProfile
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#a4f3ae;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-whiteish.svg;export-do'

# White  
cat ./resources/drawables/vav-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#e9e9e9;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/vav-logo-white.svg;export-do'

## Bethel Logos


# Black
cat ./resources/drawables/bethel-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#434343;select-by-element:ellipse;object-set-property:fill,#434343;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/bethel-logo-black.svg;export-do'

# Classic
cat ./resources/drawables/bethel-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#b80200;select-by-element:ellipse;object-set-property:fill,#b80200;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/bethel-logo-classic.svg;export-do'

# White
cat ./resources/drawables/bethel-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#7f7f7f;select-by-element:ellipse;object-set-property:fill,#7f7f7f;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/bethel-logo-gray.svg;export-do'

# BlueSteelProfile
cat ./resources/drawables/bethel-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#838da0;select-by-element:ellipse;object-set-property:fill,#838da0;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/bethel-logo-bluesteel.svg;export-do'

# BlueProfile
cat ./resources/drawables/bethel-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#81a9d1;select-by-element:ellipse;object-set-property:fill,#81a9d1;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/bethel-logo-blue.svg;export-do'

# OrangeProfile
cat ./resources/drawables/bethel-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#ffca52;select-by-element:ellipse;object-set-property:fill,#ffca52;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/bethel-logo-orange.svg;export-do'

# WhitishProfile
cat ./resources/drawables/bethel-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#a4f3ae;select-by-element:ellipse;object-set-property:fill,#a4f3ae;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/bethel-logo-whiteish.svg;export-do'

# White  
cat ./resources/drawables/bethel-logo.svg | inkscape --pipe --actions='select-by-element:path;object-set-property:fill,#e9e9e9;select-by-element:ellipse;object-set-property:fill,#e9e9e9;export-filename:/home/bvpelt/Develop/analogwatch/resources/drawables/bethel-logo-white.svg;export-do'

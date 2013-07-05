#
# Generating random color in Sass
#
# http://victorcoulon.fr/notes/generating-random-color-in-sass
# 
# Usage
# @for $i from 1 through $len {
#     .item-#{$i} {
#         background:getRandomColor();
#     }
# }
###
module Sass::Script::Functions
    def getRandomColor()
        Sass::Script::String.new("#%06x" % (rand * 0xffffff))
    end
end

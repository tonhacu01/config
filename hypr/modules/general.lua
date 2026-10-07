local colors = require("colors")

hl.config ({    
    general = {
        gaps_in  = 8 ,
        gaps_out = 20,

        border_size = 2,

        col = {
            active_border = colors.active_border,
            inactive_border = colors.inactive_border,
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },
})

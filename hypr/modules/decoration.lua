-- Decorations
hl.config({
    decoration = {
        dim_around = 1,

        rounding       = 25,
        rounding_power = 3,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1,
        inactive_opacity = 1,

        shadow = {
            enabled      = true,
            range        = 28,
            render_power = 3,
            sharp        = false,
            color        = 0x890a0a0a,
        },

        blur = {
            enabled = false,
            passes  = 2   ,
        },
    },
})

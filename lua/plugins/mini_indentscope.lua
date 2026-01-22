return {
    "nvim-mini/mini.indentscope",
    version = "*",
    config = function()
        require("mini.indentscope").setup({
            draw = {
                animation = require('mini.indentscope').gen_animation.none(),
            }
        })

    end
}

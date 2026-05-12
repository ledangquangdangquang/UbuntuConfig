return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,

    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        -- floats = {
        --     transparent = true, -- enable transparent floating windows
        --     solid = true, -- use solid styling for floating windows, see |winborder|
        -- },
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}

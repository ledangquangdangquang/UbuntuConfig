return {
  "atiladefreitas/dooing",
  config = function()
    require("dooing").setup({
      -- your custom config here (optional)
      -- Window settings
      window = {
        width = 100, -- Width of the floating window
        height = 20, -- Height of the floating window
        border = "rounded", -- Border style: 'single', 'double', 'rounded', 'solid'
        zindex = 50, -- Base z-index for floating windows (uses zindex to zindex+5)
        position = "center", -- Window position: 'right', 'left', 'top', 'bottom', 'center',
        -- 'top-right', 'top-left', 'bottom-right', 'bottom-left'
        padding = {
          top = 1,
          bottom = 1,
          left = 2,
          right = 2,
        },
      },
    })
  end,
}

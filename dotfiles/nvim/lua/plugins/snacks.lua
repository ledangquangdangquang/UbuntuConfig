return {
  -- Disables the dashboard if using the newer snacks.nvim setup
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
    },
  },

  -- Disables the dashboard if using older alpha.nvim setup
  {
    "goolord/alpha-nvim",
    enabled = false,
  },
}

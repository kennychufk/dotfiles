return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {}
    local api = require "nvim-tree.api"
    local function nmap(l, r, buf, desc, extra_opts) -- introduced in Neovim v0.7
      local opts = { silent = true }
      extra_opts = extra_opts or {}
      if buf ~= nil then
        opts.buffer = buf
      end
      opts.desc = desc
      for k, v in pairs(extra_opts) do opts[k] = v end
      vim.keymap.set('n', l, r, opts)
    end
    nmap("<leader>e", api.tree.toggle, nil, "Toggle NvimTree")
  end,
}

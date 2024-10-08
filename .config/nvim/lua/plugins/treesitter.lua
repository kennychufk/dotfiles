return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({ -- enable syntax highlighting
      highlight = {
        enable = true,
      },
      sync_install = false,
      auto_install = false,
      ignore_install = { "all" },
      -- enable indentation
      indent = { enable = true },
      -- ensure these language parsers are installed
      ensure_installed = {
        -- web
        "json",
        "javascript",
        "yaml",
        "html",
        "css",
        -- documentation
        "markdown",
        "markdown_inline",
        "bibtex",
        -- "latex",
        -- system programming
        "bash",
        "lua",
        "vim",
        -- "yaml",
        -- container
        "dockerfile",
        -- git
        "gitignore",
        "gitcommit",
        "gitattributes",
        "git_config",
        "git_rebase",
        -- scientific
        "cmake",
        "cuda",
        "cpp",
        "c",
        "python",
        "matlab",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}

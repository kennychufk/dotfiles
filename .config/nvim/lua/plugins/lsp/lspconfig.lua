return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim",                   opts = {} },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local function nmap(l, r, buf, desc, extra_opts)
      local opts = { silent = true }
      extra_opts = extra_opts or {}
      if buf ~= nil then
        opts.buffer = buf
      end
      opts.desc = desc
      for k, v in pairs(extra_opts) do opts[k] = v end
      vim.keymap.set('n', l, r, opts) -- introduced in Neovim v0.7
    end
    local telescope = require('telescope.builtin')
    nmap("<leader>f", telescope.find_files, buf, "Search filenames in cwd")
    nmap("<leader>b", telescope.buffers, buf, "Search filenames in buffers")
    nmap("<leader>o", telescope.oldfiles, buf, "Search filenames in previously opened")
    nmap("<C-g>", telescope.live_grep, buf, "Live grep in cwd")
    nmap("<C-q>", telescope.help_tags, buf, "Lists available help tags")
    nmap("<leader>D", telescope.diagnostics,
      buf, "Lists Diagnostics for the current buffer. ")
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local telescope = require('telescope.builtin')
        local buf = ev.buf
        nmap("gD", vim.lsp.buf.declaration, buf, "Declaration")
        nmap("<leader>s", vim.lsp.buf.rename, buf, "Smart rename")
        nmap("<leader>d", vim.diagnostic.open_float, buf, "Show line diagnostics")
        nmap("K", vim.lsp.buf.hover, buf, "Show documentation for what is under cursor")
        nmap("<C-m>", vim.lsp.buf.format, buf, "Format current buffer", { buffer = true })

        nmap("gr", telescope.lsp_references, buf, "Lists LSP references for word under the cursor")
        nmap("gd", telescope.lsp_definitions,
          buf,
          "Goto the definition of the word under the cursor or show all options in Telescope"
        )
        nmap("gi", telescope.lsp_implementations,
          buf,
          "Goto the implementation of the word under the cursor or show all options in Telescope")
        nmap("gt", telescope.lsp_type_definitions,
          buf,
          "Goto the definition of the type of the word under the cursor or show all options in Telescope")
      end,
    })

    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    mason_lspconfig.setup_handlers({
      -- default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,
      ["lua_ls"] = function()
        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              -- make the language server recognize "vim" global
              diagnostics = {
                globals = { "vim" },
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        })
      end,
    })
  end,
}

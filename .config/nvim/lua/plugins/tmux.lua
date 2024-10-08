return {
  'aserowy/tmux.nvim',
  config = function()
    local tmux = require('tmux')
    tmux.setup({
      copy_sync = { enable = false },
      navigation = { cycle_navigation = false, enable_default_keybindings = true, persist_zoom = false },
    })
  end,
}

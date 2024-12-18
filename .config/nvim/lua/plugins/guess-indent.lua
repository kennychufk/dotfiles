return {
  "nmac427/guess-indent.nvim",
  config = function()
    local guess = require('guess-indent')
    guess.setup {}
  end,
} -- look at the first few hundred lines of the file to set tabstop, shiftwidth, etc.

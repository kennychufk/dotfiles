local status_ok, ibl = pcall(require, "ibl")
if not status_ok then
	return
end

ibl.setup({
	indent = { char = "▏" },
	exclude = {
		buftypes = { "terminal", "nofile" },
		filetypes = { "help", "startify", "dashboard", "packer", "neogitstatus", "NvimTree", "Trouble" },
	},
	whitespace = { remove_blankline_trail = true },
})

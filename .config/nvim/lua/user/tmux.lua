local status_ok, tmux = pcall(require, "tmux")
if not status_ok then
	return
end

tmux.setup({
	copy_sync = { enable = false },
	navigation = { cycle_navigation = false, enable_default_keybindings = true, persist_zoom = false },
})

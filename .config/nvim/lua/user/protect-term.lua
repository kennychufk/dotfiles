-- inspired by https://gist.github.com/ds26gte/034b9ac9edeaf86d0ff5c73f97dd530b
local num_termbufs = 0
local vi_has_termbufs = vim.fn.tempname() .. "_vi_session_has_open_terminal_buffers"
local temp_buf = nil

local add1_num_termbufs = function()
	num_termbufs = num_termbufs + 1
	print("num_termbufs = " .. num_termbufs)
	if num_termbufs == 1 then
		temp_buf = vim.api.nvim_create_buf(true, false)
		vim.api.nvim_buf_set_name(temp_buf, vi_has_termbufs)
		vim.api.nvim_buf_set_lines(temp_buf, 0, 0, true, { "There are unclosed terminals" })
		vim.api.nvim_buf_set_option(temp_buf, "modified", true)
	end
end

local sub1_num_termbufs = function()
	num_termbufs = num_termbufs - 1
	print("num_termbufs = " .. num_termbufs)
	if num_termbufs == 0 and temp_buf ~= nil then
		vim.api.nvim_buf_delete(temp_buf, { force = true })
		temp_buf = nil
	end
end
vim.api.nvim_create_autocmd({ "termopen" }, { pattern = { "*" }, callback = add1_num_termbufs })
vim.api.nvim_create_autocmd({ "termclose" }, { pattern = { "*" }, callback = sub1_num_termbufs })

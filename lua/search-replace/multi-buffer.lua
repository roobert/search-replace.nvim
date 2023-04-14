local M = {}

local util = require("search-replace.util")
local config = require("search-replace.config")

M.search_replace = function(pattern, opts)
	opts = opts or {}

	local shift = 0

	if string.len(pattern) == 0 then
		shift = 2
	else
		shift = 1
	end

	local left_keypresses =
		string.rep("\\<Left>", string.len(config.options.multi_buffer.flags) + shift)
	vim.cmd(
		':call feedkeys(":bufdo '
			.. opts.range or config.options.single_buffer.range
			.. 's/'
			.. util.double_escape(pattern)
			.. "//"
			.. opts.flags or config.options.multi_buffer.flags
			.. left_keypresses
			.. '")'
	)
end

M.visual_charwise_selection = function(opts)
	opts = opts or {}

	local visual_selection = util.get_visual_selection()

	if visual_selection == nil then
		print("search-replace does not support visual-blockwise selections")
		return
	end

	local backspace_keypresses = string.rep("\\<backspace>", 5)
	local left_keypresses =
		string.rep("\\<Left>", string.len(config.options.multi_buffer.flags) + 1)

	vim.cmd(
		':call feedkeys(":'
			.. backspace_keypresses
			.. opts.range or config.options.single_buffer.range
			.. "s/"
			.. util.double_escape(visual_selection)
			.. "//"
			.. opts.flags or config.options.multi_buffer.flags
			.. left_keypresses
			.. '")'
	)
end

M.open = function(opts)
	M.search_replace("", opts)
end

M.cword = function(opts)
	M.search_replace(vim.fn.expand("<cword>"), opts)
end

M.cWORD = function(opts)
	M.search_replace(vim.fn.expand("<cWORD>"), opts)
end

M.cexpr = function(opts)
	M.search_replace(vim.fn.expand("<cexpr>"), opts)
end

M.cfile = function(opts)
	M.search_replace(vim.fn.expand("<cfile>"), opts)
end

return M

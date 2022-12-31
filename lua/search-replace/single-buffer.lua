local M = {}

local util = require("search-replace.util")
local config = require("search-replace.config")

local search_replace_single_buffer = function(pattern)
	local left_keypresses = string.rep("\\<Left>", string.len(config.options["default_replace_options"]) + 1)
	vim.cmd(
		':call feedkeys(":%s/'
			.. util.double_escape(pattern)
			.. "//"
			.. config.options["default_replace_options"]
			.. left_keypresses
			.. '")'
	)
end

M.search_replace_single_buffer_visual_selection = function()
	local visual_selection = util.get_visual_selection()

	if visual_selection == nil then
		print("search-replace does not support replacing visual blocks")
		return
	end

	local backspace_keypresses = string.rep("\\<backspace>", 5)
	local left_keypresses = string.rep("\\<Left>", string.len(config.options["default_replace_options"]) + 1)

	vim.cmd(
		':call feedkeys(":'
			.. backspace_keypresses
			.. "%s/"
			.. util.double_escape(visual_selection)
			.. "//"
			.. config.options["default_replace_options"]
			.. left_keypresses
			.. '")'
	)
end

M.search_replace_single_buffer_cword = function()
	search_replace_single_buffer(vim.fn.expand("<cword>"))
end

M.search_replace_single_buffer_cWORD = function()
	search_replace_single_buffer(vim.fn.expand("<cWORD>"))
end

M.search_replace_single_buffer_cexpr = function()
	search_replace_single_buffer(vim.fn.expand("<cexpr>"))
end

M.search_replace_single_buffer_cfile = function()
	search_replace_single_buffer(vim.fn.expand("<cfile>"))
end

return M

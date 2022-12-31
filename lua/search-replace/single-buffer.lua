local M = {}

local util = require("search-replace.util")
local config = require("search-replace.config")

M.search_replace = function(pattern)
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

M.visual_selection = function()
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

M.cword = function()
	M.search_replace(vim.fn.expand("<cword>"))
end

M.cWORD = function()
	M.search_replace(vim.fn.expand("<cWORD>"))
end

M.cexpr = function()
	M.search_replace(vim.fn.expand("<cexpr>"))
end

M.cfile = function()
	M.search_replace(vim.fn.expand("<cfile>"))
end

return M

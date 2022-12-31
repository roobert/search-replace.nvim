local M = {}

local config = require("search-replace.config")
local util = require("search-replace.util")

local search_replace_single_buffer_within_block = function(pattern)
	local left_keypresses = string.rep("\\<Left>", string.len(config.options["default_replace_options"]) + 1)
	vim.cmd(
		':call feedkeys(":s/'
			.. util.double_escape(pattern)
			.. "//"
			.. config.options["default_replace_options"]
			.. left_keypresses
			.. '")'
	)
end

-- FIXME:
-- * is this a good feature?
-- * do we need implementations for cfile/cWORD/cexpr too?
M.search_replace_within_block = function()
	search_replace_single_buffer_within_block(vim.fn.expand("<cword>"))
end

return M

M = {}

local config = require("search-replace.config")
local ui = require("search-replace.ui")
local single_buffer = require("search-replace.single-buffer")
local multi_buffer = require("search-replace.multi-buffer")

local cmd = vim.api.nvim_create_user_command

local function setup_commands_single_buffer()
	cmd("SearchReplaceSingleBufferSelections", ui.single_buffer_selections, {})

	cmd("SearchReplaceSingleBufferCWord", single_buffer.cword, {})
	cmd("SearchReplaceSingleBufferCWORD", single_buffer.cWORD, {})
	cmd("SearchReplaceSingleBufferCExpr", single_buffer.cexpr, {})
	cmd("SearchReplaceSingleBufferCFile", single_buffer.cfile, {})

	-- cmd(
	-- 	"SearchReplaceSingleBufferVisualSelection",
	-- 	single_buffer.search_replace_single_buffer_visual_selection,
	-- 	{ range = true }
	-- )

	-- cmd(
	-- 	"SearchReplaceSingleBufferWithinBlock",
	-- 	single_buffer.search_replace_single_buffer_within_block,
	-- 	{ range = true }
	-- )
end

local function setup_commands_multi_buffer()
	cmd("SearchReplaceMultiBufferSelections", ui.multi_buffer_selections, {})

	cmd("SearchReplaceMultiBufferCWord", multi_buffer.cword, {})
	cmd("SearchReplaceMultiBufferCWORD", multi_buffer.cWORD, {})
	cmd("SearchReplaceMultiBufferCExpr", multi_buffer.cexpr, {})
	cmd("SearchReplaceMultiBufferCFile", multi_buffer.cfile, {})

	-- cmd(
	-- 	"SearchReplaceMultiBufferVisualSelection",
	-- 	multi_buffer.search_replace_multi_buffer_visual_selection,
	-- 	{ range = true }
	-- )
end

M.setup = function(options)
	-- merge user supplied options with defaults..
	for k, v in pairs(options) do
		config.options[k] = v
	end

	setup_commands_single_buffer()
	setup_commands_multi_buffer()
end

return M

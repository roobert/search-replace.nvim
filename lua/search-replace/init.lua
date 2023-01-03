M = {}

local config = require("search-replace.config")
local ui = require("search-replace.ui")

local cmd = vim.api.nvim_create_user_command

local function setup_commands_single_buffer()
	local single_buffer = require("search-replace.single-buffer")

	cmd("SearchReplaceSingleBufferSelections", ui.single_buffer_selections, {})

	cmd("SearchReplaceSingleBufferOpen", single_buffer.open, {})
	cmd("SearchReplaceSingleBufferCWord", single_buffer.cword, {})
	cmd("SearchReplaceSingleBufferCWORD", single_buffer.cWORD, {})
	cmd("SearchReplaceSingleBufferCExpr", single_buffer.cexpr, {})
	cmd("SearchReplaceSingleBufferCFile", single_buffer.cfile, {})

	-- NOTE:
	-- visual selection search/replace - only available via a key binding/direct
	-- call since it's not possible to use leader key bindings in visual mode
	cmd("SearchReplaceSingleBufferVisualSelection", single_buffer.visual_charwise_selection, { range = true })
end

local function setup_commands_multi_buffer()
	local multi_buffer = require("search-replace.multi-buffer")

	cmd("SearchReplaceMultiBufferSelections", ui.multi_buffer_selections, {})

	cmd("SearchReplaceMultiBufferOpen", multi_buffer.open, {})
	cmd("SearchReplaceMultiBufferCWord", multi_buffer.cword, {})
	cmd("SearchReplaceMultiBufferCWORD", multi_buffer.cWORD, {})
	cmd("SearchReplaceMultiBufferCExpr", multi_buffer.cexpr, {})
	cmd("SearchReplaceMultiBufferCFile", multi_buffer.cfile, {})

	-- NOTE:
	-- visual selection search/replace - only available via a key binding/direct
	-- call since it's not possible to use leader key bindings in visual mode
	cmd("SearchReplaceMultiBufferVisualSelection", multi_buffer.visual_charwise_selection, { range = true })
end

local function setup_commands_visual_selections()
	local visual_multitype = require("search-replace.visual-multitype")

	cmd("SearchReplaceWithinVisualSelection", visual_multitype.within, { range = true })
	cmd("SearchReplaceWithinVisualSelectionCWord", visual_multitype.within_cword, { range = true })
	cmd("SearchReplaceWithinVisualSelectionCWORD", visual_multitype.within_cWORD, { range = true })
	cmd("SearchReplaceWithinVisualSelectionCExpr", visual_multitype.within_cexpr, { range = true })
	cmd("SearchReplaceWithinVisualSelectionCFile", visual_multitype.within_cfile, { range = true })
end

M.setup = function(options)
	if options == nil then
		options = {}
	end

	-- merge user supplied options with defaults..
	for k, v in pairs(options) do
		config.options[k] = v
	end

	setup_commands_single_buffer()
	setup_commands_multi_buffer()
	setup_commands_visual_selections()
end

return M

local M = {}

-- local function get_visual_selection()
-- 	local _, ls, cs = unpack(vim.fn.getpos("v"))
-- 	local _, le, ce = unpack(vim.fn.getpos("."))
-- 	return table.contact(vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {}), "\n")
-- end

-- TODO:
-- * show selections in a window or something instead of just using print
-- * catch errors when failing visual block selection
-- * improve get_visual_selection()

-- FIXME:
local function get_visual_selection()
	local s_start = vim.fn.getpos("'<")
	local s_end = vim.fn.getpos("'>")
	local n_lines = math.abs(s_end[2] - s_start[2]) + 1
	local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)

	if next(lines) == nil then
		return nil
	end

	lines[1] = string.sub(lines[1], s_start[3], -1)

	if n_lines == 1 then
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
	else
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
	end

	return table.concat(lines, "\n")
end

local escape_characters = '"\\/.*$^~[]'

local function search_replace_selections()
	local cword = vim.fn.escape(vim.fn.expand("<cword>"), escape_characters)
	local cWORD = vim.fn.escape(vim.fn.expand("<cWORD>"), escape_characters)
	local cexpr = vim.fn.escape(vim.fn.expand("<cexpr>"), escape_characters)
	local cfile = vim.fn.escape(vim.fn.expand("<cfile>"), escape_characters)
	local visual_selection = vim.fn.escape(get_visual_selection(), escape_characters)
	print("c[w]ord: " .. cword)
	print("c[W]ORD: " .. cWORD)
	print("c[e]xpr: " .. cexpr)
	print("c[f]ile: " .. cfile)
	if not visual_selection == nil then
		print("visual selection: " .. visual_selection)
	end
end

-- double escaping is required due to interpretation by feedkeys and then search/replace
local function double_escape(str)
	return vim.fn.escape(vim.fn.escape(str, escape_characters), escape_characters)
end

local function search_replace_cword()
	local cword = double_escape(vim.fn.expand("<cword>"))
	vim.cmd(':call feedkeys(":%s/' .. cword .. '//gcI\\<Left>\\<Left>\\<Left>\\<Left>")')
end

local function search_replace_cWORD()
	local cWORD = double_escape(vim.fn.expand("<cWORD>"))
	vim.cmd(':call feedkeys(":%s/' .. cWORD .. '//gcI\\<Left>\\<Left>\\<Left>\\<Left>")')
end

local function search_replace_cexpr()
	local cexpr = double_escape(vim.fn.expand("<cexpr>"))
	vim.cmd(':call feedkeys(":%s/' .. cexpr .. '//gcI\\<Left>\\<Left>\\<Left>\\<Left>")')
end

local function search_replace_cfile()
	local cfile = double_escape(vim.fn.expand("<cfile>"))
	vim.cmd(':call feedkeys(":%s/' .. cfile .. '//gcI\\<Left>\\<Left>\\<Left>\\<Left>")')
end

-- FIXME: visual mode works but visual-block should error
local function search_replace_visual()
	local visual_selection = double_escape(get_visual_selection())
	vim.cmd(':call feedkeys(":%s/' .. visual_selection .. '//gcI\\<Left>\\<Left>\\<Left>\\<Left>")')
end

local function setup_commands()
	local cmd = vim.api.nvim_create_user_command

	cmd("SearchReplaceSelections", search_replace_selections, { range = true })
	cmd("SearchReplaceCWord", search_replace_cword, { range = true })
	cmd("SearchReplaceCWORD", search_replace_cWORD, { range = true })
	cmd("SearchReplaceCExpr", search_replace_cexpr, { range = true })
	cmd("SearchReplaceCFile", search_replace_cfile, { range = true })
	cmd("SearchReplaceVisual", search_replace_visual, { range = true })
end

function M.setup(_)
	setup_commands()
end

return M

local M = {}

-- FIXME: improve get_visual_selection
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

local function search_replace_visual_block()
	local selection = get_visual_selection()
	vim.cmd(':call feedkeys(":%s/' .. selection .. '//gcI\\<Left>\\<Left>\\<Left>\\<Left>")')
end

local function search_replace_cword()
  local word = vim.fn.expand('<cword>')
	vim.cmd(':call feedkeys(":%s/' .. word ..  '//gcI\\<Left>\\<Left>\\<Left>\\<Left>")')
end

local function search_replace_CWORD()
  local word = vim.fn.expand('<CWORD>')
	vim.cmd(':call feedkeys(":%s/' .. word ..  '//gcI\\<Left>\\<Left>\\<Left>\\<Left>")')
end

local function search_replace_cexpr()
  local cexpr = vim.fn.expand('<cexpr>')
	vim.cmd(':call feedkeys(":%s/' .. cexpr ..  '//gcI\\<Left>\\<Left>\\<Left>\\<Left>")')
end

local function setup_commands()
	local cmd = vim.api.nvim_create_user_command

	cmd("SearchReplace", search_replace_cword, { range = true })
	cmd("SearchReplaceCWORD", search_replace_CWORD, { range = true })
	cmd("SearchReplaceCExpr", search_replace_cexpr, { range = true })
	cmd("SearchReplaceVisualBlock", search_replace_visual_block, { range = true })
end

function M.setup(_)
	setup_commands()
end

return M

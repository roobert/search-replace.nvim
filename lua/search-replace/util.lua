local M = {}

-- FIXME: how to handle <>'s, etc.
local escape_characters = '"\\/.*$^~[]'

-- double escaping is required due to interpretation by feedkeys and then search/replace
M.double_escape = function(str)
	return vim.fn.escape(vim.fn.escape(str, escape_characters), escape_characters)
end

-- FIXME:
-- * improve this
M.get_visual_selection = function()
	local s_start = vim.fn.getpos("'<")
	local s_end = vim.fn.getpos("'>")
	local n_lines = math.abs(s_end[2] - s_start[2]) + 1

	if n_lines > 1 then
		return nil
	end

	local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)

	if next(lines) == nil then
		return "no selection"
	end

	lines[1] = string.sub(lines[1], s_start[3], -1)

	if n_lines == 1 then
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
	else
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
	end

	return table.concat(lines, "\n")
end

return M

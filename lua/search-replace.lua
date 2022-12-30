-- TODO:
-- * catch errors when failing visual block selection
-- * improve get_visual_selection()
-- * implement multiple-buffer search/replace

local M = {}

local buf, win
local start_win

local function set_mappings(cword, cexpr, cfile, cWORD, visual_selection)
	-- FIXME:
	-- * <>- are not being passed through for some reason..
	local mappings = {
		q = "close()",
		w = "search_replace('" .. cword .. "')",
		e = "search_replace('" .. cexpr .. "')",
		f = "search_replace('" .. cfile .. "')",
		W = "search_replace('" .. cWORD .. "')",
		v = "search_replace('" .. visual_selection .. "')",
	}

	for k, v in pairs(mappings) do
		vim.api.nvim_buf_set_keymap(
			buf,
			"n",
			k,
			':lua require"search-replace".close()<cr> | :lua require"search-replace".' .. v .. "<cr>",
			{
				nowait = true,
				noremap = true,
				silent = true,
			}
		)
	end
end

-- FIXME:
-- * prevent opening new win/buf multiple times
-- * auto-calculate window buffer size
local function create_win(cword, cexpr, cfile, cWORD, visual_selection)
	start_win = vim.api.nvim_get_current_win()

	vim.api.nvim_command("6split +enew")

	win = vim.api.nvim_get_current_win()
	buf = vim.api.nvim_get_current_buf()

	vim.api.nvim_buf_set_name(buf, "SearchReplace selections")

	vim.api.nvim_buf_set_option(buf, "modifiable", false)

	vim.api.nvim_win_set_option(win, "wrap", false)
	vim.api.nvim_win_set_option(win, "cursorline", true)
	vim.api.nvim_win_set_option(win, "number", false)

	--vim.api.nvim_buf_set_option(buf, "norelativenumber", true)

	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
	vim.api.nvim_buf_set_option(buf, "swapfile", false)
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(buf, "filetype", "nvim-search-replace")

	set_mappings(cword, cexpr, cfile, cWORD, visual_selection)
end

M.close = function()
	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, true)
	end
end

-- local function get_visual_selection()
-- 	local _, ls, cs = unpack(vim.fn.getpos("v"))
-- 	local _, le, ce = unpack(vim.fn.getpos("."))
-- 	return table.contact(vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {}), "\n")
-- end

-- FIXME:
local function get_visual_selection()
	local s_start = vim.fn.getpos("'<")
	local s_end = vim.fn.getpos("'>")
	local n_lines = math.abs(s_end[2] - s_start[2]) + 1
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

-- FIXME: how to handle <>'s, etc.
local escape_characters = '"\\/.*$^~[]'

M.search_replace_selections = function()
	local cword = vim.fn.expand("<cword>")
	local cexpr = vim.fn.expand("<cexpr>")
	local cfile = vim.fn.expand("<cfile>")
	local cWORD = vim.fn.expand("<cWORD>")
	local visual_selection = get_visual_selection()

	-- FIXME:
	-- * passing these around is not ideal..
	-- * ideally <cword> etc. would not change when win/buf is opened..
	create_win(cword, cexpr, cfile, cWORD, visual_selection)

	local list = {}
	table.insert(list, #list + 1, "[w]ord:   " .. vim.fn.escape(cword, escape_characters))
	table.insert(list, #list + 1, "[e]xpr:   " .. vim.fn.escape(cexpr, escape_characters))
	table.insert(list, #list + 1, "[f]ile:   " .. vim.fn.escape(cfile, escape_characters))
	table.insert(list, #list + 1, "[W]ORD:   " .. vim.fn.escape(cWORD, escape_characters))
	table.insert(list, #list + 1, "[v]isual: " .. vim.fn.escape(visual_selection, escape_characters))

	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, list)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

-- double escaping is required due to interpretation by feedkeys and then search/replace
local function double_escape(str)
	return vim.fn.escape(vim.fn.escape(str, escape_characters), escape_characters)
end

-- FIXME:
-- * allow specifying the default end options?
M.search_replace = function(pattern)
	vim.cmd(':call feedkeys(":%s/' .. double_escape(pattern) .. '//gcI\\<Left>\\<Left>\\<Left>\\<Left>")')
end

M.search_replace_cword = function()
	M.search_replace(vim.fn.expand("<cword>"))
end

M.search_replace_cWORD = function()
	M.search_replace(vim.fn.expand("<cWORD>"))
end

M.search_replace_cexpr = function()
	M.search_replace(vim.fn.expand("<cexpr>"))
end

M.search_replace_cfile = function()
	M.search_replace(vim.fn.expand("<cfile>"))
end

-- FIXME: visual mode works but visual-block should error
M.search_replace_visual = function()
	M.search_replace(get_visual_selection())
end

local function setup_commands()
	local cmd = vim.api.nvim_create_user_command

	-- FIXME:
	-- * range option is probably not required for every set of args here..
	-- * change these to use M.search_replace()?
	cmd("SearchReplaceSelections", M.search_replace_selections, { range = true })
	cmd("SearchReplaceCWord", M.search_replace_cword, { range = true })
	cmd("SearchReplaceCWORD", M.search_replace_cWORD, { range = true })
	cmd("SearchReplaceCExpr", M.search_replace_cexpr, { range = true })
	cmd("SearchReplaceCFile", M.search_replace_cfile, { range = true })
	cmd("SearchReplaceVisual", M.search_replace_visual, { range = true })
end

function M.setup(_)
	setup_commands()
end

return M

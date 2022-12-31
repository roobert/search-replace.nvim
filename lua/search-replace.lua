-- TODO:
-- * catch errors when failing visual block selection
-- * improve get_visual_selection()
-- * implement multiple-buffer search/replace

local M = {}

local state = { window_open = false }
local config = {}

local buf, win

local function set_keymap(cword, cexpr, cfile, cWORD, visual_selection)
	if visual_selection == nil then
		visual_selection = ""
	end

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

local function create_win()
	if state["window_open"] then
		print("search-replace selections window already open")
		return
	end

	state["window_open"] = true

	-- FIXME:
	-- * auto-calculate window buffer size
	vim.api.nvim_command("6split +enew")

	win = vim.api.nvim_get_current_win()
	buf = vim.api.nvim_get_current_buf()

	vim.api.nvim_buf_set_name(buf, "SearchReplace selections")

	vim.api.nvim_win_set_option(win, "wrap", false)
	vim.api.nvim_win_set_option(win, "cursorline", true)
	vim.api.nvim_win_set_option(win, "number", false)

	-- FIXME:
	-- * vim.api.nvim_buf_set_option(buf, "norelativenumber", true)
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
	vim.api.nvim_buf_set_option(buf, "swapfile", false)
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(buf, "filetype", "nvim-search-replace")
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

M.close = function()
	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, true)
	end

	state["window_open"] = false
end

-- FIXME:
-- * improve this
local function get_visual_selection()
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

-- FIXME: how to handle <>'s, etc.
local escape_characters = '"\\/.*$^~[]'

M.search_replace_selections = function()
	local cword = vim.fn.expand("<cword>")
	local cexpr = vim.fn.expand("<cexpr>")
	local cfile = vim.fn.expand("<cfile>")
	local cWORD = vim.fn.expand("<cWORD>")
	local visual_selection = get_visual_selection()

	if visual_selection == nil then
		visual_selection = ""
	end

	-- FIXME:
	-- * passing these around is not ideal..
	-- * ideally <cword> etc. would not change when win/buf is opened..
	create_win()
	set_keymap(cword, cexpr, cfile, cWORD, visual_selection)

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

M.search_replace = function(pattern)
	vim.cmd(
		':call feedkeys(":%s/'
			.. double_escape(pattern)
			.. "//"
			.. config["default_replace_options"]
			.. '\\<Left>\\<Left>\\<Left>\\<Left>")'
	)
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

M.search_replace_visual = function()
	local visual_selection = get_visual_selection()

	if visual_selection == nil then
		print("search-replace does not support replacing visual blocks")
		return
	end

	M.search_replace(get_visual_selection())
end

local function setup_commands()
	local cmd = vim.api.nvim_create_user_command

	cmd("SearchReplaceSelections", M.search_replace_selections, {})

	cmd("SearchReplaceCWord", M.search_replace_cword, {})
	cmd("SearchReplaceCWORD", M.search_replace_cWORD, {})
	cmd("SearchReplaceCExpr", M.search_replace_cexpr, {})
	cmd("SearchReplaceCFile", M.search_replace_cfile, {})

	cmd("SearchReplaceVisual", M.search_replace_visual, { range = true })
end

function M.setup(options)
	config = options
	if config["default_replace_options"] == nil then
		config["default_replace_options"] = "gcI"
	end
	setup_commands()
end

return M

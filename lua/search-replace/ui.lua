local M = {}

local state = { window_open = false }

local util = require("search-replace.util")

local buf, win

local function set_keymap(mode, cword, cexpr, cfile, cWORD)
	local search_replace_function = ""
	if mode == "single" then
		search_replace_function = "search_replace_single_buffer"
	elseif mode == "multi" then
		search_replace_function = "search_replace_multi_buffer"
	end

	-- FIXME:
	-- * <>- are not being passed through for some reason..
	local mappings = {
		q = "close()",
		w = search_replace_function .. "('" .. cword .. "')",
		e = search_replace_function .. "('" .. cexpr .. "')",
		f = search_replace_function .. "('" .. cfile .. "')",
		W = search_replace_function .. "('" .. cWORD .. "')",
	}

	for k, v in pairs(mappings) do
		vim.api.nvim_buf_set_keymap(
			buf,
			"n",
			k,
			':lua require("search-replace").close()<cr> | :lua require("search-replace").' .. v .. "<cr>",
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
	vim.api.nvim_command("5split +enew")

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

local function search_replace_selections(mode)
	local cword = vim.fn.expand("<cword>")
	local cexpr = vim.fn.expand("<cexpr>")
	local cfile = vim.fn.expand("<cfile>")
	local cWORD = vim.fn.expand("<cWORD>")

	-- FIXME:
	-- * passing these around is not ideal..
	-- * ideally <cword> etc. would not change when win/buf is opened..
	create_win()
	set_keymap(mode, cword, cexpr, cfile, cWORD)

	local list = {}
	table.insert(list, #list + 1, "[w]ord:   " .. vim.fn.escape(cword, util.escape_characters))
	table.insert(list, #list + 1, "[e]xpr:   " .. vim.fn.escape(cexpr, util.escape_characters))
	table.insert(list, #list + 1, "[f]ile:   " .. vim.fn.escape(cfile, util.escape_characters))
	table.insert(list, #list + 1, "[W]ORD:   " .. vim.fn.escape(cWORD, util.escape_characters))

	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, list)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

M.search_replace_single_buffer_selections = function()
	print("fuckfuck")
	search_replace_selections("single")
end

M.search_replace_multi_buffer_selections = function()
	search_replace_selections("multi")
end

return M

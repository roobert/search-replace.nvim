local M = {}

local state = { window_open = false }

local util = require("search-replace.util")

local buf_id, win_id

local function set_keymap(mode, cword, cexpr, cfile, cWORD)
	local search_replace_function = ""

	if mode == "single" then
		search_replace_function = "require('search-replace.single-buffer').search_replace"
	elseif mode == "multi" then
		search_replace_function = "require('search-replace.multi-buffer').search_replace"
	end

	-- FIXME:
	-- * <>- are not being passed through for some reason..
	local mappings = {
		w = search_replace_function .. "('" .. cword .. "')",
		e = search_replace_function .. "('" .. cexpr .. "')",
		f = search_replace_function .. "('" .. cfile .. "')",
		W = search_replace_function .. "('" .. cWORD .. "')",
	}

	for k, v in pairs(mappings) do
		vim.api.nvim_buf_set_keymap(
			buf_id,
			"n",
			k,
			':lua require("search-replace.ui").close()<cr> | :lua ' .. v .. "<cr>",
			{
				nowait = true,
				noremap = true,
				silent = true,
			}
		)
	end

	vim.api.nvim_buf_set_keymap(buf_id, "n", "q", ":lua require('search-replace.ui').close()<cr>", {
		nowait = true,
		noremap = true,
		silent = true,
	})
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

	win_id = vim.api.nvim_get_current_win()
	buf_id = vim.api.nvim_get_current_buf()

	vim.api.nvim_buf_set_name(buf_id, "SearchReplace selections")

	vim.api.nvim_set_option_value("wrap", false, { win = win_id })
	vim.api.nvim_set_option_value("cursorline", false, { win = win_id })
	vim.api.nvim_set_option_value("number", false, { win = win_id })
	vim.api.nvim_set_option_value("relativenumber", false, { win = win_id })

	vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf_id })
	vim.api.nvim_set_option_value("swapfile", false, { buf = buf_id })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf_id })
	vim.api.nvim_set_option_value("filetype", "nvim-search-replace", { buf = buf_id })
	vim.api.nvim_set_option_value("modifiable", false, { buf = buf_id })
end

M.close = function()
	if win_id and vim.api.nvim_win_is_valid(win_id) then
		vim.api.nvim_win_close(win_id, true)
	end

	state["window_open"] = false
end

local function selections(mode)
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
	table.insert(list, #list + 1, "[w]ord:   " .. cword)
	table.insert(list, #list + 1, "[e]xpr:   " .. cexpr)
	table.insert(list, #list + 1, "[f]ile:   " .. cfile)
	table.insert(list, #list + 1, "[W]ORD:   " .. cWORD)

	vim.api.nvim_buf_set_option(buf_id, "modifiable", true)
	vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, list)
	vim.api.nvim_buf_set_option(buf_id, "modifiable", false)
end

M.single_buffer_selections = function()
	selections("single")
end

M.multi_buffer_selections = function()
	selections("multi")
end

return M

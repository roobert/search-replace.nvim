local M = {}

M.options = {
	single_buffer = {
		range = "%",
		flags = "gcI",
	},
	multi_buffer = {
		range = "%",
		flags = "egcI",
	},
}

return M

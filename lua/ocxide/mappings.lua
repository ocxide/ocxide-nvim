vim.g.mapleader = " "
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')

local M = {}

M.find = {
	{ "n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" } },
	{ "n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Find Old files" } },
	{ "n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" } },
	-- Maybe replaceable
	{ "n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "List buffers" } },
	{ "n", "<leader>fp", "<cmd>Telescope commands<cr>", { desc = "List commands" } },

	{ "n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find Help" } },

	{
		"n",
		"<leader>fd",
		":Telescope file_browser path=%:p:h select_buffer=true<CR>",
	},
}

M.git = {
	{ "n", "<leader>gt", "<cmd>Telescope git_status<cr>", { desc = "Git status" } },
	{ "n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" } },
}

return M

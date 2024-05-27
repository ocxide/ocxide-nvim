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

M.git_fugitive = {
	lazy = true,
	{ "n", "<leader>gs", function() vim.cmd.Git() end, { desc = "Git status" } },
	{
		"n", "<leader>gco",
		function ()
			local status = vim.api.nvim_cmd({ cmd = "Git", args = { "status" } }, { output = true })
			print(vim.inspect(status))
		end
	}
}

---@format disable-next
M.lsp = {
	lazy = true,
	{ "n", "K", vim.lsp.buf.hover, { desc = "Hover" } },
	{ "n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" } },
	{ "n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" } },
	{ "n", "gr", vim.lsp.buf.references, { desc = "References" } },
	{ "n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" } },

	{ "n", "<leader>vd", vim.diagnostic.open_float, { desc = "Show diagnostics" } },
	{ "n", "<leader>sh", vim.lsp.buf.signature_help, { desc = "Show signature help" } },

	{ "n", "<leader>ra", vim.lsp.buf.rename, { desc = "Rename" } },
	{ "n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" } },
}

M.codeium = {
	{ "i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { desc = "Accept the current completion", expr = true } },
}

return M

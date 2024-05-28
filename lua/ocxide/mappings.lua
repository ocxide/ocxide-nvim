vim.g.mapleader = " "
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')

local M = {}

M.find = {
	{ "n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" } },
	{ "n", "<leader>fo", "<cmd>Telescope oldfiles<cr>",   { desc = "Find Old files" } },
	{ "n", "<leader>fw", "<cmd>Telescope live_grep<cr>",  { desc = "Live grep" } },
	-- Maybe replaceable
	{ "n", "<leader>fb", "<cmd>Telescope buffers<cr>",    { desc = "List buffers" } },
	{ "n", "<leader>fp", "<cmd>Telescope commands<cr>",   { desc = "List commands" } },

	{ "n", "<leader>fh", "<cmd>Telescope help_tags<cr>",  { desc = "Find Help" } },

	{
		"n",
		"<leader>fd",
		":Telescope file_browser path=%:p:h select_buffer=true<CR>",
	},
}

M.git = {
	{ "n", "<leader>gt", "<cmd>Telescope git_status<cr>",  { desc = "Git status" } },
	{ "n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" } },
}

M.git_fugitive = {
	lazy = true,
	{ "n", "<leader>gs",  function() vim.cmd.Git() end,                { desc = "Git status" } },
	{ "n", "<leader>gco", require("ocxide-system.builtin").git_commit, { desc = "Commits the current changes" } },
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

M.rust = {
	lazy = true,
	{ "n", "<leader>ca", function() vim.cmd.RustLsp("codeAction") end,        { desc = "Rust Code action" } },
	{ "n", "<leader>vd", function() vim.cmd.RustLsp("renderDiagnostic") end,  { desc = "Rust Show diagnostics" } },
	{ "n", "<leader>ve", function() vim.cmd.RustLsp("explainError") end,      { desc = "Rust Explain error" } },
}

M.format = {
	{ "n", "<leader>fm", vim.lsp.buf.format, { desc = "Format" } },
}

M.codeium = {
	{ "i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { desc = "Accept the current completion", expr = true } },
}

M.trouble = {
	lazy = true,
	{ "n", "<leader>tt", "<cmd>TroubleToggle<cr>",                                                        { desc = "Toggle trouble" } },
	{ "n", "[t",         function() require("trouble").next({ skip_groups = true, jump = true }) end,     { desc = "Go to definition" } },
	{ "n", "]t",         function() require("trouble").previous({ skip_groups = true, jump = true }) end, { desc = "Go to definition" } },
}

M.dap = {
	lazy = true,
	{ "n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle breakpoint" } },
	{ "n", "<leader>dus", function() require("dapui").toggle() end, { desc = "Toggle DAP UI" } },
}

return M

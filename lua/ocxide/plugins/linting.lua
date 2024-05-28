return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "biomejs" },
			typescript = { "biomejs" },
			javascriptreact = { "biomejs" },
			typescriptreact = { "biomejs" },
			svelte = { "biomejs" },
			astro = { "biomejs" },
		}

		local ocxide_Lint = vim.api.nvim_create_augroup("ocxide_Lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
			group = ocxide_Lint,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}

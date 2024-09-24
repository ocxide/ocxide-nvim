return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier", "biome" },
				typescript = { "prettier", "biome" },
				typescriptreact = { "prettier" },
				astro = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				sass = { "prettier", "biome" },
				scss = { "prettier", "biome" },
				html = { "prettier", "biome" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				rust = { "rustfmt" },
				cs = { "csharpier" },
				vue = { "prettier", "biome" }
			},
			-- Set the log level. Use `:ConformInfo` to see the location of the log file.
			log_level = vim.log.levels.ERROR,
			-- Conform will notify you when a formatter errors
			notify_on_error = true,
		})
	end,
}

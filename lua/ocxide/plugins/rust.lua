return {
	"mrcjkb/rustaceanvim",
	ft = "rust",
	dependencies = {
		-- It does not really deppends on, but ensure to load it first (mappings overriding)
		"neovim/nvim-lspconfig",
		-- Await for debbuging config
		"rcarriga/nvim-dap-ui"
	},
	config = function()
		local ocide_rust = vim.api.nvim_create_augroup("ocxide_rust", {})
		vim.api.nvim_create_autocmd("LspAttach", {
			pattern = "*.rs",
			group = ocide_rust,
			callback = function(event)
				require("ocxide-system.keymaps").load("rust", { buffer = event.buf })
			end,
		})

		vim.g.rustaceanvim = {
			dap = {
				adapter = require("ocxide.settings.dap").adapter,
			}
		}
		vim.g.rustaceanvim.server = {
			default_settings = {
				-- rust-analyzer language server configuration
				["rust-analyzer"] = {
					cargo = {
						loadOutDirsFromCheck = true,
						runBuildScripts = true,
					},
					-- Add clippy lints for Rust.
					checkOnSave = {
						-- maybe later use
						-- allFeatures = true,
						command = "clippy",
						extraArgs = { "--no-deps" },
					},
				},
			}
		}
	end
}

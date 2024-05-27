return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		-- "hrsh7th/cmp-nvim-lsp",
		-- "hrsh7th/cmp-buffer",
		-- "hrsh7th/cmp-path",
		-- "hrsh7th/cmp-cmdline",
		-- "hrsh7th/nvim-cmp",
		-- "L3MON4D3/LuaSnip",
		-- "saadparwaiz1/cmp_luasnip",
		-- "j-hui/fidget.nvim",
	},
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls" },
		})

		local lspconfig = require("lspconfig")
		local capabilities = vim.lsp.protocol.make_client_capabilities()

		local OcxideGroup = vim.api.nvim_create_augroup("ocxide", {})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = OcxideGroup,
			callback = function(event)
				-- local client = vim.lsp.get_client_by_id(args.data.client_id)

				require("ocxide-system.keymaps").load("lsp", { buffer = event.buf })
			end,
		})

		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
						},
						maxPreload = 100000,
						preloadFileSize = 10000,
					},
				},
			},
		})

		lspconfig.tsserver.setup({
			capabilities = capabilities,
			filetypes = {
				"typescript",
				"typescriptreact",
				"typescript.tsx",
				"javascript",
				"javascriptreact",
				"javascript.jsx",
			},
			root_dir = lspconfig.util.root_pattern("tsconfig.json", "jsconfig.json", "tsconfig.json", "jsconfig.json"),
		})

		lspconfig.angularls.setup({
			on_attach = function(client)
				client.server_capabilities.renameProvider = false
			end,
			capabilities = capabilities,
			filetypes = { "typescript", "html" },
			root_dir = lspconfig.util.root_pattern("angular.json"),
		})

		lspconfig.emmet_language_server.setup({
			filetypes = {
				"css",
				"eruby",
				"html",
				"javascript",
				"javascriptreact",
				"less",
				"sass",
				"scss",
				"pug",
				"typescriptreact",
				"astro",
			},
			-- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
			-- **Note:** only the options listed in the table are supported.
			init_options = {
				---@type table<string, string>
				includeLanguages = {},
				--- @type string[]
				excludeLanguages = {},
				--- @type string[]
				extensionsPath = {},
				--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
				preferences = {},
				--- @type boolean Defaults to `true`
				showAbbreviationSuggestions = true,
				--- @type "always" | "never" Defaults to `"always"`
				showExpandedAbbreviation = "always",
				--- @type boolean Defaults to `false`
				showSuggestionsAsSnippets = false,
				--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
				syntaxProfiles = {
					html = "xhtml",
				},
				--- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
				variables = {},
			},
		})

		lspconfig.cssls.setup({
			capabilities = capabilities,
			filetypes = { "css", "scss", "less" },
		})

		lspconfig.svelte.setup({
			capabilities = capabilities,
			filetypes = { "svelte" },
		})

		lspconfig.tailwindcss.setup({
			capabilities = capabilities,
			root_dir = lspconfig.util.root_pattern(
				"tailwind.config.js",
				"tailwind.config.mjs",
				"tailwind.config.cjs",
				"tailwind.config.ts"
			),
			filetypes = {
				"html",
				"astro",
				"markdown",
				"css",
				"postcss",
				"sass",
				"scss",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"svelte",
			},
			settings = {
				tailwindCSS = {
					classAttributes = { "class", "className", "class:list", "classList", "ngClass", ".*Class" },
					lint = {
						cssConflict = "warning",
						invalidApply = "error",
						invalidConfigPath = "error",
						invalidScreen = "error",
						invalidTailwindDirective = "error",
						invalidVariant = "error",
						recommendedVariantOrder = "warning",
					},
					validate = true,
				},
			},
		})

		lspconfig.astro.setup({
			capabilities = capabilities,
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}

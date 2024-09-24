return {
	"neovim/nvim-lspconfig",

	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",

		-- Completion
		"hrsh7th/nvim-cmp",

		-- Sources
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		-- Source for nvim api
		"hrsh7th/cmp-nvim-lua",
		-- Completion engine
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		-- "j-hui/fidget.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")

		local lspconfig = require("lspconfig")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls" },
			handlers = {
				-- default handler
				function(server_name)
					require("lspconfig")[server_name].setup({ capabilities = capabilities })
				end,
			},
		})

		local OcxideGroup = vim.api.nvim_create_augroup("ocxide", {})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = OcxideGroup,
			callback = function(event)
				require("ocxide-system.keymaps").load("lsp", { buffer = event.buf })
			end,
		})

		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "Lua 5.1" },
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
							[vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
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
				"vue",
			},
			root_dir = lspconfig.util.root_pattern("tsconfig.json", "jsconfig.json", "tsconfig.json", "jsconfig.json"),
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = "./node_modules/@vue/language-server",
						languages = { "vue" },
					},
				},
			},
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

		lspconfig.gopls.setup({
			capabilities = capabilities,
			settings = {
				gopls = {
					completeUnimported = true,
					usePlaceholders = true,
					analyses = {
						unusuedparams = true,
					},
				},
			},
		})

		lspconfig.volar.setup({
			capabilities = capabilities,
			filetypes = {
				"typescript",
				"javascript",
				"javascriptreact",
				"typescriptreact",
				"vue",
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-e>"] = cmp.mapping.abort(),
				-- I don't know what this does
				["<C-Space>"] = cmp.mapping.complete(),
				-- TODO: Keep only one
				["<C-l>"] = cmp.mapping.confirm({ select = true }),
				["<C-}>"] = cmp.mapping.confirm({ select = true }),
				["<C-CR>"] = cmp.mapping.confirm({ select = true }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
				{ name = "nvim_lua" },
			}, {
				{ name = "buffer" },
			}),
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

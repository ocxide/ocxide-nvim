return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local find_files = {
			hidden = true,
			file_ignore_patterns = {
				".git/",
				-- js
				"node_modules",
				"dist",
				-- rust
				"target",
			}
		}

		require("telescope").setup({
			pickers = {
				find_files = find_files,
			},
			extensions = {
				file_browser = {
					hidden = true,
					-- disables netrw and use telescope-file-browser in its place
					hijack_netrw = true,
					mappings = {
						["i"] = {
							-- your custom insert mode mappings
						},
						["n"] = {
							-- your custom normal mode mappings
						},
					},
				},
			},
		})
	end,
}

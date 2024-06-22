local create_finder = function(harpoon_files)
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	local finder = require("telescope.finders").new_table({
		results = file_paths,
	})

	return finder
end

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	config = function()
		local harpoon = require('harpoon')
		harpoon:setup({})

		-- basic telescope configuration
		local conf = require("telescope.config").values

		vim.api.nvim_create_user_command("HarpoonToggle", function()
			local harpoon_files = harpoon:list()

			require("telescope.pickers").new({}, {
				prompt_title = "Harpoon",
				finder = create_finder(harpoon_files),
				previewer = conf.file_previewer({}),
				sorter = conf.generic_sorter({}),
				attach_mappings = function(prompt_bufnr)
					require("ocxide-system.keymaps").load("harpoon_list", { buffer = prompt_bufnr },
						{ prompt_bufnr = prompt_bufnr, harpoon_files = harpoon_files })

					return true
				end
			}):find()
		end, {})
	end,
	actions = {
		remove_entry = function(opts)
			local state = require("telescope.actions.state")
			local selected_entry = state.get_selected_entry()
			local current_picker = state.get_current_picker(opts.prompt_bufnr)

			table.remove(opts.harpoon_files.items, selected_entry.index)
			current_picker:refresh(create_finder(opts.harpoon_files))
		end,
	}
}

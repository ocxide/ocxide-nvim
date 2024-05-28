return {
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup()
			require("ocxide-system.keymaps").load("trouble")
		end
	},
}

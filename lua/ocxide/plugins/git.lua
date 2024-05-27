return {
	"tpope/vim-fugitive",
	config = function()
		require("ocxide-system.keymaps").load("git_fugitive", { buffer = 0 })
	end
}

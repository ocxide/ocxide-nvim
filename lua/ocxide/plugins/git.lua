return {
	"tpope/vim-fugitive",
	config = function()
		require("ocxide-system.keymaps").load("git", { buffer = 0 })
	end
}

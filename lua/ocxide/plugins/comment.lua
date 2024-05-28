return {
	"numToStr/Comment.nvim",
	lazy = false,
	config = function()
		require("Comment").setup({
			toggler = {
				---Line-comment toggle keymap
				line = 'dcc',
				---Block-comment toggle keymap
				block = 'dbc',
			},
			---LHS of operator-pending mappings in NORMAL and VISUAL mode
			opleader = {
				---Line-comment keymap
				line = 'dc',
				---Block-comment keymap
				block = 'db',
			},
			---LHS of extra mappings
			extra = {
				---Add comment on the line above
				above = 'dcO',
				---Add comment on the line below
				below = 'dco',
				---Add comment at the end of line
				eol = 'dcA',
			},
			---Enable keybindings
			---NOTE: If given `false` then the plugin won't create any mappings
			mappings = {
				---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
				basic = true,
				---Extra mapping; `gco`, `gcO`, `gcA`
				extra = true,
			},
		})
	end,
}

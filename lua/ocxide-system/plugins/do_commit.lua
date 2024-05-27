local M = {}

-- TODO: set a correct highlight, refactor to properly depend on the corresponding plugings

local window_width = 100

local function open_info(gwidth, height, row)
	local status = vim.api.nvim_cmd({ cmd = "Git", args = { "status" } }, { output = true })

	local lines = {}
	for line in status:gmatch("[^\r\n]+") do
		table.insert(lines, line)
	end

	-- Create info view floating window (readonly)

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
	vim.api.nvim_buf_set_option(buf, "readonly", true)
	-- Mark as not modified, otherwise you'll get an error when
	-- attempting to exit vim.
	vim.api.nvim_buf_set_option(buf, "modified", false)

	local win = vim.api.nvim_open_win(buf, true, {
		title = " Git status ",
		relative = "editor",
		style = "minimal",
		border = "rounded",
		width = window_width,
		height = height,
		row = row,
		col = (gwidth - window_width) * 0.5,
	})

	vim.api.nvim_win_set_option(win, "winhl", "Normal:NormalFloat")

	vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<cr>", { noremap = true, silent = true })

	return { buf = buf, win = win }
end

function M.do_commit()
	vim.ui.input({ prompt = "Files to commit: " }, function (files)
		if files ~=nil and files ~= "" then
			vim.api.nvim_cmd({ cmd = "Git", args = { "add "..files } }, {})
		end

		local gheight = vim.api.nvim_list_uis()[1].height
		local gwidth = vim.api.nvim_list_uis()[1].width

		local info_height = math.min(32, gheight - 12)
		local prompt_height = 1

		local start_row = (gheight - (info_height + prompt_height)) * 0.5
		local info_row =  start_row - prompt_height

		local info = open_info(gwidth, info_height, info_row)
		local message_buf = vim.api.nvim_create_buf(false, true)

		local message_win = vim.api.nvim_open_win(message_buf, true, {
			title = " Commit message ",
			relative = "editor",
			style = "minimal",
			border = "rounded",
			width = window_width,
			height = prompt_height,
			row = start_row + info_height + prompt_height,
			col = (gwidth - window_width) * 0.5,
		})

		vim.api.nvim_win_set_option(message_win, "winhl", "Normal:TelescopePromptTitle")

		vim.api.nvim_feedkeys("i", "n", false)

		local function close_all()
				vim.api.nvim_win_close(message_win, true)
				vim.api.nvim_buf_delete(message_buf, { force = true })

				vim.api.nvim_win_close(info.win, true)
				vim.api.nvim_buf_delete(info.buf, { force = true })
		end

		vim.keymap.set('n', "<ESC>", close_all, { noremap = true, silent = true, buffer = message_buf })

		vim.keymap.set('i', "<CR>",
			function ()
				local message = vim.api.nvim_buf_get_lines(message_buf, 0, -1, true)[1]
				local response = vim.api.nvim_cmd(
						{ cmd = "Git", args = { "commit ".."-m \""..message.. "\"" } },
						{ output = true }
				)
				print(response)

				close_all()
			end,
			{ noremap = true, silent = true, buffer = message_buf }
		)
		end)
end

return M

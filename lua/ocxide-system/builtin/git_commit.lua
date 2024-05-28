local function listen_popup(buf)
	vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<cr>", { noremap = true, silent = true })
	vim.keymap.set('n', "<ESC>", "<cmd>close<cr>", { noremap = true, silent = true, buffer = buf })
end


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

local function do_commit()
	vim.ui.input({ prompt = "Files to commit: " }, function(files)
		if files ~= nil and files ~= "" then
			vim.api.nvim_cmd({ cmd = "Git", args = { "add " .. files } }, {})
		end

		local gheight = vim.api.nvim_list_uis()[1].height
		local gwidth = vim.api.nvim_list_uis()[1].width

		local info_height = math.min(32, gheight - 12)
		local prompt_height = 1

		local start_row = (gheight - (info_height + prompt_height)) * 0.5
		local info_row = start_row - prompt_height

		local info = open_info(gwidth, info_height, info_row)
		local prompt_buf = vim.api.nvim_create_buf(false, true)

		local prompt_window = vim.api.nvim_open_win(prompt_buf, true, {
			title = " Commit message ",
			relative = "editor",
			style = "minimal",
			border = "rounded",
			width = window_width,
			height = prompt_height,
			row = start_row + info_height + prompt_height,
			col = (gwidth - window_width) * 0.5,
		})


		vim.api.nvim_win_set_option(
			prompt_window,
			"winhl",
			"Normal:TelescopePromptNormal,FloatBorder:TelescopePromptBorder,FloatTitle:TelescopePromptTitle"
		)

		vim.api.nvim_feedkeys("i", "t", false)

		listen_popup(prompt_buf)

		local function go_normal()
			local keycommand = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
			vim.api.nvim_feedkeys(keycommand, "n", false)
		end


		local ocxide_commit = vim.api.nvim_create_augroup("ocxide_commit", { clear = true })

		local function close_info()
				vim.api.nvim_win_close(info.win, true)
				vim.api.nvim_buf_delete(info.buf, { force = true })
		end

		local function close_prompt()
				vim.api.nvim_win_close(prompt_window, true)
				vim.api.nvim_buf_delete(prompt_buf, { force = true })
		end

		vim.api.nvim_create_autocmd("WinClosed", {
			group = ocxide_commit,
			buffer = info.buf,
			callback = function()
				close_prompt()
				go_normal()
			end,
		})

		vim.api.nvim_create_autocmd("WinClosed", {
			group = ocxide_commit,
			buffer = prompt_buf,
			callback = function()
				close_info()
				go_normal()
			end,
		})

		vim.keymap.set('i', "<CR>",
			function()
				local message = vim.api.nvim_buf_get_lines(prompt_buf, 0, -1, true)[1]
				local response = vim.api.nvim_cmd(
					{ cmd = "Git", args = { "commit " .. "-m \"" .. message .. "\"" } },
					{ output = true }
				)
				print("Git response: "..response)

				close_prompt()
			end,
			{ noremap = true, silent = true, buffer = prompt_buf }
		)
	end)
end

return do_commit

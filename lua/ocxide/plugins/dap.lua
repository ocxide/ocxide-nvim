return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",

		-- For getting the debuggers
		"williamboman/mason.nvim",
	},
	config = function()
		require("dapui").setup()
		require("ocxide-system.keymaps").load("dap")

		local mason_register = require "mason-registry"

		local dap = require("dap")

		local delve = mason_register.get_package "delve"
		local delve_exe = delve:get_install_path() .. "/dlv"

		-- Golang
		dap.adapters.go = {
			type = 'server',
			port = '${port}',
			executable = {
				command = delve_exe,
				args = { 'dap', '-l', '127.0.0.1:${port}', '--log', '--log-output="dap"' },
				-- add this if on windows, otherwise server won't open successfully
				-- detached = false
			}
		}
		-- Headless mode, for testing the integration with IDEs. Run 'dlv dap -l 127.0.0.1:38697 --log --log-output="dap"' in a terminal
		--[[ dap.adapters.go = {
			type = "server",
			host = "127.0.0.1",
			port = 38697,
		} ]]

		-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
		dap.configurations.go = {
			{
				type = "go",
				name = "Debug test", -- configuration for debugging test files
				request = "launch",
				mode = "test",
				program = "${file}"
			},
			-- works with go.mod packages and sub packages
			{
				type = "go",
				name = "Debug test (go.mod)",
				request = "launch",
				mode = "test",
				program = "./${relativeFileDirname}"
			}
		}
	end,
}

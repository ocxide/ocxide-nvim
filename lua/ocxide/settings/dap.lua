--- Depends on: Mason
local M = {}

local mason_register = require "mason-registry"
local codelldb = mason_register.get_package "codelldb"
local extension_path = codelldb:get_install_path() .. "/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local lib_lldb_path = extension_path .. "lldb/lib/liblldb.so" -- Change this to your liblldb path (may vary on windows)

local port = "10002"

-- Source code of get_codelldb_adapter. See https://github.com/simrat39/rust-tools.nvim/blob/0cc8adab23117783a0292a0c8a2fbed1005dc645/lua/rust-tools/dap.lua#L8C1-L18C4
M.adapter = {
	type = "server",
	port = port,
	executable = {
		command = codelldb_path,
		args = { "--liblldb", lib_lldb_path, "--port", port },
	},
};

return M

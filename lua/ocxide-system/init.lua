-- lua fixes
table.unpack = table.unpack or unpack
-- end

local M = require('ocxide.mappings')

function CreateMappings(mappings)
	if mappings.lazy then
		return
	end

	for _, mapping in ipairs(mappings) do
		local mode, lhs, rhs, opts = table.unpack(mapping)
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

for _mgroup, mappings in pairs(M) do
	CreateMappings(mappings)
end

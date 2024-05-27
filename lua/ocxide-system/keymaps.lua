local user_mappings = require("ocxide.mappings")

function LoadMappigns(mappings)
	for _, mapping in ipairs(mappings) do
		local mode, lhs, rhs, opts = table.unpack(mapping)
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

function CreateMappings(mappings)
	if mappings.lazy then
		return
	end

	LoadMappigns(mappings)
end

for _mgroup, mappings in pairs(user_mappings) do
	CreateMappings(mappings)
end

local M = {}

--- @param mappingsName string keyname of the mapping
--- @param opts table | nil overrides the default opts of the mappings, does a table merge
function M.load(mappingsName, opts)
	--- @class Mappings
	--- @field [1] string mode
	--- @field [2] string lhs
	--- @field [3] string rhs
	--- @field [4] table|nil opts
	local mappings = user_mappings[mappingsName]

	if mappings == nil then
		vim.notify("Could not load mappings: " .. mappingsName .. " - Not found", vim.log.levels.ERROR)
		return
	end

	if opts ~= nil then
		mappings[4] = mappings[4] or {}
		local mappingsOpts = mappings[4]

		for k, v in ipairs(opts) do
			mappingsOpts[k] = v
		end
	end

	LoadMappigns(mappings)
end

return M

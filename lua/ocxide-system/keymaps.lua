local user_mappings = require("ocxide.mappings")

local function merge_opts(opts, user_opts)
	opts = opts or {}

	if user_opts == nil then
		return opts
	end

	for k, v in pairs(user_opts) do
		opts[k] = v
	end

	return opts
end

--- @param user_opts table | nil
--- @param args table | nil custom args that will be passed to the mappings
local function loadMappigns(mappings, user_opts, args)
	for _, mapping in ipairs(mappings) do
		local mode, lhs, rhs, opts = table.unpack(mapping)
		opts = merge_opts(opts, user_opts)

		if type(rhs) == "function" and args ~= nil then
			local old_rhs = rhs
			rhs = function()
				return old_rhs(args)
			end
		end

		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

local function createMappings(mappings)
	if mappings.lazy then
		return
	end

	loadMappigns(mappings)
end

for _mgroup, mappings in pairs(user_mappings) do
	createMappings(mappings)
end

local M = {}

--- @param mappingsName string keyname of the mapping
--- @param opts table | nil overrides the default opts of the mappings, does a table merge
--- @param args table | nil custom args that will be passed to the mappings
function M.load(mappingsName, opts, args)
	--- @type number[] | nil
	local mappings = user_mappings[mappingsName]

	if mappings == nil then
		vim.notify("Could not load mappings: " .. mappingsName .. " - Not found", vim.log.levels.ERROR)
		return
	end

	loadMappigns(mappings, opts, args)
end

return M

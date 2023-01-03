--[[
   Copyright 2023 Alejandro "HiPhish" Sanchez
   Copyright 2020-2022 Chinmay Dalal

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--]]

local configs = require 'nvim-treesitter.configs'

---Library of shared internal functions and variables.
local M = {}

M.nsid = vim.api.nvim_create_namespace("rainbow_ns")

---Maps a buffer ID to the buffer's parser; retaining a reference prevents the
---parser from getting garbage-collected.
M.buffer_parsers = {}
M.state_table = {}

---Find the nesting level of a node.
---@param node table # Node to find the level of
---@param levels table # Levels for the language
---@return number level  Level of the node, does not wrap around
function M.node_level(node, levels)
	local counter = 0
	local current = node
	local found = false
	while current:parent() ~= nil do
		if levels then
			if levels[current:type()] then
				counter = counter + 1
				found = true
			end
		else
			counter = counter + 1
			found = true
		end
		current = current:parent()
	end
	if not found then
		return 1
	end
	return counter
end

---Get the appropriate highlight group for the given level of nesting.
---@param i number  One-based index into the highlight groups
---@return string hlgroup  Name of the highlight groups
function M.hlgroup_at(i)
	local hlgroups = configs.get_module('rainbow').hlgroups
	return hlgroups[(i - 1) % #hlgroups + 1]
end

return M

-- vim:tw=79:ts=4:sw=4:noet:

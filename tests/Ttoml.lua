local included = pcall(debug.getlocal, 5, 1)
local T = require("u-test")
local toml = require("toml")
local string_1 = function()
	local s = [=[
		[[list.songs]]
		name = "Dead"
	]=]
	local t = toml.parse(s)
	T.is_table(t)
	T.is_table(t.list)
	T.is_table(t.list.songs)
	T.expected("Dead")(t.list.songs[1]["name"])
end
if included then
	return function()
		T["string 1"] = string_1
	end
else
	T["string 1"] = string_1
end

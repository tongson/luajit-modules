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
local string_2 = function()
	local s = [[
		test = 1
	]]
	local t = toml.parse(s)
	T.is_table(t)
	T.expected(1)(t.test)
end
if included then
	return function()
		T["string 1"] = string_1
		T["string 2"] = string_2
	end
else
	T["string 1"] = string_1
	T["string 2"] = string_2
end

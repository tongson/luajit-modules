local included = pcall(debug.getlocal, 5, 1)
arg.path = {}
arg.path.ffi = "./tests"
local T = require("u-test")
local S = require("std")
local blake3 = require("blake3")

local hash = function()
	T.equal(
		"4878ca0425c739fa427f7eda20fe845f6b2e46ba5fe2a14df5b1e32f50603215",
		blake3.hash("test")
	)
end
local binary = function()
	p = S.file.read("tests/libljblake3.so.0.2.0")
	T.equal("5fe7d39eb0bb036e2e0ecc8942d75b1b83539039b95795cceb0dc5e1cdc386fc", blake3.hash(p))
end
if included then
	return function()
		T["ffi_blake3.hash"] = hash
		T["ffi_blake3.hash (binary)"] = binary
	end
else
	T["ffi_blake3.hash"] = hash
	T["ffi_blake3.hash (binary)"] = binary
end

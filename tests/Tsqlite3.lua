local included = pcall(debug.getlocal, 5, 1)
arg.path = {}
arg.path.ffi = "./tests"
local T = require("u-test")
local sql = require("sqlite3")
local conn = sql.open("") -- Open a temporary in-memory database.

-- Execute SQL commands separated by the ';' character:
conn:exec("CREATE TABLE t(id TEXT, num REAL); INSERT INTO t VALUES('myid1', 200);")
-- Prepared statements are supported:
local stmt = conn:prepare("INSERT INTO t VALUES(?, ?)")
for i = 2, 4 do
	stmt:reset():bind("myid" .. i, 200 * i):step()
end

-- Command-line shell feature which here prints all records:
local t = conn:exec("SELECT * FROM t")
local test1 = function()
	T.equal(t[1], t.id)
	T.equal(t[2], t.num)
	T.equal(t[1][1], "myid1")
	T.equal(t[1][2], "myid2")
	T.equal(t[1][3], "myid3")
	T.equal(t[1][4], "myid4")
	T.equal(t["num"][1], 200)
	T.equal(t["num"][2], 400)
	T.equal(t["num"][3], 600)
	T.equal(t["num"][4], 800)
end

-- Convenience function returns multiple values for one record:
local id, num = conn:rowexec("SELECT * FROM t WHERE id=='myid3'")
local test2 = function()
	T.equal(id, "myid3")
	T.equal(num, 600)
end

-- Custom scalar function definition, aggregates supported as well.
local fn = function(x)
	return x / 100
end
conn:setscalar("MYFUN", fn)
local t2 = conn:exec("SELECT MYFUN(num) FROM t")
local test3 = function()
	T.equal(t2[1][1], 2)
	T.equal(t2[1][2], 4)
	T.equal(t2[1][3], 6)
	T.equal(t2[1][4], 8)
end

conn:exec("CREATE TABLE it(id TEXT, num REAL); INSERT INTO it VALUES('imyid1', 200); INSERT INTO it VALUES('imyid2', 400);")
local stmt2 = conn:prepare("SELECT * FROM it")
local x = {}
for row in stmt2:rows() do
	x[#x + 1] = row[1]
	x[#x + 1] = row[2]
end
local test4 = function()
	T.equal(x[1], "imyid1")
	T.equal(x[2], 200)
	T.equal(x[3], "imyid2")
	T.equal(x[4], 400)
end

if included then
	return function()
		T["test1 (prepared statements and conn:exec)"] = test1
		T["test2 (conn:rowexec)"] = test2
		T["test3 (custom scalar function)"] = test3
		T["test4 (rows iterator)"] = test4
	end
else
	T["test1 (prepared statements and conn:exec)"] = test1
	T["test2 (conn:rowexec)"] = test2
	T["test3 (custom scalar function)"] = test3
	T["test4 (rows iterator)"] = test4
end

conn:close() -- Close stmt as well.

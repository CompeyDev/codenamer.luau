local INFINITE_MATH_AUTHOR = "kdudedev"
local INFINITE_MATH_PKGNAME = "infinite-math"
local INFINITE_MATH_PKGVER = "1.3.2"
local INFINITE_MATH_PATH = string.format(
	"../Packages/_Index/%s@%s/%s/src/InfiniteMath/infinite_math",
	INFINITE_MATH_AUTHOR .. "_" .. INFINITE_MATH_PKGNAME,
	INFINITE_MATH_PKGVER,
	INFINITE_MATH_PKGNAME
)

local InfiniteMath = require(INFINITE_MATH_PATH)

type any_table = { [any]: any }

local Codenamer = {}

Codenamer.Type = "Codenamer"

Codenamer.Interface = {}
Codenamer.Internal = {}
Codenamer.Prototype = {
	Dicts = {
		Type = "Default",
		[1] = require("./dictionaries/adjectives"),
		[2] = require("./dictionaries/animals"),
	},
}

-- Simple mullbery32 implementation
function Codenamer.Internal.mul32(a: number)
	return function()
		a += InfiniteMath.new(1831565813)
		local t = a:Reverse()
		local m = InfiniteMath.new(4294967296)

		t = bit32.bxor(t, bit32.rshift(t, 15) * bit32.bor(t, 1))
		t = t + bit32.bxor(t, bit32.bxor(t, bit32.rshift(t, 7)), bit32.bor(t, 61))

		return ((bit32.rshift(bit32.bxor(t, bit32.rshift(t, 14)), 0)) / m):Reverse()
	end
end

function Codenamer.Internal:from_seed(min: number, max: number, seed: number?): number
	local gen_seed = self.mul32((os.time() - os.clock() * 1000))
	math.randomseed(seed or (gen_seed() * 1000))

	return math.random(min, max)
end

function Codenamer.Prototype:to_string(): string
	return string.format("%s<%s>", Codenamer.Type, self.Dicts.Type)
end

function Codenamer.Internal:random_word(dict: any_table, seed: number?): string
	return dict[self:from_seed(1, #dict, seed)]
end

function Codenamer.Prototype:with_dictionary(dict: any_table)
	if self.Dicts["Type"] == "Default" then
		self.Dicts = {}
		self.Dicts["Type"] = "Custom"
	end

	table.insert(self.Dicts, dict)

	return self
end

function Codenamer.Prototype:get_codename(sep_str: string?, len: number)
	local codename = ""
	self.Dicts["Type"] = nil

	for idx, dict in self.Dicts do
        if len and idx - 1 > len then break end 

		local sep = ""

		if idx ~= 1 then
			sep = sep_str or "_"
		end

		codename ..= sep .. self.Internal:random_word(dict)
	end

	return codename
end

function Codenamer.Interface.new()
	Codenamer.Prototype.Internal = Codenamer.Internal

	return setmetatable({}, {
		__index = Codenamer.Prototype,
		__type = Codenamer.Type,
		__tostring = function(self)
			return self:to_string()
		end,
	})
end

return Codenamer.Interface

--[[
    examples/tostring.luau

    Description: Codenamer implements a custom tostring metamethod, which returns a "generic type"
                 based on the state of the codenamer instance.
]]--

local Codenamer = require("../dist/codenamer")

local codenamer = Codenamer.new()

print("I have a codenamer instance of type:", tostring(codenamer))

codenamer:with_dictionary({ "this", "is", "a", "custom", "dictionary" })

print("With a custom dictionary provided, the instance is now of type: ", tostring(codenamer))

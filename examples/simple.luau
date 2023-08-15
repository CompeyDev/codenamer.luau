local Codenamer = require("../dist/codenamer")

-- Codenamer also allows for optional separators. Here, we tell codenamer to 
-- use a space instead of `_`, which is the default separator for words.
local codename = Codenamer.new()
    :get_codename(" ")

print("got codename: ", codename)

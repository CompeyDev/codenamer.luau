local Codenamer = require("../dist/codenamer")
local stdio = require("@lune/stdio")
local process = require("@lune/process")
local task = require("@lune/task")

local INTERVAL_WAIT_TIME = 1

local _, count = xpcall(
    function ()
        return tonumber(stdio.prompt("text", "Number of codenames to be requested: "))
    end,
    
    function ()
        warn("Please enter a valid number.")
        process.exit(1)
    end
)
local fmt_type = stdio.prompt(
    "select", 
    "What type of formatting should the codenames use?", 
    { "Phrase-like", "Variable-like" }
)

local sep: string? 

if fmt_type == 1 then
    sep = " "
elseif fmt_type == 2 then
    sep = nil
end


local codenames: string | {[number]: string} = {}

print(`Generating codenames, expected wait time: {INTERVAL_WAIT_TIME * count}s.`)

local i: number = 1
repeat
    table.insert(codenames, Codenamer.new():get_codename(sep))
    i += 1

    -- Gather some entropy by waiting
    task.wait(INTERVAL_WAIT_TIME / 10)
until i - 1  == count

-- Codenamer also allows for optional separators. Here, we tell codenamer to 
-- use a space instead of `_`, which is the default separator for words.

local fmt_arrow = "\n╰╸╾> "

codenames = table.concat(codenames, fmt_arrow)

print("===============")
print("Generated codenames:")
print(fmt_arrow .. codenames)
print("===============")

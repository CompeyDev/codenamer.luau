--[[
    examples/custom.luau

    Description: A slightly modified version of the simple example, including
                 custom dictionaries.
]]--

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


local codenamer = Codenamer.new()

-- NOTE: It is recommended to cache built-in dictionaries into variables before passing 
-- them to with_dictionary, as the internal dictionaries may be overwritten at any 
-- time when a custom dictionary is specified.
local adjectives_dict = codenamer.Dicts[1]   
local colors_dict = codenamer.Dicts[2]

codenamer
    :with_dictionary(adjectives_dict) -- Adjectives built in dictionary
    :with_dictionary(colors_dict) -- Colors built in dictionary
    :with_dictionary({ "human", "alien", "animal" }) -- Custom dictionary


local i: number = 1
repeat
    table.insert(
        codenames, 
        codenamer:get_codename(sep)
    )

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

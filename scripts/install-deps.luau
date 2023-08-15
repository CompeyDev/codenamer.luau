--!strict
local fs = require("@lune/fs")
local process = require("@lune/process")

local DEPENDENCY_META = table.freeze({
    {
        ["author"] = "kdudedev",
        ["pkgname"] = "infinite-math",
        ["version"] = "1.3.2"
    }
})

local match = function (val, arms: {[any]: any}): any? 
    if arms[val] then
        if typeof(arms[val]) == 'function' then
            return arms[val]()
        else
            return arms[val]
        end
    elseif _G["DEBUG"] then
        print("non exhuastive pattern for ", val)
    end


    if arms["_"] then
        if typeof(arms["_"]) == 'function' then
            return arms["_"]()
        else
            return arms["_"]
        end
    end
end


local log = function (kind: "ERROR" | "INFO" | "WARN", msg: string)
    local prefix = match (kind, {
        ["ERROR"] = "[!]",
        ["INFO"] = "[*]",
        ["WARN"] = "[#]",
        ["_"] = function ()
            error("invalid log kind")
        end
    })

    print(`{prefix} {msg}`)
end


-- Converts kebab-case to upper CamelCase
local to_camel_case = function (str: string)
   local parts = string.split(str, "-") 

    for pos, part in parts do
        parts[pos] = string.gsub(part, "^%l", string.upper)
    end

    return table.concat(parts, "")
end

-- Converts kebab-case to upper snake_case
local to_snake_case = function (str: string)
   local parts = string.split(str, "-") 

    return table.concat(parts, "_")
end

for _, cmd in { "aftman", "wally" } do
    log("INFO", `Running \`{cmd} install\``)

    process.spawn("sh", { "-c", `{cmd} install`, "|", `sed 's/^/[{cmd}]: /'` }, {
        ["stdio"] = "inherit"
    })
end

for _, DEPENDENCY_DATA in DEPENDENCY_META do
    local start = os.clock()

    local dependency_src_dir = `Packages/_Index/{DEPENDENCY_DATA.author}_{DEPENDENCY_DATA.pkgname}@{DEPENDENCY_DATA.version}/{DEPENDENCY_DATA.pkgname}/src/{to_camel_case(DEPENDENCY_DATA.pkgname)}`
    local entrypoint_path = dependency_src_dir .. "/init.lua"
    local values_dir: string?

    if DEPENDENCY_DATA.pkgname == "infinite-math" then values_dir = dependency_src_dir .. "/Values" end

    log("INFO", `Constructed entrypoint path for {DEPENDENCY_DATA.pkgname} -> {string.sub(entrypoint_path, 1, #entrypoint_path - 45) .. "..."}`)

    if not fs.metadata(entrypoint_path).exists then
        log("ERROR", `Could not find {DEPENDENCY_DATA.pkgname} entrypoint file`)
        process.exit(1)
    end
 
    if values_dir then
        log("INFO", `Patching values for {DEPENDENCY_DATA.pkgname}`)

        for _, file in fs.readDir(values_dir) do
            fs.move(values_dir .. "/" .. file, dependency_src_dir .. "/" .. file)
        end

        fs.removeDir(values_dir)
        
        local entrypoint_contents = fs.readFile(entrypoint_path)
        entrypoint_contents = string.gsub(entrypoint_contents, "local values = script.Values", "")
        entrypoint_contents = string.gsub(entrypoint_contents, "values.Suffixes", "./Suffixes.lua")
        entrypoint_contents = string.gsub(entrypoint_contents, "values.FullNames", "./FullNames.lua")

        fs.writeFile(dependency_src_dir .. "/" .. to_snake_case(DEPENDENCY_DATA.pkgname) .. ".lua", entrypoint_contents)

        log("INFO", `Patched values for {DEPENDENCY_DATA.pkgname}`)
    end

    log("INFO", `Done with {DEPENDENCY_DATA.pkgname} in {string.sub(tostring(os.clock() - start), 1, 5)}s`)
end


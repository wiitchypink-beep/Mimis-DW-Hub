-- Mimi's DW Hub | GitHub loader
-- Replace YOUR_GITHUB_USERNAME with your GitHub username after uploading these files.
local OWNER = "witchypink-beep"
local REPO = "Mimis-DW-Hub"
local BRANCH = "main"
assert(OWNER ~= "YOUR_GITHUB_USERNAME", "Set your GitHub username in Mimi's loader first.")

local folder = "MimisDWHub"
local base = "https://raw.githubusercontent.com/" .. OWNER .. "/" .. REPO .. "/" .. BRANCH .. "/"
if type(makefolder) == "function" then
    local exists = false
    if type(isfolder) == "function" then
        local ok, value = pcall(isfolder, folder)
        exists = ok and value
    end
    if not exists then pcall(makefolder, folder) end
end

local function fetch(path)
    local ok, result = pcall(function()
        return game:HttpGet(base .. path, true)
    end)
    if ok and type(result) == "string" and #result > 0 then
        return result
    end
    warn("[Mimi Loader] Download failed:", path, result)
    return nil
end

-- Store the smooth colour-wheel PNG in Madium's workspace, only when needed.
local wheelPath = folder .. "/wheel.png"
local wheelExists = false
if type(isfile) == "function" then
    local ok, value = pcall(isfile, wheelPath)
    wheelExists = ok and value
end
if not wheelExists and type(writefile) == "function" then
    local bytes = fetch("wheel.png")
    if bytes and bytes:sub(1, 8) == "\137PNG\r\n\26\n" then
        local ok, err = pcall(writefile, wheelPath, bytes)
        if not ok then warn("[Mimi Loader] Wheel couldn't be saved:", err) end
    end
end

local source = fetch("hub.lua")
if source and type(writefile) == "function" then
    pcall(writefile, folder .. "/hub.lua", source) -- keep a local copy
end
if not source and type(readfile) == "function" and type(isfile) == "function" then
    local ok, exists = pcall(isfile, folder .. "/hub.lua")
    if ok and exists then
        local readOk, cached = pcall(readfile, folder .. "/hub.lua")
        if readOk and type(cached) == "string" then
            source = cached
            warn("[Mimi Loader] Loading the last locally saved version.")
        end
    end
end
assert(source, "Mimi's hub could not be downloaded or loaded from cache.")
local chunk, compileError = loadstring(source)
assert(chunk, "Mimi's hub syntax error: " .. tostring(compileError))
local ok, runtimeError = pcall(chunk)
if not ok then warn("[Mimi Loader] Hub error:", runtimeError) end
